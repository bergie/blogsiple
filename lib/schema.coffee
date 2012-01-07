{Schema} = require 'jugglingdb'

exports.schema = schema = new Schema 'redis', {}

exports.Role = Role = schema.define 'Role',
  name:
    type: String
    index: true

exports.User = User = schema.define 'User',
  email:
    type: String
    index: true

exports.Tag = Tag = schema.define 'Tag',
  url:
    type: String
    length: 255
  label:
    type: String
    length: 255

exports.Blob = Blob = schema.define 'Blob'
  location:
    type: String
    length: 255
  title:
    type: String
    length: 255

exports.Blog = Blog = schema.define 'Blog',
  title:
    type: String
    length: 255

exports.Post = Post = schema.define 'Post',
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

User.hasMany Role,
  as: 'roles'
  foreignKey: 'user'

Blog.hasMany Post,
  as: 'posts'
  foreignKey: 'blog'

Post.belongsTo Blog,
  as: 'blog'
  foreignKey: 'blog'

Post.hasMany Tag,
  as: 'tags'
  foreignKey: 'post'

Blob.hasMany Tag,
  as: 'tags'
  foreignKey: 'blob'
