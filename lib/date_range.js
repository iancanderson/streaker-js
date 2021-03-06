
/**
  * DateRange class to store ranges and query dates.
  * @typedef {!Object}
*
*/

(function() {
  var DateRange;

  DateRange = (function() {
    /**
      * DateRange instance.
      * @param {(Moment|Date)} start Start of interval.
      * @param {(Moment|Date)} end   End of interval.
      * @constructor
    *
    */
    function DateRange(start, end) {
      this.start = start;
      this.end = end;
    }

    /**
      * Determine if the current interval contains a given moment/date.
      * @param {(Moment|Date)} moment Date to check.
      * @return {!boolean}
    *
    */

    DateRange.prototype.contains = function(moment) {
      return (this.start <= moment && moment <= this.end);
    };

    /**
      * Date range in milliseconds. Allows basic coercion math of date ranges.
      * @return {!number}
    *
    */

    DateRange.prototype.valueOf = function() {
      return this.end - this.start;
    };

    return DateRange;

  })();

  /**
    * Build a date range.
    * @param {(Moment|Date)} start Start of range.
    * @param {(Moment|Date)} end   End of range.
    * @this {Moment}
    * @return {!DateRange}
  *
  */

  moment.fn.range = function(start, end) {
    return new DateRange(start, end);
  };

  /**
    * Check if the current moment is within a given date range.
    * @param {!DateRange} range Date range to check.
    * @this {Moment}
    * @return {!boolean}
  *
  */

  moment.fn.within = function(range) {
    return range.contains(this._d);
  };

  if ((typeof module !== "undefined" && module !== null ? module.exports : void 0) != null) {
    module.exports = moment;
  }

}).call(this);
