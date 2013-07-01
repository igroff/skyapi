fs    = require 'fs'
core  = require './core.coffee'

module.exports.execute = (context, cb) ->
  loadHandler = (err, files) ->
    if err
      cb(err, null)
    else
      cb(null, name.replace(/\.json/, '') for name in files)
  fs.readdir core.storageRoot, loadHandler
