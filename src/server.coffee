#! /usr/bin/env ./node_modules/.bin/coffee
express       = require 'express'
app           = express()
server        = require('http').createServer(app)
io            = require('socket.io').listen(server)
_             = require 'underscore'
path          = require 'path'
fs            = require 'fs'
log           = require './log.coffee'
child_process = require 'child_process'

commandDirPath = path.join(process.env.ROOT_DIR, "/src/commands")
# artifact, not sure this is really needed (static dir)
app.use "/static", express.static(path.join(process.env.ROOT_DIR, "/static"))
process.env.STORAGE_ROOT = process.env.STORAGE_ROOT || path.join(process.env.ROOT_DIR, "/storage")

# get the sha under which we're running... assuming we're using git and are
# in a valid repo of course
child_process.exec "git log -1 --oneline | awk '{ print $1 }'", (err, stdout, stderr) ->
  if err
    process.env.RUNNING_SHA="error getting sha"
  else
    process.env.RUNNING_SHA=stdout.toString('utf8').replace("\n","")

requireIfThere = (requirePath) ->
    commandPath = path.join commandDirPath, requirePath
    if fs.existsSync(commandPath)
      require(commandPath).config? process.env
      return require(commandPath).execute
    else
      log.info "no command found for %s, not loading", commandPath
    return null

io.configure () ->
  # if there has been an authorization command provided, use it 
  # otherwise...  use nothing
  io.set 'authorization', requireIfThere('authorize.coffee') || ->
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

# a convenience 'healthy' endpoint to that will provide a way to tell if the 
# app is running and at what version
app.all '*', (req, resp) -> resp.send {"message": "ok", "sha": process.env.RUNNING_SHA}
log.debug "ROOT_DIR #{process.env.ROOT_DIR}"
log.debug "SERVER_PORT #{process.env.SERVER_PORT}"
server.listen process.env.SERVER_PORT || 8080
