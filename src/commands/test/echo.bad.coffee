_   = require 'underscore'
log = require 'simplog'

exports.execute = (data, callback) ->
  log.debug " echo args: " + _.toArray data
  callback data

