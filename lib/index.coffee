module.exports =

  load: (root, pkg) ->

    buildTasks = require('stitch-up').load(root, pkg).tasks

    tasks:
      build: -> buildTasks.all()
      buildTest: -> buildTasks.test()

  server: require './server'
