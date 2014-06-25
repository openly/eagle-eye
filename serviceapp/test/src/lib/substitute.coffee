should = require("should")

testDir =  __dirname + '/../../'
Mock = require (testDir + 'mock')

substitute = require( testDir + '../src/lib/substitute')

suite "Substitution", ->
  appMock = undefined
  setup ->
    appMock = new Mock([
      name: "get"
      return_value: "DUMMY"
    ])
    return

  test "Single Substitution", ->
    substitute(appMock, "${ANYTHING}").should.equal "DUMMY"
    return

  test "Multiple Substitution", ->
    val = substitute(appMock, [
      "${ANYTHING}"
      "${ANYTHING}"
    ])
    val[0].should.equal "DUMMY"
    return

  return
