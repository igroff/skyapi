fs    = require 'fs'
core  = require './core.coffee'
_     = require 'underscore'

module.exports.execute = (data, context, cb) ->
  # if we have only two arguments the it will only be context and
  # a callback
  core.log.debug "list arguments: #{_.toArray(arguments)}"  
  if arguments.length is 2
    cb = context
    context = data
    data = null
  loadHandler = (err, files) ->
    if err
      cb(err, null)
    else
      core.log.debug "files #{files}"
      cb(null, name.replace(/\.json/, '') for name in files)
  data = {"type": data} if _.isString data
  dirPathForStorage = core.dirPathForStorage data, context.uid
  core.log.debug "dirPath: #{dirPathForStorage}"
  fs.readdir dirPathForStorage, loadHandler
