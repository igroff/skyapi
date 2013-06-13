path  = require 'path'
log   = require '../../log.coffee'
fs    = require 'fs'
util  = require 'util'

storageRoot = process.env.STORAGE_ROOT

module.exports.execute = (position, context, cb) ->
  logFile = path.join(storageRoot, util.format('%s.loc.log', context.uid))
  parseFileData = (err, fileData) ->
    if not err
      str = fileData.toString('utf8').replace(/\n/g, ",")
      str = "[" + str.substr(0, str.length - 1) + "]"
      log.debug str
      log.debug "pt"
      cb(JSON.parse(str))
    else
      cb "error loading entries"
  fs.readFile logFile, parseFileData
  
