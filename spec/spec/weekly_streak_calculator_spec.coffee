describe 'weekly streak calculator', ->

  beforeEach ->
    now = new Date(2012, 6, 8)
    @now_moment = moment(now)
    @frequency = 'weekly'
    # this freezes the clock
    @clock = sinon.useFakeTimers(now.getTime())

  afterEach ->
    @clock.restore()
  
  it "should count last week and the week before as 2", ->
    @dates = (@now_moment.clone().subtract('weeks', num) for num in [2..1])
    expect(streaker(@dates, @frequency).current()).toEqual 2

  it "should count this week and last week as 2", ->
    @dates = (@now_moment.clone().subtract('days', num) for num in [1..0])
    expect(streaker(@dates, @frequency).current()).toEqual 2

  it "should count two weeks ago as 0", ->
    @dates = [@now_moment.clone().subtract('weeks', 2)]
    expect(streaker(@dates, @frequency).current()).toEqual 0

