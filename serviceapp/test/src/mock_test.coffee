should = require 'should'

testDir =  __dirname + '/../'
Mock = require (testDir + 'mock')

myMock = new Mock([
  {
    name: "fnName"
    return_value: "fnRetVal"
  }
  {
    name: "cbFnName"
    callback_args: ["I am from callback"]
  }
])

suite "Mock Function", ->
  test "Not calling the mock function", (done) ->
    myMock.fnName_called.should.be.false
    done()
    return

  test "After calling the mock function", (done) ->
    value = myMock.fnName()

    myMock.fnName_called.should.be.true
    value.should.be.equal('fnRetVal')
    
    done()
    return

  return

suite "Mock Callback Function", ->

  test "Not calling the mock callback function", (done) ->
    myMock.cbFnName_called.should.be.false
    done()
    return
  
  test "After calling the mock callback function", (done) ->
    myMock.cbFnName (res) ->
      res.should.be.equal("I am from callback")
      return

    myMock.cbFnName_called.should.be.true
    done()
    return

  return
