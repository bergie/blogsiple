{expect} = require 'chai'
{Schema} = require 'jugglingdb'

# Helper for getting a clean in-memory JugglingDB instance
getModels = -> require('../models').getModels new Schema 'memory'

describe 'Blog', ->
  models = getModels()
  blog1 = null

  it 'should be possible to create', ->
    models.Blog.create {}, (err, blog) ->
      blog1 = blog
      models.Blog.all {}, (err, blogs) ->
        expect(blogs.length).to.equal 1
  it 'should not have title when initialized', ->
    expect(blog1.title).to.equal null
  it 'should allow title to be set', ->
    blog1.updateAttribute 'title', 'Blog Simple', (err) ->
      expect(blog1.title).to.equal 'Blog Simple'
  it 'should ensure uniqueness of the title', ->
    blog2 = new models.Blog
    blog2.title = 'Blog Simple'
    blog2.isValid (valid) ->
      expect(valid).to.equal false
    blog2.save (err, user) ->
      expect(err.toString()).to.equal 'Error: Validation error'
      models.Blog.all {}, (err, blogs) ->
        expect(blogs.length).to.equal 1
