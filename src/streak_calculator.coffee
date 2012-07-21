# Walk backwards in time by the interval of the goal,
# Checking to see if a progress record exists within the interval.
# Once we don't find a progress record in an interval, stop counting.

class StreakCalculator
  constructor: (@date_times, @frequency, @days_whitelist) ->

  calculate: ->
    return 0 unless @date_times?
    @streak = 0

    switch @frequency
      when 'daily' then @calculate_daily()
      when 'weekly' then @calculate_weekly()
      when 'monthly' then @calculate_monthly()
    @streak

  now: ->
    # use new Date because sinon stubs it out for testing
    moment(new Date)

  moment_is_in_day_whitelist: (m)->
    _.include @moment_days_whitelist(), m.day()

  moment_days_whitelist: ->
    # return an array of integers
    days = 
      sunday: 0
      monday : 1
      tuesday : 2
      wednesday : 3
      thursday : 4
      friday : 5
      saturday : 6
    _.values _.pick days, @days_whitelist


  calculate_daily: ->
    start_date = @now().subtract('days', 1)

    loop
      if @moment_is_in_day_whitelist start_date
        range = moment().range(start_date.sod(), start_date.eod())
        progress_made = @date_times.some (date)=> range.contains(date)
        if progress_made then @streak +=1 else break
      start_date = start_date.subtract('days', 1)

    # now add 1 if there is progress today
    if @moment_is_in_day_whitelist @now()
      progress_made_today = @date_times.some (date)=>
        moment().range(@now().sod(), @now().eod()).contains(date)
      @streak += 1 if progress_made_today

  calculate_monthly: ->
    # from 1st of previous month until last day of previous month
    first_day_of_last_month = @now().subtract('months', 1).subtract('days', (@now().date() - 1))
    last_day_of_last_month = first_day_of_last_month.clone().add('months', 1).subtract('days', 1)
    range = moment().range(first_day_of_last_month.sod(), last_day_of_last_month.eod())

    loop
      progress_made = @date_times.some (date)-> range.contains(date)
      if progress_made then @streak +=1 else break
      previous_start = range.start.clone().subtract('months', 1).sod()
      previous_end = range.start.clone().subtract('days', 1).eod()
      range = moment().range(previous_start, previous_end)

    # now add 1 if there is progress this month
    first_day_of_month = @now().subtract('days', (@now().date() - 1))
    last_day_of_month = first_day_of_month.clone().add('months', 1).subtract('days', 1)
    current_range = moment().range(first_day_of_month.sod(), last_day_of_month.eod())
    @streak += 1 if @date_times.some (date)-> current_range.contains(date)

  calculate_weekly: ->
    # from last week's sunday to last week's saturday
    days_since_sunday = @now().day()
    sunday_last_week = @now().subtract('weeks', 1).subtract('days', days_since_sunday)
    saturday_last_week = sunday_last_week.clone().add('days', 6)
    last_week_range = moment().range(sunday_last_week.sod(), saturday_last_week.eod())
    range = last_week_range

    loop
      progress_made = @date_times.some (date)-> range.contains(date)
      if progress_made then @streak +=1 else break
      previous_start = range.start.clone().subtract('weeks', 1).sod()
      previous_end = range.end.clone().subtract('weeks', 1).eod()
      range = moment().range(previous_start, previous_end)

    # now add in the current week
    sunday = @now().subtract('days', days_since_sunday)
    saturday = sunday.clone().add('days', 6)
    current_range = moment().range(sunday.sod(), saturday.eod())
    @streak += 1 if @date_times.some (date)-> current_range.contains(date)

if exports?
  exports.StreakCalculator = StreakCalculator
