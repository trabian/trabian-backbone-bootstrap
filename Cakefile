{exec} = require 'child_process'

run = (command, callback) ->
  exec command, (err, stdout, stderr) ->
    console.warn stderr if stderr
    callback?() unless err

task 'build', ->
  run 'coffee -co lib/js lib/src'
