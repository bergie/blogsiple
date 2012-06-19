nodext = require 'nodext'
express = require 'express'
fs = require 'fs'
util = require 'util'

class Blob extends nodext.Extension
  name: 'Blob'
  config: {}
  models: {}

  configure: (server) ->
    # Prepare directory for uploaded images
    fs.stat "#{@config.blobDir}", (err, stat) =>
      return unless err
      fs.mkdir "#{@config.blobDir}"

    server.use "#{@config.urlPrefix}static/", express.static @config.blobDir

  getModels: (schema, otherModels) ->
    @models = {}
    @models.Blob = schema.define 'Blob',
      title:
        type: String
        length: 255
      location:
        type: String
        length: 255
    @models

  registerRoutes: (server) ->
    config = @config
    models = @models

    server.get "#{config.urlPrefix}search", (req, res, next) ->
      return res.send 404 unless req.query.q

      search = new RegExp req.query.q, 'i'

      offset = parseInt req.query.offset ? 0
      limit = parseInt req.query.limit ? 10

      models.Blob.all {}, (err, blobs) ->
        matched = []
        for blob in blobs
          continue if blob.title.search(search) is -1

          localName = blob.location.split('/').pop()
          matched.push
            label: blob.title
            url: "#{config.urlPrefix}static/#{localName}"

        res.send
          assets: matched.slice offset, offset + limit
          offset: offset
          limit: limit
          total: matched.length

    server.post "#{config.urlPrefix}upload", (req, res, next) ->
      for field, file of req.files
        localName = "#{file.path.split('/').pop()}_#{file.name}"
        localPath = "#{config.blobDir}/#{localName}"
    
        input = fs.createReadStream file.path
        output = fs.createWriteStream localPath
        util.pump input, output, (err) ->
          models.Blob.create
            location: localPath
            title: file.filename
          , (err, blob) ->
            res.redirect "#{config.urlPrefix}static/#{localName}"

exports.extension = Blob
