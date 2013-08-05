_      = require 'underscore'
path   = require 'path'
crypto = require 'crypto'
fs     = require 'fs'
log    = require 'simplog'

storageRoot = path.join process.env.STORAGE_ROOT, 'cmdobjs'

if not fs.existsSync storageRoot
  fs.mkdirSync storageRoot

dirPathForStorage = (obj, uid) ->
  if _.isObject obj
    objType = obj.type || obj.__type || obj.__storageType || "default"
  else
    objType = "default"
  log.debug "objType: #{JSON.stringify objType}"
  rootPath = if uid then path.join(storageRoot, uid) else storageRoot
  if not fs.existsSync rootPath
    fs.mkdirSync rootPath
  rootPath = path.join rootPath, objType
  if not fs.existsSync rootPath
    fs.mkdirSync rootPath
  log.debug "dirPathForStorage: #{rootPath}"
  rootPath

# given an object or a key calculate the path for the storage
# of that object.  If an object is provided, the value of the
# key property will be used, otherwise the value will be assumed to
# be a string key value
module.exports.filePathForStorage = (obj, uid) ->
  log.debug "filePathForStorage(#{JSON.stringify obj}, #{uid})"
  if not obj
    return null
  objName = obj
  if _.isObject obj
    objName = obj.key || obj.__key || obj.__storageKey
  throw "invalid key value #{JSON.stringify objName} type #{typeof objName}" if objName.match(/[^\w_-]/) != null 
  path.join(dirPathForStorage(obj, uid), objName + ".json")



module.exports.dirPathForStorage = dirPathForStorage
module.exports.log = log
module.exports.storageRoot = storageRoot
