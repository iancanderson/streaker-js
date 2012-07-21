
/**
  * DateRange class to store ranges and query dates.
  * @typedef {!Object}
*
*/

(function() {
  var ALL_DAYS, DateRange, StreakCalculator, Streaker;

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

  StreakCalculator = (function() {

    function StreakCalculator(date_times, frequency, days_whitelist) {
      this.date_times = date_times;
      this.frequency = frequency;
      this.days_whitelist = days_whitelist;
    }

    StreakCalculator.prototype.calculate = function() {
      if (this.date_times == null) return 0;
      this.streak = 0;
      switch (this.frequency) {
        case 'daily':
          this.calculate_daily();
          break;
        case 'weekly':
          this.calculate_weekly();
          break;
        case 'monthly':
          this.calculate_monthly();
      }
      return this.streak;
    };

    StreakCalculator.prototype.now = function() {
      return moment(new Date);
    };

    StreakCalculator.prototype.moment_is_in_day_whitelist = function(m) {
      return _.include(this.moment_days_whitelist(), m.day());
    };

    StreakCalculator.prototype.moment_days_whitelist = function() {
      var days;
      days = {
        sunday: 0,
        monday: 1,
        tuesday: 2,
        wednesday: 3,
        thursday: 4,
        friday: 5,
        saturday: 6
      };
      return _.values(_.pick(days, this.days_whitelist));
    };

    StreakCalculator.prototype.calculate_daily = function() {
      var progress_made, progress_made_today, range, start_date,
        _this = this;
      start_date = this.now().subtract('days', 1);
      while (true) {
        if (this.moment_is_in_day_whitelist(start_date)) {
          range = moment().range(start_date.sod(), start_date.eod());
          progress_made = this.date_times.some(function(date) {
            return range.contains(date);
          });
          if (progress_made) {
            this.streak += 1;
          } else {
            break;
          }
        }
        start_date = start_date.subtract('days', 1);
      }
      if (this.moment_is_in_day_whitelist(this.now())) {
        progress_made_today = this.date_times.some(function(date) {
          return moment().range(_this.now().sod(), _this.now().eod()).contains(date);
        });
        if (progress_made_today) return this.streak += 1;
      }
    };

    StreakCalculator.prototype.calculate_monthly = function() {
      var current_range, first_day_of_last_month, first_day_of_month, last_day_of_last_month, last_day_of_month, previous_end, previous_start, progress_made, range;
      first_day_of_last_month = this.now().subtract('months', 1).subtract('days', this.now().date() - 1);
      last_day_of_last_month = first_day_of_last_month.clone().add('months', 1).subtract('days', 1);
      range = moment().range(first_day_of_last_month.sod(), last_day_of_last_month.eod());
      while (true) {
        progress_made = this.date_times.some(function(date) {
          return range.contains(date);
        });
        if (progress_made) {
          this.streak += 1;
        } else {
          break;
        }
        previous_start = range.start.clone().subtract('months', 1).sod();
        previous_end = range.start.clone().subtract('days', 1).eod();
        range = moment().range(previous_start, previous_end);
      }
      first_day_of_month = this.now().subtract('days', this.now().date() - 1);
      last_day_of_month = first_day_of_month.clone().add('months', 1).subtract('days', 1);
      current_range = moment().range(first_day_of_month.sod(), last_day_of_month.eod());
      if (this.date_times.some(function(date) {
        return current_range.contains(date);
      })) {
        return this.streak += 1;
      }
    };

    StreakCalculator.prototype.calculate_weekly = function() {
      var current_range, days_since_sunday, last_week_range, previous_end, previous_start, progress_made, range, saturday, saturday_last_week, sunday, sunday_last_week;
      days_since_sunday = this.now().day();
      sunday_last_week = this.now().subtract('weeks', 1).subtract('days', days_since_sunday);
      saturday_last_week = sunday_last_week.clone().add('days', 6);
      last_week_range = moment().range(sunday_last_week.sod(), saturday_last_week.eod());
      range = last_week_range;
      while (true) {
        progress_made = this.date_times.some(function(date) {
          return range.contains(date);
        });
        if (progress_made) {
          this.streak += 1;
        } else {
          break;
        }
        previous_start = range.start.clone().subtract('weeks', 1).sod();
        previous_end = range.end.clone().subtract('weeks', 1).eod();
        range = moment().range(previous_start, previous_end);
      }
      sunday = this.now().subtract('days', days_since_sunday);
      saturday = sunday.clone().add('days', 6);
      current_range = moment().range(sunday.sod(), saturday.eod());
      if (this.date_times.some(function(date) {
        return current_range.contains(date);
      })) {
        return this.streak += 1;
      }
    };

    return StreakCalculator;

  })();

  if (typeof exports !== "undefined" && exports !== null) {
    exports.StreakCalculator = StreakCalculator;
  }

  ALL_DAYS = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];

  Streaker = (function() {

    function Streaker(times, frequency, days_whitelist) {
      this.times = times;
      this.frequency = frequency;
      this.days_whitelist = days_whitelist;
    }

    Streaker.prototype.current = function() {
      return new StreakCalculator(this.times, this.frequency, this.days_whitelist).calculate();
    };

    return Streaker;

  })();

  this.streaker = function(times, frequency, days_whitelist) {
    if (frequency == null) frequency = 'daily';
    if (days_whitelist == null) days_whitelist = ALL_DAYS;
    return new Streaker(times, frequency, days_whitelist);
  };

}).call(this);
