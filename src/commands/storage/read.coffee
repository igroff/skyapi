fs    = require 'fs'
core  = require './core.coffee'

module.exports.execute = (key, context, cb) ->
  loadHandler = (err, data) ->
    cb(err, JSON.parse(data.toString('utf8')))
  fs.readFile core.filePathForStorage(key, context.uid), loadHandler
