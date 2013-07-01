_     = require 'underscore'
path  = require 'path'
fs    = require 'fs'
log   = require 'simplog'

storageRoot = process.env.OBJECT_STORAGE_ROOT
storageRoot = storageRoot || process.env.STORAGE_ROOT
storageRoot = storageRoot || path.join(process.env.HOME, "storage")
storageRoot = path.join storageRoot, 'cmdobjs'
log.info "OBJECT_STORAGE_ROOT: %s", proces.env.OBJECT_STORAGE_ROOT
log.info "STORAGE_ROOT: %s", process.env.STORAGE_ROOT
log.info "HOME: %s", process.env.HOME
log.info "object storage using root: %s", storageRoot

if not fs.existsSync storageRoot
  fs.mkdirSync storageRoot

# given an object or a key calculate the path for the storage
# of that object.  If an object is provided, the value of the
# key property will be used, otherwise the value will be assumed to
# be a string key value
module.exports.filePathForStorage = (obj, uid) ->
  if _.isObject obj
    obj = obj.key
  rootPath = if uid then path.join(storageRoot, uid) else storageRoot
  if not fs.existsSync rootPath
    fs.mkdirSync rootPath
  path.join(rootPath, obj + ".json")

module.exports.log = log
module.exports.storageRoot = storageRoot