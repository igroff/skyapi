_     = require 'underscore'
path  = require 'path'
fs    = require 'fs'
log   = require 'simplog'

storageRoot = process.env.CHECKLIST_STORAGE_ROOT ||
  path.join process.env.STORAGE_ROOT, "checklists"

if not fs.existsSync storageRoot
  fs.mkdirSync storageRoot

module.exports.filePathForChecklist = (checklist) ->
  if _.isObject checklist
    checklist = checklist.name
  path.join(storageRoot, checklist + ".json")

module.exports.log = log
module.exports.storageRoot = storageRoot
