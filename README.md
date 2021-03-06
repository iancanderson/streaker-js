streaker-js
===========

Calculate daily, weekly, and monthly streaks from a list of Javscript Date objects.

Examples
--------

Determine the current streak (daily by default):

``` javascript
// Assuming the date is currently new Date(2012, 6, 8) :
var dates = [ new Date(2012, 6, 6), new Date(2012, 6, 7), new Date(2012, 6, 8) ];
var currentStreak = streaker(dates).current(); // 3

var datesWithoutToday = [ new Date(2012, 6, 6), new Date(2012, 6, 7) ];
var currentStreak = streaker(datesWithoutToday).current(); // 2 - the streak isn't broken until the end of the day

var datesWithoutTodayOrYesterday = [ new Date(2012, 6, 6) ];
var currentStreak = streaker(datesWithoutTodayOrYesterday).current(); // 0 - the streak is broken as of today
```

Optionally pass in a whitelist for days of the week to consider.
Days not in the list will be ignored when calculating the streak.

``` javascript
// Assuming the date is currently new Date(2012, 6, 8), which is a Sunday :
var weekdays = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday']
var dates = [ new Date(2012, 6, 6), new Date(2012, 6, 7), new Date(2012, 6, 8) ];
var currentStreak = streaker(dates, 'daily', weekdays).current(); // 1, because today and yesterday don't count

// Assuming the date is currently new Date(2012, 6, 9), which is a Monday :
var weekdays = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday']
var dates = [ new Date(2012, 6, 6) ]; // last friday
var currentStreak = streaker(dates, 'daily', weekdays).current(); // 1, because the weekend didn't count
```

Weekly:

``` javascript
// Assuming the date is currently new Date(2012, 6, 8), which is a Sunday :
// Week starts on Sunday
var dates = [ new Date(2012, 5, 26), new Date(2012, 6, 1), new Date(2012, 6, 8) ];
var currentStreak = streaker(dates, 'weekly').current(); // 3
```

Monthly:

``` javascript
// Assuming the date is currently new Date(2012, 6, 8) :
var dates = [ new Date(2012, 4, 8), new Date(2012, 5, 8), new Date(2012, 6, 8) ];
var currentStreak = streaker(dates, 'monthly').current(); // 3
```

Installation
------------

### Node

Install via npm:

``` bash
npm install streaker-js
```

Running Tests
-------------

Clone this repo:

``` bash
$ git clone https://github.com/iancanderson/streaker-js.git
```

Install the dependencies:

``` bash
$ npm install
```

Run the tests:

``` bash
$ cake test
```

