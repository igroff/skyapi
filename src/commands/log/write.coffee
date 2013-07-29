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
  dirMakingCb = (err) ->
    if err
      fs.mkdirSync path.dirname(logFile)
      fs.appendFile logFile, util.format("%j\n", logData), cb
    cb null

  fs.appendFile logFile, util.format("%j\n", logData), dirMakingCb
  
