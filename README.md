Simple blog system example
==========================

This example showcases the interplay between the [JugglingDB ORM](https://github.com/1602/jugglingdb), [express-resource REST serving](https://github.com/visionmedia/express-resource) and the [CreateJS content editing UI](http://createjs.org/). It also uses [connect-conneg](https://github.com/foxxtrot/connect-conneg) for content negotiation on formats to serve.

## Installation

    $ git submodule init --update
    $ npm install

## Running

    $ ./bin/blogsiple

## TODO

* Authentication with [PassportJS](http://passportjs.org/)
* Access controls into JugglingDB
* Atom format

## License and contributing

For now Blogsiple is intended to serve only as an example and CreateJS development testbed. But even so, contributions are welcome.

Blogsiple code is available under the MIT license.
