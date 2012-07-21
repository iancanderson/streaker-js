# Stolen from https://github.com/gf3/moment-range
# Only change is that contains() is now an inclusive check instead of exclusive

###*
  * DateRange class to store ranges and query dates.
  * @typedef {!Object}
*###
class DateRange
  ###*
    * DateRange instance.
    * @param {(Moment|Date)} start Start of interval.
    * @param {(Moment|Date)} end   End of interval.
    * @constructor
  *###
  constructor: (@start, @end) ->

  ###*
    * Determine if the current interval contains a given moment/date.
    * @param {(Moment|Date)} moment Date to check.
    * @return {!boolean}
  *###
  contains: (moment) ->
    @start <= moment <= @end

  ###*
    * Date range in milliseconds. Allows basic coercion math of date ranges.
    * @return {!number}
  *###
  valueOf: ->
    @end - @start

###*
  * Build a date range.
  * @param {(Moment|Date)} start Start of range.
  * @param {(Moment|Date)} end   End of range.
  * @this {Moment}
  * @return {!DateRange}
*###
moment.fn.range = (start, end) ->
  new DateRange start, end

###*
  * Check if the current moment is within a given date range.
  * @param {!DateRange} range Date range to check.
  * @this {Moment}
  * @return {!boolean}
*###
moment.fn.within = (range) ->
  range.contains @_d

# LOL CommonJS
if module?.exports?
  module.exports = moment
