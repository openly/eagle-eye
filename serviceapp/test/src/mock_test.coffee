Mock = require("./mock")
myMock = new Mock([
  {
    name: "asdf"
    return_value: "abhi"
  }
  {
    name: "qwer"
    callback_args: ["i am from callback"]
  }
])
console.log myMock.asdf()
myMock.qwer (res) ->
  console.log res
  return

console.log myMock.asdf_called
console.log myMock.qwer_called
Mock = require("./mock")
should = require("should")
setup ->
  console.log "setup"
  return

suiteTeardown ->
  console.log "teardown"
  return

suite "Substitution", ->
  appMock = undefined
  test "Test", (done) ->
    console.log "test case"
    done()
    return

  test "Test", (done) ->
    console.log "test case"
    done()
    return

  test "Test", (done) ->
    console.log "test case"
    done()
    return

  return

suite "Substitution", ->
  appMock = undefined
  test "Test", (done) ->
    console.log "test case"
    done()
    return

  test "Test", (done) ->
    console.log "test case"
    done()
    return

  test "Test", (done) ->
    console.log "test case"
    done()
    return

  return
