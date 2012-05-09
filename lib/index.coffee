module.exports =

  load: (root, pkg) ->

    buildTasks = require('stitch-up').load(root, pkg).tasks

    tasks:
      build: -> buildTasks.all()

  server: require './server'
