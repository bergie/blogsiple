Schema = require('jugglingdb').Schema

exports.schema = schema = new Schema 'redis', {}

exports.Blog = Blog = schema.define 'Blog',
  title:
    type: Schema.string
    length: 255

exports.Post = Post = schema.define 'Post',
  title:
    type: Schema.String
    length: 255
    index: true
  content:
    type: Schema.Text

Blog.hasMany Post,
  as: 'posts'

Post.belongsTo Blog,
  as: 'blog'
  foreignKey: 'blog'
