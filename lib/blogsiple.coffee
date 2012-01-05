http = require 'express'
resource = require 'express-resource'
resourcer = require './resource-juggling'

exports.schema = schema = require './schema'
schema.schema.automigrate()

exports.server = server = http.createServer()

server.rdfmapper = require './rdfmapper'

browserid = require './authentication'
authentication = browserid.setUp server, schema

server.configure ->
  server.use require('connect-conneg').acceptedTypes

  server.use '/', http.compiler
    src: "#{__dirname}/static"
    dest: "#{__dirname}/../static"
    enable: ['coffeescript', 'sass']

  server.use '/', http.static "#{__dirname}/../static"

  # Static servers for create
  server.use '/js/create/', http.static "#{__dirname}/../deps/create/src"
  server.use '/js/create/deps/', http.static "#{__dirname}/../deps/create/deps"
  server.use '/css/create/', http.static "#{__dirname}/../deps/create/themes"

  server.use http.bodyParser()
  server.use http.cookieParser()

  server.use http.session
    secret: 'I like to Create'

  server.use authentication.initialize()
  server.use authentication.session()

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
  server.resource resourcer.getResource
    schema: schema
    name: 'Post'
    urlName: 'post'
    collection: blog.posts
    toJSON: server.rdfmapper.toJSONLD

server.resource 'users', resourcer.getResource
  schema: schema
  name: 'User'
  urlName: 'user'

schema.Blog.all (err, blogs) ->
  return registerBlog blogs[0] if blogs.length
  schema.Blog.create
    title: 'Blogsiple'
  , (err, blog) ->
    registerBlog blog
