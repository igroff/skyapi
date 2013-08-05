path  = require 'path'
fs    = require 'fs'
util  = require 'util'
core  = require './core.coffee'


module.exports.execute = (logData, context, cb) ->
  parseFileData = (err, fileData) ->
    if err
      cb err
    else
      str = fileData.toString('utf8').replace(/\n/g, ",")
      str = "[" + str.substr(0, str.length - 1) + "]"
      core.log.debug str
      cb null, JSON.parse(str)
  fs.readFile core.createLogPath(logData, context), parseFileData
