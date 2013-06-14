log   = require "simplog"

module.exports.execute = (handshakeData, cb) ->
  log.debug "handshake data: %j", handshakeData
  handshakeData.uid = handshakeData.headers.uid || "TEST_UID"
  cb null, true
