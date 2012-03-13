{Schema} = require 'jugglingdb'

exports.getModels = (schema, otherModels) ->
  models = {}

  models.Blog = schema.define 'Blog',
    title:
      type: String
      length: 255

  models.Post = schema.define 'Post',
    title:
      type: String
      length: 255
      index: true
    content:
      type: Schema.Text
    published:
      type: Boolean
      default: false
    published_at:
      type: Date

  models.Blog.hasMany models.Post,
    as: 'posts'
    foreignKey: 'blogId'

  models.Post.belongsTo models.Blog,
    as: 'blog'
    foreignKey: 'blogId'

  models
