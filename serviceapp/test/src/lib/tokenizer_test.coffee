should = require("should")

testDir =  __dirname + '/../../'
Mock = require (testDir + 'mock')

md5 = require "MD5"

Tokenizer = require(testDir + '../src/lib/tokenizer')
global.EEConstants = require(testDir + '../src/constants.coffee')

suite "Create Token", ->
  test "Writable FS", (done) ->
    fsMockValid = new Mock([
      name: "outputFile"
      return_value: null
    ])
    appMock = new Mock([
      name: "get"
      return_value: 1
    ])
    tokenizerObj = new Tokenizer(appMock, fsMockValid)
    tokenizerObj.createToken "", (token) ->
      fsMockValid.outputFile_called.should.be.true
      done()
      return
    return
  return


suite "Destroy Token", ->
  appMock = new Mock([
    name: "get"
    return_value: 1
  ])
  test "Token exists", (done) ->

    fsMockValid = new Mock([
      {
        name: "unlink"
        return_value: null
      }
      {
        name: "existsSync"
        return_value: true
      }
    ])
    tokenizerObj = new Tokenizer(appMock, fsMockValid)
    tokenizerObj.deleteToken "token", (isTokenDeleted) ->
      isTokenDeleted.should.be.true
      done()
      return

  test "Token does not exists", (done) ->
    fsMockValid = new Mock([
      {
        name: "unlink"
        return_value: null
      }
      {
        name: "existsSync"
        return_value: false
      }
    ])
    tokenizerObj = new Tokenizer(appMock, fsMockValid)
    tokenizerObj.deleteToken "token", (isTokenDeleted) ->
      isTokenDeleted.should.be.false
      done()
      return
    return

suite "Is Authorised", ->
  
  appMock = new Mock([
    name: "get"
    return_value: 1
  ])
  
  fsMockValid = new Mock([
    {
      name: "readFile"
      callback_args: [
        null
        "dummy|dummy"
      ]
    }
    {
      name: "existsSync"
      return_value: true
    }
  ])

  test "Token file not found", (done) ->
    fsMockInValid = new Mock([
      {
        name: "readFile"
        callback_args: [
          null
          "dummy|dummy"
        ]
      }
      {
        name: "existsSync"
        return_value: false
      }
    ])
    validUserInfoMock = new Mock([
      name: "getRoles"
      callback_args: [["dummyRole"]]
    ])
    tokenizerObj = new Tokenizer(appMock, fsMockInValid, validUserInfoMock)
    tokenizerObj.isAuthorised "dummyRole", "asd", (success) ->
      success.should.be.false
      done()
      return
    return

  test "No user role found", (done) ->
    validUserInfoMock = new Mock([
      name: "getUserRole"
      callback_args: []
    ])
    tokenizerObj = new Tokenizer(appMock, fsMockValid, validUserInfoMock)
    tokenizerObj.isAuthorised "user", "asd", (success) ->
      success.should.be.false
      done()
      return
    return

  test "admin required, user is admin", (done) ->
    validUserInfoMock = new Mock([
      name: "getUserRole"
      callback_args: [["admin"]]
    ])
    tokenizerObj = new Tokenizer(appMock, fsMockValid, validUserInfoMock)
    tokenizerObj.isAuthorised "admin", "asd", (success) ->
      success.should.be.true
      done()
      return
    return

  test "admin required, user is normal user ", (done) ->

    validUserInfoMock = new Mock([
      name: "getUserRole"
      callback_args: [["user"]]
    ])

    tokenizerObj = new Tokenizer(appMock, fsMockValid, validUserInfoMock)
    tokenizerObj.isAuthorised "admin", "asd", (success) ->
      success.should.be.false
      done()
      return
    return
  return

suite "Get User ID", ->
  userID = "QWERT1245"
  fsMockValid = new Mock([
    {
      name: "readFile"
      callback_args: [
        null
        userID + "|dummy"
      ]
    }
    {
      name: "existsSync"
      return_value: true
    }
  ])

  fsMockInValid = new Mock([
    {
      name: "readFile"
      callback_args: [
        null
        userID + "|dummy"
      ]
    }
    {
      name: "existsSync"
      return_value: false
    }
  ])
    
  appMock = new Mock([
    name: "get"
    return_value: 1
  ])
  
  validUserInfoMock = new Mock([
    name: "getRoles"
    callback_args: [["admin"]]
  ])

  test "Valid", (done) ->
    tokenizerObj = new Tokenizer(appMock, fsMockValid, validUserInfoMock)
    tokenizerObj.getUid md5(userID + "dummy1"), (uid) ->
      uid.should.equal userID
      done()
      return
    return

  test "No token", (done) ->
    tokenizerObj = new Tokenizer(appMock, fsMockInValid, validUserInfoMock)
    tokenizerObj.getUid md5(userID + "dummy1"), (uid) ->
      uid.should.equal false
      done()
      return
    return

  test "Token sent is not equal to generated one", (done) ->
    tokenizerObj = new Tokenizer(appMock, fsMockValid, validUserInfoMock)
    tokenizerObj.getUid md5(userID + "dummy12"), (uid) ->
      uid.should.equal false
      done()
      return
    return



  return
