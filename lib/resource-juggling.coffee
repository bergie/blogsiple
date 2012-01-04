exports.contentNegotiator = (req, res, next) ->
  for type in req.acceptableTypes
    if this.html and type is 'text/html'
      return this.html req, res, next
    if this.json and type is 'application/json'
      return this.json req, res, next
  next() 

exports.getResource = (options) ->
  throw 'No schema defined' unless options.schema
  throw 'No schema name defined' unless options.name
  options.urlName ?= options.name
  options.where ?= 'id'

  if options.collection
    collectionIsRelation = true
  else
    collectionIsRelation = false
    options.collection ?= options.schema[options.name]

  options.toJSON ?= (items, req) -> items

  seek = (constraints, callback) ->
    if collectionIsRelation
      options.collection
        where: constraints
      , (err, items) ->
        items = [] unless items
        callback err, items
      return

    constraints =
      where: constraints
    options.schema[options.name].all constraints, (err, items) ->
      items = [] unless items
      callback err, items

  resource =
    id: options.urlName

    load: (where, callback) ->
      whereQuery = {}
      whereQuery[options.where] = where
      seek whereQuery, (err, items) ->
        return callback err if err
        callback null, items[0]

    index:
      html: (req, res) ->
        seek {}, (err, items) ->
          unless items.length
            blankItem = {}
            for property, defs of options.schema.schema.definitions[options.name].properties
              blankItem[property] = ''

          res.render "#{options.urlName}/index",
            locals:
              items: items
              as: 'item'
      json: (req, res) ->
        seek {}, (err, items) ->
          res.send options.toJSON items, req
      default: exports.contentNegotiator

    create: (req, res) ->
      options.collection.create req.body, (err, item) ->
        res.send options.toJSON item, req

    update: (req, res) ->
      req[options.urlName].updateAttributes req.body, (err, item) ->
        res.send options.toJSON req[options.urlName], req

    destroy: (req, res) ->
      req[options.urlName].destroy (err, item) ->
        res.send options.toJSON item, req

    show:
      html: (req, res) ->
        res.render "#{options.urlName}/show",
          locals:
            item: req[options.urlName]
            as: options.urlName
      json: (req, res) ->
        res.send options.toJSON req[options.urlName], req
      default: exports.contentNegotiator
