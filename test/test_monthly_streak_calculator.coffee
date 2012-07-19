{streaker} = require '../lib/streaker'
testCase = require('nodeunit').testCase
moment = require('moment')
sinon = require('sinon')

exports.monthly_streak_calculations = testCase

  setUp: (cb)->
    now = new Date(2012, 6, 1)
    @now_moment = moment(now)
    @frequency = 'monthly'
    # this freezes the clock
    @clock = sinon.useFakeTimers(now.getTime())
    cb()

  tearDown: (cb)->
    @clock.restore()
    cb()
  
  "should count last month and the month before as 2": (test) ->
    @dates = (@now_moment.clone().subtract('months', num) for num in [2..1])
    test.equal(streaker(@dates, @frequency).current(), 2)
    test.done()

  "should count this month and last month as 2": (test) ->
    @dates = (@now_moment.clone().subtract('months', num) for num in [1..0])
    test.equal(streaker(@dates, @frequency).current(), 2)
    test.done()

  "should count two months ago as 0": (test) ->
    @dates = [@now_moment.clone().subtract('months', 2)]
    test.equal(streaker(@dates).current(), 0)
    test.done()


