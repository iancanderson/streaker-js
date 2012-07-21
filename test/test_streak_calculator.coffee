#{streaker} = require '../lib/streaker'

exports.streak_calculator =
  "should return 0 without parameters": (test) ->
    test.equal(streaker().current(), 0)
    test.done()

