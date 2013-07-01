core  = require './core.coffee'

module.exports.execute = (checklist, context, cb) ->
  fs.unlink core.filePathForStorage(checklist, context.uid), cb
