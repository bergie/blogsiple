nodext = require 'nodext'
{rdfmapper} = require 'nodext-create'
http = require 'express'

class Blog extends nodext.Extension
  name: 'Blog'
  config: {}

  configure: (server) ->
    # We need content negotiation
    server.use require('connect-conneg').acceptedTypes

    server.use http.bodyParser()

    # Convert received JSON-LD packets to JSON compatible
    # with our models
    server.use (req, res, next) ->
      return next() unless req.body
      return next() unless req.body['@subject']
      req.body = rdfmapper.fromJSONLD req.body
      next() 

  getModels: (@schema, otherModels) ->
    models = require './models'
    @models = models.getModels schema, otherModels

  registerRoutes: (server) ->
    routes = require './routes'
    routes.registerRoutes server, @config.urlPrefix, @models, @schema

exports.extension = Blog
