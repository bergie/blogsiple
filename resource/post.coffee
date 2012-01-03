exports.getResource = (blog, server) ->
  resource =
    id: 'post'
    load: (id, callback) ->
      blog.posts where: id: id, (err, posts) ->
        return callback err if err
        callback null, posts[0]
    index:
      html: (req, res) ->
        blog.posts (err, posts) ->
          unless posts.length
            posts.push
              id: ''
              title: ''
              content: ''
          res.render 'post/index',
          locals:
            posts: posts
            as: 'post'
            title: blog.title
      json: (req, res) ->
        blog.posts (err, posts) ->
          res.send posts
      default: server.contentNegotiator
    create: (req, res) ->
      blog.posts.create req.body, (err, post) ->
        res.send server.rdfmapper.toJSONLD post, req
    update: (req, res) ->
      req.post.updateAttributes req.body, (err, post) ->
        res.send server.rdfmapper.toJSONLD req.post, req
    destroy: (req, res) ->
      req.post.destroy(err, post) ->
        res.send server.rdfmapper.toJSONLD req.post, req
    show:
      html: (req, res) ->
        res.render 'post/show',
          locals:
            post: req.post
            as: 'post'
            title: "#{req.post.title} (#{blog.title})"
      json: (req, res) ->
        res.send req.post
      default: server.contentNegotiator
