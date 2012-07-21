#{streaker} = require '../lib/streaker'
testCase = require('nodeunit').testCase
moment = require('moment')
sinon = require('sinon')

exports.weekly_streak_calculations = testCase

  setUp: (cb)->
    now = new Date(2012, 6, 8)
    @now_moment = moment(now)
    @frequency = 'weekly'
    # this freezes the clock
    @clock = sinon.useFakeTimers(now.getTime())
    cb()

  tearDown: (cb)->
    @clock.restore()
    cb()
  
  "should count last week and the week before as 2": (test) ->
    @dates = (@now_moment.clone().subtract('weeks', num) for num in [2..1])
    test.equal(streaker(@dates, @frequency).current(), 2)
    test.done()

  "should count this week and last week as 2": (test) ->
    @dates = (@now_moment.clone().subtract('days', num) for num in [1..0])
    test.equal(streaker(@dates, @frequency).current(), 2)
    test.done()

  "should count two weeks ago as 0": (test) ->
    @dates = [@now_moment.clone().subtract('weeks', 2)]
    test.equal(streaker(@dates).current(), 0)
    test.done()

