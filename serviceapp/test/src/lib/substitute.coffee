substitute = require("../src/lib/substitute")
Mock = require("./mock")
should = require("should")
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
