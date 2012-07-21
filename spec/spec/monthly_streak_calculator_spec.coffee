describe 'monthly streak calculator', ->

  beforeEach ->
    now = new Date(2012, 6, 1)
    @now_moment = moment(now)
    @frequency = 'monthly'
    # this freezes the clock
    @clock = sinon.useFakeTimers(now.getTime())

  afterEach ->
    @clock.restore()
  
  it "should count last month and the month before as 2", ->
    @dates = (@now_moment.clone().subtract('months', num) for num in [2..1])
    expect(streaker(@dates, @frequency).current()).toEqual 2

  it "should count this month and last month as 2", ->
    @dates = (@now_moment.clone().subtract('months', num) for num in [1..0])
    expect(streaker(@dates, @frequency).current()).toEqual 2

  it "should count two months ago as 0", ->
    @dates = [@now_moment.clone().subtract('months', 2)]
    expect(streaker(@dates, @frequency).current()).toEqual 0

