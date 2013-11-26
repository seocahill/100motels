describe "orderTotal", ->

  it "should calculate the correct total", ->
    expect( orderTotal() ).toBe(4)