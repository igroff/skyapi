util    = require 'util'

write = (level, message, formatParams) ->
  if formatParams
    formatParams.unshift message
    util.log "[#{level}] #{util.format.apply util.format, formatParams}"
  else
    util.log "[#{level}] #{message}"

log =
  error: (message, others...) -> write "ERROR", message, others
  info:  (message, others...) -> write "INFO", message, others
  warn:  (message, others...) -> write "WARN", message, others
  debug: (message, others...) ->
    if process.env.DEBUG
      write "DEBUG", message, others
  event: (message, others...) ->
    if process.env.DEBUG
      write "EVENT", message, others

module.exports = log
