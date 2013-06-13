log   = require '../log.coffee'

exports.execute = (p1, p2, p3, context, cb) ->
  str = "(p1=#{p1}, p2=#{p2}, p3=#{p3}, cb=#{cb})"
  log.debug str
  cb null, "(p1=#{p1}, p2=#{p2}, p3=#{p3})"

