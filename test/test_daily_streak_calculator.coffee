{streaker} = require '../lib/streaker'
testCase = require('nodeunit').testCase
moment = require('moment')
sinon = require('sinon')

exports.daily_streak_calculations = testCase

  all_days: testCase

    setUp: (cb)->
      now = new Date(2012, 6, 8)
      @now_moment = moment(now)
      # this freezes the clock
      @clock = sinon.useFakeTimers(now.getTime())
      cb()

    tearDown: (cb)->
      @clock.restore()
      cb()
    
    "should count yesterday and the day before as 2": (test) ->
      @dates = (@now_moment.clone().subtract('days', num) for num in [2..1])
      test.equal(streaker(@dates).current(), 2)
      test.done()

    "should count today and yesterday as 2": (test) ->
      @dates = (@now_moment.clone().subtract('days', num) for num in [1..0])
      test.equal(streaker(@dates).current(), 2)
      test.done()

    "should count the day before yesterday as 0": (test) ->
      @dates = [@now_moment.clone().subtract('days', 2)]
      test.equal(streaker(@dates).current(), 0)
      test.done()

  weekdays: testCase

    setUp: (cb)->
      # 'Today' is a sunday
      now = new Date(2012, 6, 8)
      @now_moment = moment(now)
      @days_whitelist = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday']
      @frequency = 'daily'
      # this freezes the clock
      @clock = sinon.useFakeTimers(now.getTime())
      cb()

    tearDown: (cb)->
      @clock.restore()
      cb()
    
    "should count all consecutive previous weekdays": (test) ->
      @dates = (@now_moment.clone().subtract('days', num) for num in [6..2])
      # @dates is M-F, so we streak should be 5
      test.equal(streaker(@dates, @frequency, @days_whitelist).current(), 5)
      test.done()

    "should not count weekends": (test) ->
      @dates = (@now_moment.clone().subtract('days', num) for num in [6..0])
      # @dates is M-F, so we streak should be 5
      test.equal(streaker(@dates, @frequency, @days_whitelist).current(), 5)
      test.done()

