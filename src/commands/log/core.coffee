_     = require 'underscore'
path  = require 'path'
fs    = require 'fs'
log   = require 'simplog'
util  = require 'util'

storageRoot = path.join process.env.STORAGE_ROOT, 'logs'

if not fs.existsSync storageRoot
  fs.mkdirSync storageRoot

createLogPath = (logData, context) ->
  if logData.logName
    logFile = path.join(storageRoot, context.uid, util.format('%s.log', logData.logName))
    thisFileRoot = path.basename logFile
    if not fs.existsSync thisFileRoot
      fs.mkdirSync thisFileRoot
  else
    logFile = path.join(storageRoot, util.format('%s.log', context.uid))
  log.debug "createLogPath: #{logFile}"
  logFile

module.exports.createLogPath = createLogPath
module.exports.log = log
