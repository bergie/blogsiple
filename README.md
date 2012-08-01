Blogsiple - simple blog system example
==========================

[![Build Status](https://secure.travis-ci.org/bergie/blogsiple.png?branch=master)](http://travis-ci.org/bergie/blogsiple)

Blogsiple is the official Node.js testbed for [Create](http://createjs.org/) CMS UI integration. It has been built using the [NodeXT](https://github.com/bergie/nodext) framework.

## Installation with NPM

    $ npm install -g blogsiple

## Installing with git

Check out this repository from GitHub:

    $ git://github.com/bergie/blogsiple.git

Then install dependencies:

    $ cd blogsiple
    $ npm install

You also need a JugglingDB database provider. By default we use Redis, which is installed via dependencies.

## Running

With globally-installed Blogsiple with a default configuration:

    $ blogsiple

With locally-installed Blogsiple:

    $ ./bin/blogsiple configuration/redis_8001.json

If you want to use a different database or a server setup, just create your own NodeXT configuration file for Blogsiple.

## Importing blog entries

You can populate the Blogsiple database with blog posts from any RSS feed. Do this with:

    $ ./bin/blogsiple_import_rss configuration/redis_8001.json http://bergie.iki.fi/blog/rss.xml

## Deploying on Heroku

You'll need a working Heroku account and the [Heroku toolbelt](https://toolbelt.heroku.com/) installed, and a local Git checkout of Blogsiple.

Create an app:

    $ heroku apps:create -s cedar my-blog-name

Add the Postgres database (the free option in this example):

    $ heroku addons:add shared-database

Deploy on Heroku:

    $ git push heroku master

Create the database tables:

    $ heroku run ./node_modules/.bin/nodext_storage_create configuration/heroku.json

Import existing blog entries (optional), replacing the URL below with your own feed:

    $ heroku run ./bin/blogsiple_import_rss configuration/heroku.json http://bergie.iki.fi/blog/rss.xml

Go to your app at <http://my-blog-name.herokuapp.com> (see for example <http://blogsiple.herokuapp.com>)

## TODO

* Authentication with [PassportJS](http://passportjs.org/)
* Access controls into JugglingDB
* Atom format

## License and contributing

For now Blogsiple is intended to serve only as an example and CreateJS development testbed. But even so, contributions are welcome.

Blogsiple code is available under the MIT license.
