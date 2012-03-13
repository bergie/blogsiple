nodext = require 'nodext'
express = require 'express'
fs = require 'fs'
util = require 'util'

class Blob extends nodext.Extension
  name: 'Blob'
  config: {}

  configure: (server) ->
    # Prepare directory for uploaded images
    fs.stat "#{@config.blobDir}", (err, stat) =>
      return unless err
      fs.mkdir "#{@config.blobDir}"

    server.use "#{@config.urlPrefix}static/", express.static @config.blobDir

  registerRoutes: (server) ->
    config = @config
    server.post "#{config.urlPrefix}upload", (req, res, next) ->
      for field, file of req.files
        localName = "#{file.path.split('/').pop()}_#{file.name}"
        localPath = "#{config.blobDir}/#{localName}"
    
        input = fs.createReadStream file.path
        output = fs.createWriteStream localPath
        util.pump input, output, (err) ->
          schema.Blob.create
            location: localPath
            title: file.filename
          , (err, blog) ->
            res.redirect "#{config.urlPrefix}static/#{localName}"

exports.extension = Blob
