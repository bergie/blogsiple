resource = require 'express-resource'
resourceJuggling = require 'resource-juggling'
{rdfmapper} = require 'nodext-create'

exports.registerRoutes = (server, prefix, models, schema) ->
  registerBlog = (blog) ->  
    blog_resource = server.resource resourceJuggling.getResource
      schema: schema
      model: models.Post
      name: 'Post'
      urlName: 'post'
      collection: -> blog.posts
      seek: (request, constraints, callback) ->
        constraints.blogId = blog.id
        models.Post.all
          where: constraints
          order: 'created_at ASC'
        , callback
      toJSON: rdfmapper.toJSONLD
      addPlaceholderForEmpty: true
  
    blog_resource.map 'get', 'workflow', (req, res) ->
      results = []
      if req.post.published is 'true'
        results.push
          name: 'unpublish'
          label: 'Unpublish'
          action:
            type: 'http'
            http:
              type: 'PUT'
            url: "/#{req.post.id}/unpublish"
          type: 'button'
      else
        results.push
          name: 'publish'
          label: 'Publish'
          action:
            type: 'http'
            http:
              type: 'PUT'
            url: "/#{req.post.id}/publish"
          type: 'button'
      results.push
        name: 'destroy'
        label: 'Delete'
        action:
          type: 'backbone_destroy'
        type: 'button'
    
      res.json results
  
    blog_resource.map 'put', 'publish', (req, res) ->
      req.post.updateAttributes
        published: true
        published_at: (new Date())
      , (err, item) ->
        res.send rdfmapper.toJSONLD req.post, req
      
    blog_resource.map 'put', 'unpublish', (req, res) ->
      req.post.updateAttributes
        published: false
        published_at: null
      , (err, item) ->
        res.send rdfmapper.toJSONLD req.post, req

  models.Blog.all (err, blogs) ->
    return registerBlog blogs[0] if blogs.length
    models.Blog.create
      title: 'Blogsiple'
    , (err, blog) ->
      registerBlog blog
