http = require 'express'
resource = require 'express-resource'

exports.schema = schema = require './schema'
schema.schema.automigrate()

exports.server = server = http.createServer()

server.rdfmapper = require './rdfmapper'

server.configure ->
  server.use require('connect-conneg').acceptedTypes

  server.use '/', http.compiler
    src: "#{__dirname}/../staticSrc"
    dest: "#{__dirname}/../static"
    enable: ['coffeescript', 'sass']

  server.use '/', http.static "#{__dirname}/../static"

  server.use http.bodyParser()

  server.use (req, res, next) ->
    return next() unless req.body
    return next() unless req.body['@subject']
    req.body = server.rdfmapper.fromJSONLD req.body
    next() 

  server.set 'view engine', 'jade'
  server.set 'view options',
    layout: 'layout'

server.contentNegotiator = (req, res, next) ->
  for type in req.acceptableTypes
    if this.html and type is 'text/html'
      return this.html req, res, next
    if this.json and type is 'application/json'
      return this.json req, res, next
  next()

registerBlog = (blog) ->
  postResource = require './resource/post'
  server.resource postResource.getResource blog, server

schema.Blog.all (err, blogs) ->
  return registerBlog blogs[0] if blogs.length
  schema.Blog.create
    title: 'Blogsiple'
  , (err, blog) ->
    registerBlog blog
