(function() {
  var ALL_DAYS, StreakCalculator, Streaker;

  StreakCalculator = (typeof require !== "undefined" && require !== null ? require('./streak_calculator') : this.StreakCalculator).StreakCalculator;

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

  exports.streaker = function(times, frequency, days_whitelist) {
    if (frequency == null) frequency = 'daily';
    if (days_whitelist == null) days_whitelist = ALL_DAYS;
    return new Streaker(times, frequency, days_whitelist);
  };

}).call(this);
