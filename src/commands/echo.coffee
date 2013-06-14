_   = require 'underscore'
log = require 'simplog'

exports.execute = (data, context, callback) ->
  log.debug " echo args: %j", data
  # all our callbacks should follow the node convention of 
  # error, data
  callback null, data

