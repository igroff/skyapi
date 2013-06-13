path  = require 'path'
fs    = require 'fs'
util  = require 'util'
core  = require './core.coffee'

module.exports.execute = (checklist, context, cb) ->
  fs.writeFile core.filePathForChecklist(checklist), util.format("%j", checklist), cb
