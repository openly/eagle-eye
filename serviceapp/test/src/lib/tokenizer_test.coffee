Tokenizer = require("../src/lib/tokenizer")
Mock = require("./mock")
should = require("should")
md5 = require("MD5")
fs = require("fs")
tokenizerObj = undefined
appMock = undefined
fsMockValid = undefined
validUserInfoMock = undefined
suite "Create Token", ->
  test "Writable FS", (done) ->
    fsMockValid = new Mock([
      name: "writeFile"
      return_value: null
    ])
    appMock = new Mock([
      name: "get"
      return_value: 1
    ])
    tokenizerObj = new Tokenizer(appMock, fsMockValid)
    tokenizerObj.createToken "", (token) ->
      fsMockValid.writeFile_called.should.be.true
      done()
      return

    return

  return

suite "Validate Token", ->
  test "Valid Test", (done) ->
    fsMockValid = new Mock([
      name: "readFile"
      callback_args: [
        null
        "dummy|dummy"
      ]
    ])
    appMock = new Mock([
      name: "get"
      return_value: 1
    ])
    tokenizerObj = new Tokenizer(appMock, fsMockValid)
    tokenizerObj.validateToken md5("dummydummy1"), (isTokenValid) ->
      isTokenValid.should.be.true
      return

    done()
    return

  test "Invalid User", (done) ->
    done()
    return

  return

suite "Destroy Token", ->
  test "Valid User", (done) ->
    appMock = new Mock([
      name: "get"
      return_value: 1
    ])
    fsMockValid = new Mock([
      name: "unlink"
      return_value: null
    ])
    tokenizerObj = new Tokenizer(appMock, fsMockValid)
    tokenizerObj.deleteToken "token", (isTokenDeleted) ->
      isTokenDeleted.should.be.true
      done()
      return

    return

  test "Invalid User", (done) ->
    done()
    return

  return

suite "Test Is Authorised", ->
  test "Valid Role", (done) ->
    appMock = new Mock([
      name: "get"
      return_value: 1
    ])
    fsMockValid = new Mock([
      name: "readFile"
      callback_args: [
        null
        "dummy|dummy"
      ]
    ])
    validUserInfoMock = new Mock([
      name: "getRoles"
      callback_args: [["dummyRole"]]
    ])
    tokenizerObj = new Tokenizer(appMock, fsMockValid, validUserInfoMock)
    tokenizerObj.isAuthorised "dummyRole", "asd", (success) ->
      success.should.be.true
      done()
      return

    return

  test "Invalid Role", (done) ->
    appMock = new Mock([
      name: "get"
      return_value: 1
    ])
    fsMockValid = new Mock([
      name: "readFile"
      callback_args: [
        null
        "dummy|dummy"
      ]
    ])
    validUserInfoMock = new Mock([
      name: "getRoles"
      callback_args: [["dummyRole"]]
    ])
    tokenizerObj = new Tokenizer(appMock, fsMockValid, validUserInfoMock)
    tokenizerObj.isAuthorised "SomeOtherdummyRole", "asd", (success) ->
      success.should.be.false
      done()
      return

    return

  return

suite "Test Get User ID", ->
  test "Valid Token", (done) ->
    appMock = new Mock([
      name: "get"
      return_value: 1
    ])
    fsMockValid = new Mock([
      name: "readFile"
      callback_args: [
        null
        "1|dummy"
      ]
    ])
    validUserInfoMock = new Mock([
      name: "getRoles"
      callback_args: [["dummyRole"]]
    ])
    tokenizerObj = new Tokenizer(appMock, fsMockValid, validUserInfoMock)
    tokenizerObj.getUid md5("1dummy1"), (uid) ->
      uid.should.equal "1"
      done()
      return

    return

  test "Invalid Token", (done) ->
    appMock = new Mock([
      name: "get"
      return_value: 1
    ])
    fsMockValid = new Mock([
      name: "readFile"
      callback_args: [
        null
        "1rwer|dummy"
      ]
    ])
    validUserInfoMock = new Mock([
      name: "getRoles"
      callback_args: [["dummyRole"]]
    ])
    tokenizerObj = new Tokenizer(appMock, fsMockValid, validUserInfoMock)
    tokenizerObj.getUid md5("1dummy1"), (uid) ->
      uid.should.not.equal "1"
      done()
      return

    return

  return
