path = require 'path'

walken = require('bindings')('walken.node')

module.exports =
  walkSync: (rootPath, callback) ->
    rootPath = path.resolve(rootPath)
    walken.walk(rootPath, callback)
