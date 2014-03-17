#! /usr/bin/env ./node_modules/.bin/coffee
express             = require 'express'
app                 = express()
path                = require 'path'
_                   = require 'underscore'
log                 = require 'simplog'
child_process       = require 'child_process'
socketCommandServer = require 'command-server'
fs                  = require 'fs'

commandDirPath = path.join(process.env.ROOT_DIR, "/src/commands")
# artifact, not sure this is really needed (static dir)
app.use "/static", express.static(path.join(process.env.ROOT_DIR, "/static"))
process.env.STORAGE_ROOT = process.env.STORAGE_ROOT || path.join(process.env.HOME, "/skyapi_storage")

if not fs.existsSync process.env.STORAGE_ROOT
  fs.mkdirSync process.env.STORAGE_ROOT

statusMessage =
  message: "ok",
  sha: process.env.RUNNING_SHA

# get the sha under which we're running... assuming we're using git and are
# in a valid repo of course
child_process.exec "git log -1 --oneline | awk '{ print $1 }'", (err, stdout, stderr) ->
  log.info 'getting executing version information'
  if err
    statusMessage.sha="error getting sha"
    log.error 'error getting executing version information'
    log.error err
  else
    statusMessage.sha=stdout.toString('utf8').replace("\n","")
    log.info "executing version info: #{statusMessage.sha}"

# a convenience 'healthy' endpoint to that will provide a way to tell if the 
# app is running and at what version
app.all '*', (req, resp) -> resp.send statusMessage
log.info "ROOT_DIR #{process.env.ROOT_DIR}"
log.debug "debug logging enabled"
log.info "STORAGE_ROOT #{process.env.STORAGE_ROOT}"
if not fs.existsSync(process.env.STORAGE_ROOT)
  log.debug "creating storage root"
  fs.mkdirSync(process.env.STORAGE_ROOT)
log.info "SERVER_PORT #{process.env.PORT || 8080}"
socketCommandServer(app, commandDirPath).listen process.env.PORT || 8080

