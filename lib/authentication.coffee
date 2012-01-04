authentication = require 'passport'
{Strategy} = require 'passport-browserid'

exports.setUp = (server, schema) ->

  findByEmail = (email, callback) ->
    schema.User.find
      where:
        email: email
    , (err, users) ->
      return done err, null if err
      callback err, users[0] 

  authentication.use new Strategy
    audience: 'http://localhost:8080'
  , findByEmail

  authentication.serializeUser (user, done) ->
    done null, user.email

  authentication.deserializeUser findByEmail

  authentication
