path  = require 'path'
fs    = require 'fs'
util  = require 'util'
core  = require './core.coffee'


module.exports.execute = (logData, context, cb) ->
  logFilePath = core.createLogPath logData, context
  dirMakingCb = (err) ->
    if err
      fs.mkdirSync path.dirname(logFilePath)
      fs.appendFile logFilePath, util.format("%j\n", logData), cb
    cb null
  fs.appendFile logFilePath, util.format("%j\n", logData), dirMakingCb
