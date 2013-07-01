fs    = require 'fs'
core  = require './core.coffee'

module.exports.execute = (key, context, cb) ->
  loadHandler = (err, data) ->
    data = JSON.parse(data.toString('utf8')) if data
    cb(err, data)
  fs.readFile core.filePathForStorage(key, context.uid), loadHandler
