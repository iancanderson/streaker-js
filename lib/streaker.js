(function() {
  var ALL_DAYS, Streaker;

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
