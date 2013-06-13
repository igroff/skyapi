path  = require 'path'
fs    = require 'fs'
util  = require 'util'
core  = require './core.coffee'

module.exports.execute = (name, context, cb) ->
  loadHandler = (err, data) ->
    if data
      cb(err, JSON.parse(data.toString('utf8')))
    else
      cb(err, data)
  fs.readFile core.filePathForChecklist(name), loadHandler
