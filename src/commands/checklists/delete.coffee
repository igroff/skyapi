path  = require 'path'
fs    = require 'fs'
core  = require './core.coffee'

module.exports.execute = (checklist, context, cb) ->
  fs.unlink core.filePathForChecklist(checklist), cb
