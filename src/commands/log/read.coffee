path  = require 'path'
log   = require 'simplog'
fs    = require 'fs'
util  = require 'util'

storageRoot = process.env.STORAGE_ROOT

module.exports.execute = (logData, context, cb) ->
  if logData.logName
    logFile = path.join(storageRoot, context.uid, util.format('%s.log', logData.logName))
  else
    logFile = path.join(storageRoot, util.format('%s.log', context.uid))
  parseFileData = (err, fileData) ->
    if err
      cb err
    else
      str = fileData.toString('utf8').replace(/\n/g, ",")
      str = "[" + str.substr(0, str.length - 1) + "]"
      log.debug str
      cb null, JSON.parse(str)
  fs.readFile logFile, parseFileData
