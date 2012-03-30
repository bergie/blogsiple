Blogsiple - simple blog system example
==========================

Blogsiple is the official Node.js testbed for [Create](http://createjs.org/) CMS UI integration. It has been built using the [NodeXT](https://github.com/bergie/nodext) framework.

## Installation

    $ npm install

You also need a JugglingDB database provider. By default we use Redis:

    $ npm install redis

## Running

    $ ./node_modules/nodext/bin/nodext configuration/redis_8001.json

## Importing blog entries

You can populate the Blogsiple database with blog posts from any RSS feed. Do this with:

    $ ./bin/import_rss configuration/redis_8001.json http://bergie.iki.fi/blog/rss.xml

## TODO

* Authentication with [PassportJS](http://passportjs.org/)
* Access controls into JugglingDB
* Atom format

## License and contributing

For now Blogsiple is intended to serve only as an example and CreateJS development testbed. But even so, contributions are welcome.

Blogsiple code is available under the MIT license.
