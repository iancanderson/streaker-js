{exec} = require 'child_process'
fs     = require 'fs'

task 'build', 'Build single application file from source files', ->
  build()

task "test", "Run tests", ->
  build ->
    {reporters} = require 'nodeunit'
    reporters.default.run ['test']

run = (command, callback) ->
  exec command, (err, stdout, stderr) ->
    console.warn stderr if stderr
    callback?() unless err

appFiles  = [
  # omit src/ and .coffee to make the below lines a little shorter
  'date_range'
  'streak_calculator'
  'streaker'
]

build = (callback) ->
  appContents = new Array remaining = appFiles.length
  for file, index in appFiles then do (file, index) ->
    fs.readFile "src/#{file}.coffee", 'utf8', (err, fileContents) ->
      throw err if err
      appContents[index] = fileContents
      process() if --remaining is 0
  process = ->
    fs.writeFile 'streaker.coffee', appContents.join('\n\n'), 'utf8', (err) ->
      throw err if err
      exec 'coffee --compile streaker.coffee', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
        fs.unlink 'streaker.coffee', (err) ->
          throw err if err
          console.log 'Done.'
  callback?()




