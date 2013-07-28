util  = require 'util'
fs    = require 'fs'
core  = require './core.coffee'
log   = core.log

# callback(err) 
module.exports.execute = (obj, context, cb) ->
  storagePath = core.filePathForStorage(obj, context.uid)
  log.info "storing data to #{storagePath}"
  if not storagePath
    cb("unable to create storage path for object")
  else
    fs.writeFile storagePath, util.format("%j", obj), cb
