util  = require 'util'
fs    = require 'fs'
core  = require './core.coffee'

module.exports.execute = (obj, context, cb) ->
  fs.writeFile core.filePathForStorage(obj, context.uid), util.format("%j", obj), cb
