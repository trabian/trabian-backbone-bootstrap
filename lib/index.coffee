module.exports =

  load: (root, package) ->

    buildTasks = require('stitch-up').load(root, package).tasks

    tasks:
      build: -> buildTasks.all()
