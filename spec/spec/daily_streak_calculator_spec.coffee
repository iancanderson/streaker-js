describe 'daily streak calculator', ->

  describe 'all days', ->

    beforeEach ->
      now = new Date(2012, 6, 8)
      @now_moment = moment(now)
      # this freezes the clock
      @clock = sinon.useFakeTimers(now.getTime())

    afterEach ->
      @clock.restore()
    
    it "should count yesterday and the day before as 2", ->
      @dates = (@now_moment.clone().subtract('days', num) for num in [2..1])
      expect(streaker(@dates).current()).toEqual(2)

    it "should count today and yesterday as 2", ->
      @dates = (@now_moment.clone().subtract('days', num) for num in [1..0])
      expect(streaker(@dates).current()).toEqual(2)

    it "should count the day before yesterday as 0", ->
      @dates = [@now_moment.clone().subtract('days', 2)]
      expect(streaker(@dates).current()).toEqual(0)

  describe 'weekdays', ->

    beforeEach ->
      # 'Today' is a sunday
      now = new Date(2012, 6, 8)
      @now_moment = moment(now)
      @days_whitelist = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday']
      @frequency = 'daily'
      # this freezes the clock
      @clock = sinon.useFakeTimers(now.getTime())

    afterEach ->
      @clock.restore()
    
    it "should count all consecutive previous weekdays", ->
      @dates = (@now_moment.clone().subtract('days', num) for num in [6..2])
      # @dates is M-F, so we streak should be 5
      expect(streaker(@dates, @frequency, @days_whitelist).current()).toEqual 5

    it "should not count weekends", ->
      @dates = (@now_moment.clone().subtract('days', num) for num in [6..0])
      # @dates is M-F, so we streak should be 5
      expect(streaker(@dates, @frequency, @days_whitelist).current()).toEqual 5

