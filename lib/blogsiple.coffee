http = require 'express'
resource = require 'express-resource'
resourcer = require './resource-juggling'
{Schema} = require 'jugglingdb'

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
  blog_resource = server.resource resourcer.getResource
    schema: schema.schema
    model: schema.Post
    name: 'Post'
    urlName: 'post'
    collection: blog.posts
    toJSON: server.rdfmapper.toJSONLD
    addPlaceholderForEmpty: true
  
  blog_resource.map 'get', 'workflow', (req, res) ->
    results = []    
    if req.post.published.toString() == 'true'
      results.push {name: 'unpublish', label: 'Unpublish', action: {type: 'http', http: {type: 'PUT'}, url: "/#{req.post.id}/unpublish"}, type: 'button'}
    else
      results.push {name: 'publish', label: 'Publish', action: {type: 'http', http: {type: 'PUT'}, url: "/#{req.post.id}/publish"}, type: 'button'}    
    results.push {name: 'destroy', label: 'Destroy', action: {type: 'backbone_destroy'}, type: 'button'}
    
    res.json results
  
  blog_resource.map 'put', 'publish', (req, res) ->
    req.post.updateAttributes {published: true, published_at: (new Date())}, (err, item) ->
      res.send server.rdfmapper.toJSONLD req.post, req
      
  blog_resource.map 'put', 'unpublish', (req, res) ->
    req.post.updateAttributes {published: false, published_at: null}, (err, item) ->
      res.send server.rdfmapper.toJSONLD req.post, req

server.resource 'users', resourcer.getResource
  schema: schema.schema
  model: schema.User
  name: 'User'
  urlName: 'user'

schema.Blog.all (err, blogs) ->
  return registerBlog blogs[0] if blogs.length
  schema.Blog.create
    title: 'Blogsiple'
  , (err, blog) ->
    registerBlog blog
