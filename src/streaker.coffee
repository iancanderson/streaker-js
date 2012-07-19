{StreakCalculator} =
  if require?
    require './streak_calculator'
  else
    @StreakCalculator

ALL_DAYS = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday']

class Streaker

  constructor: (@times, @frequency, @days_whitelist)->

  current: ->
    new StreakCalculator(@times, @frequency, @days_whitelist).calculate()

exports.streaker = (times, frequency = 'daily', days_whitelist = ALL_DAYS)->
  new Streaker(times, frequency, days_whitelist)
