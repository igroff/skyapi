_   = require 'underscore'
log = require '../../log.coffee'

exports.execute = (data, callback) ->
  log.debug " echo args: " + _.toArray data
  callback data

