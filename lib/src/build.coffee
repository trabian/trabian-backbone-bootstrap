stitch = require 'stitch'
jade = require 'jade'
fs = require 'fs'
util = require 'util'
path = require 'path'
_ = require 'underscore'

module.exports =

  load: (root, options) ->

    { output, paths, dependencies, vendorDependencies } = @loadOptions root, options

    package = stitch.createPackage

      paths: paths

      compilers:

        jade: (module, filename) ->
          source = fs.readFileSync(filename, 'utf8')
          source = "module.exports = " + jade.compile(source, compileDebug: false, client: true) + ";"
          module._compile(source, filename)

      dependencies: dependencies

    stitch = ->

      fs.mkdir 'public/javascripts', ->

        package.compile (err, source) ->

          fs.writeFile output.app, source, (err) ->

            throw err if err
            console.log "Compiled #{output.app}"

    vendor = ->

      fs.mkdir output.vendor, ->

        for source in vendorDependencies

          do (source) ->

            name = path.basename source

            destination = [output.vendor, name].join '/'

            inputStream = fs.createReadStream source
            outputStream = fs.createWriteStream destination

            util.pump inputStream, outputStream, (err) ->
              throw err if err
              console.log "copied #{source} to #{destination}"

    all = ->
      stitch()
      vendor()

    { stitch, vendor, all }

  loadOptions: (root, options) ->

    defaults =
      paths: []
      dependencies: []
      vendorDependencies: []

    jointOptions = _.extend defaults, options.trabianPackage

    moduleNames = _.union _.flatten [_.keys(options.dependencies), _.keys(options.devDependencies)]

    for name in moduleNames

      modulePath = "#{root}/node_modules/#{name}"

      package = require "#{modulePath}/package"

      if trabianPackage = package.trabianPackage

        for field in ['paths', 'dependencies', 'vendorDependencies']
          if array = trabianPackage[field]
            for item in array
              jointOptions[field].push [modulePath, item].join '/'

    jointOptions