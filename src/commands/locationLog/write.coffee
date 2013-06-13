path  = require 'path'
log   = require '../../log.coffee'
fs    = require 'fs'
util  = require 'util'

storageRoot = process.env.STORAGE_ROOT

module.exports.execute = (position, context, cb) ->
  logFile = path.join(storageRoot, util.format('%s.loc.log', context.uid))
  fs.appendFile logFile, util.format("%j\n", position), cb
  
