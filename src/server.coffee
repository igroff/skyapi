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
app.use "/static", express.static(path.join(process.env.ROOT_DIR, "/static"))
process.env.STORAGE_ROOT = process.env.STORAGE_ROOT || path.join(process.env.ROOT_DIR, "/storage")

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

auth = requireIfThere 'authorize.coffee'

io.configure () ->
  io.set 'authorization', auth
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
      if requireError.code isnt 'MODULE_NOT_FOUND'
        log.error "error loading command #{commandName} #{requireError} #{typeof requireError}"
        socket.emit 'commandError', "#{requireError}"
        throw requireError
      else
        errorObject =
          state:"error"
          message: "unable to find command named: #{commandName}"
        if typeof(cb) is "function"
          cb errorObject
        else
          socket.emit 'commandError', errorObject
    if commandFn
      if cb
        commandArgs.push cb
      commandFn.apply commandFn, commandArgs
    else
      log.warn "no command found for %s", commandName

app.all '*', (req, resp) -> resp.send {"message": "ok", "sha": process.env.RUNNING_SHA}
log.debug "starting server"
log.debug "ROOT_DIR #{process.env.ROOT_DIR}"
log.debug "SERVER_PORT #{process.env.SERVER_PORT}"
server.listen process.env.SERVER_PORT || 8080
