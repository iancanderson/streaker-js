{exec} = require 'child_process'

run = (command, callback) ->
  exec command, (err, stdout, stderr) ->
    console.warn stderr if stderr
    callback?() unless err

build = (callback) ->
  run 'coffee -co lib src', callback

task "test", "Run tests", ->
  build ->
    {reporters} = require 'nodeunit'
    reporters.default.run ['test']

