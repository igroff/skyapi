#! /usr/bin/env ./node_modules/.bin/coffee
express             = require 'express'
app                 = express()
path                = require 'path'
_                   = require 'underscore'
log                 = require 'simplog'
child_process       = require 'child_process'
socketCommandServer = require 'command-server'

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


# a convenience 'healthy' endpoint to that will provide a way to tell if the 
# app is running and at what version
statusMessage =
  message: "ok",
  sha: process.env.RUNNING_SHA
app.all '*', (req, resp) -> resp.send statusMessage
log.debug "ROOT_DIR #{process.env.ROOT_DIR}"
log.debug "SERVER_PORT #{process.env.SERVER_PORT || 8080}"
socketCommandServer(app, commandDirPath).listen process.env.SERVER_PORT || 8080
