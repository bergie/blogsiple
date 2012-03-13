nodext = require 'nodext'
express = require 'express'
fs = require 'fs'

class BlogsipleExtension extends nodext.Extension
  name: 'BlogsipleExtension'
  config: {}

  makeDir: (dir, cb) ->
    fs.stat dir, (err, stat) =>
      return cb() unless err
      fs.mkdir dir, 0777, cb

  makeDirs: ->
    @makeDir "#{__dirname}/static", =>
      @makeDir "#{__dirname}/static/css", ->
      @makeDir "#{__dirname}/static/js", ->

  configure: (server) ->
    # Prepare dirs
    @makeDirs()

    server.use @config.urlPrefix, express.compiler
      src: "#{__dirname}/staticSrc"
      dest: "#{__dirname}/static"
      enable: ['coffeescript', 'sass']
    server.use @config.urlPrefix, express.static "#{__dirname}/static"

exports.extension = BlogsipleExtension
