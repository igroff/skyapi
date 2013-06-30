path      = require 'path'
log       = require 'simplog'
fs        = require 'fs'
http      = require 'http'
socketIo  = require 'socket.io'
_         = require 'underscore'


mountSocketIo = (expressApp, commandDirPath) ->

  requireIfPresent = (requirePath) ->
      commandPath = path.join commandDirPath, requirePath
      if fs.existsSync(commandPath)
        require(commandPath).config? process.env
        return require(commandPath).execute
      else
        log.info "no command found for %s, not loading", commandPath
      return null

  httpServer = http.createServer expressApp
  io = socketIo.listen(httpServer)
  io.configure () ->
    # if there has been an authorization command provided, use it 
    # otherwise...  use nothing
    io.set 'authorization', requireIfPresent('authorize.coffee') || ->
    io.set 'log level', 0

  io.sockets.on 'connection', (socket) ->
    socket.$emit = (commandName, data, cb) ->
      log.debug "received message %s, data %j", commandName, data
      commandArgs = [socket.handshake]
      if typeof(data) is "function"
        log.debug "no data, only a callback"
        cb = data
      else if _.isArray data
        log.debug "multiple parameters found for command"
        commandArgs = data
        commandArgs.push socket.handshake
      else
        log.debug "nothing special about our data"
        commandArgs.unshift data
      commandFn = null
      try
        commandPath = path.join(commandDirPath, "#{commandName}.coffee")
        log.debug "loading command from: #{commandPath}"
        require(commandPath).config? process.env
        commandFn = require(commandPath).execute
      catch requireError
        log.error requireError
        if requireError.code is 'MODULE_NOT_FOUND'
          errorObject =
            state:"error"
            message: "unable to find command named: #{commandName}"
          if typeof(cb) is "function"
            cb errorObject
          else
            socket.emit 'commandError', errorObject
          # all done
          return
        else
          log.error "error loading command #{commandName} #{requireError} #{typeof requireError}"
          socket.emit 'commandError', "#{requireError}"
          throw requireError

      if commandFn
        commandArgs.push cb if cb
        commandFn.apply commandFn, commandArgs
      else
        msg = "no execute method for command #{commandName}"
        cb msg if cb
  httpServer

module.exports = mountSocketIo
