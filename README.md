Blogsiple - simple blog system example
==========================

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

## TODO

* Authentication with [PassportJS](http://passportjs.org/)
* Access controls into JugglingDB
* Atom format

## License and contributing

For now Blogsiple is intended to serve only as an example and CreateJS development testbed. But even so, contributions are welcome.

Blogsiple code is available under the MIT license.
