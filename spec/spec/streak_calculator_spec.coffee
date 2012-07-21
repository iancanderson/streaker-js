describe 'streak calculator', ->

  it 'should return 0 without parameters', ->
    expect(streaker().current()).toEqual(0)

