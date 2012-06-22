module.exports =

  boot: (config) ->

    express = require 'express'

    app = if config.https
      express.createServer config.https
    else
      express.createServer()

    app.configure ->

      app.use express.errorHandler
        dumpExceptions: true
        showStack: true

      app.use express.methodOverride()

      if staticMatch = config.view?.static?.match

        app.use (req, res, next) ->

          if match = req.url.match staticMatch
            req.url = match[1]

          next()

      app.use express.cookieParser "this cookie secret isn't too secure"

      app.use express.logger()

      app.use express.static config.view.static.dir

      app.set 'view engine', 'jade'

      app.set 'view options', config.view.options

      #app.use express.bodyParser()

    app.get '/favicon.ico', (req, res, next) ->
      res.send 404

    app.get '/images/favicon.ico', (req, res, next) ->
      res.send 404

    port = process.env.PORT or config.port

    app.listen port, -> console.log 'Listening on', port

    app
