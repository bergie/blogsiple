{Schema} = require 'jugglingdb'

exports.schema = schema = new Schema 'redis', {}

exports.Role = Role = schema.define 'Role',
  name:
    type: Schema.String
    index: true

exports.User = User = schema.define 'User',
  email:
    type: Schema.String
    index: true

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

User.hasMany Role,
  as: 'roles'
  foreignKey: 'user'

Blog.hasMany Post,
  as: 'posts'
  foreignKey: 'blog'

Post.belongsTo Blog,
  as: 'blog'
  foreignKey: 'blog'
