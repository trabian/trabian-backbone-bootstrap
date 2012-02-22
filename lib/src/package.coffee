stitch = require 'stitch'
jade = require 'jade'
fs = require 'fs'
util = require 'util'
path = require 'path'
_ = require 'underscore'

module.exports =

  load: (options) ->

    package = stitch.createPackage

      paths: options.source

      compilers:

        jade: (module, filename) ->
          source = fs.readFileSync(filename, 'utf8')
          source = "module.exports = " + jade.compile(source, compileDebug: false, client: true) + ";"
          module._compile(source, filename)

      dependencies: options.dependencies

    stitch = ->

      fs.mkdir 'public/javascripts', ->

        package.compile (err, source) ->

          fs.writeFile options.output.app, source, (err) ->

            throw err if err
            console.log "Compiled #{options.output.app}"

    vendor = ->

      fs.mkdir options.output.vendor, ->

        for source in options.vendorDependencies

          name = path.basename source

          destination = [options.output.vendor, name].join '/'

          inputStream = fs.createReadStream source
          outputStream = fs.createWriteStream destination

          util.pump inputStream, outputStream, (err) ->
            throw err if err
            console.log "copied #{source} to #{destination}"

    all = ->
      stitch()
      vendor()

    { stitch, vendor, all }
