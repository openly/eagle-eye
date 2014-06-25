should = require("should")

testDir =  __dirname + '/../../'
Mock = require (testDir + 'mock')

Auth = require(testDir + '../src/lib/auth')

authObj = undefined
appMock = undefined
validUserInfoMock = undefined
inValidUserInfoMock = undefined
restifyMock = undefined
tokenMock = undefined

suite "Negative Tests", ->
  test "Null App", ->

  test "Null Token", ->

  test "Null UserInfo", ->

  test "Not initialized", ->

  return

suite "Login", ->
  test "Valid", (done) ->
    appMock = new Mock([
      name: "get"
      return_value: 0.01
    ])
    tokenMock = new Mock([
      "createToken"
      {
        name: "deleteToken"
        callback_args: [true]
      }
    ])
    validUserInfoMock = new Mock([
      name: "login"
      callback_args: [
        true
        1
      ]
    ])
    authObj = new Auth(validUserInfoMock, tokenMock)
    authObj.init appMock
    authObj.login "", "", (loginsuccess, token) ->
      loginsuccess.should.be.true
      validUserInfoMock.login_called.should.be.true
      tokenMock.createToken_called.should.be.true
      done()
      return

    return

  test "Invalid user", (done) ->
    appMock = new Mock([
      name: "get"
      return_value: 0.01
    ])
    tokenMock = new Mock([
      "createToken"
      {
        name: "deleteToken"
        callback_args: [true]
      }
    ])
    inValidUserInfoMock = new Mock([
      name: "login"
      callback_args: [
        false
        null
      ]
    ])
    authObj = new Auth(inValidUserInfoMock, tokenMock)
    authObj.init appMock
    authObj.login "", "", (loginsuccess, token) ->
      loginsuccess.should.be.false
      validUserInfoMock.login_called.should.be.true
      should.not.exist tokenMock.createToken_called
      done()
      return

    return

  test "Invalid password", ->

  test "Auto destroy", (done) ->
    appMock = new Mock([
      name: "get"
      return_value: 0.01
    ])
    tokenMock = new Mock([
      {
        name: "createToken",
        callback_args: [123456]
      }
      {
        name: "deleteToken"
        callback_args: [true]
      }
    ])
    validUserInfoMock = new Mock([
      name: "login"
      callback_args: [
        true
        1
      ]
    ])
    authObj = new Auth(validUserInfoMock, tokenMock)
    authObj.init appMock
    authObj.login "", "", (loginsuccess, token) ->
      loginsuccess.should.be.true
      validUserInfoMock.login_called.should.be.true
      tokenMock.createToken_called.should.be.true
      setTimeout (->
        tokenMock.deleteToken_called.should.be.true
        done()
        return
      ), 20
      return

    return

  
  # when setTimout is called make sure that tokenMock.
  #deleeToke is not called
  test "Token Not deleted", (done) ->
    appMock = new Mock([
      name: "get"
      return_value: 1
    ])
    validUserInfoMock = new Mock([
      name: "getRoles"
      callback_args: [
        true
        1
      ]
    ])
    tokenMock = new Mock([
      {
        name: "deleteToken"
        callback_args: [true]
      }
      {
        name: "isAuthorised"
        callback_args: [true]
      }
    ])
    authObj = new Auth(validUserInfoMock, tokenMock)
    authObj.init appMock
    reqMock = new Mock([])
    resMock = new Mock(["send"])
    nextMock = new Mock(["next"])
    reqMock.query = access_token: ""
    
    # var authInfo = authObj.authorise("Admin",);
    authObj.authorise "Admin", reqMock, resMock, ->
      nextMock.next()
      return

    nextMock.next_called.should.be.true
    tokenMock.isAuthorised_called.should.be.true
    should.not.exist tokenMock.deleteToken_called
    done()
    return

  return

suite "Logout", ->
  test "Valid user", (done) ->
    appMock = new Mock([
      name: "get"
      return_value: 1
    ])
    tokenMock = new Mock([
      name: "deleteToken"
      callback_args: [true]
    ])
    validUserInfoMock = new Mock(["dummy"])
    authObj = new Auth(validUserInfoMock, tokenMock)
    authObj.init appMock
    authObj.logout "123456", (e, logoutSuccess) ->
      logoutSuccess.should.be.true
      
      # validUserInfoMock.logout_called.should.be.true;
      tokenMock.deleteToken_called.should.be.true
      done()
      return

    return

  test "Is Token Deleted", (done) ->
    appMock = new Mock([
      name: "get"
      return_value: 1
    ])
    tokenMock = new Mock([
      name: "deleteToken"
      callback_args: [false]
    ])
    validUserInfoMock = new Mock(["dummy"])
    authObj = new Auth(validUserInfoMock, tokenMock)
    authObj.init appMock
    authObj.logout "123456", (e, logoutSuccess) ->
      logoutSuccess.should.be.false
      
      # validUserInfoMock.logout_called.should.be.true;
      tokenMock.deleteToken_called.should.be.true
      done()
      return

    return

  return

suite "Authorise", ->
  test "Authorised", ->
    appMock = new Mock([
      name: "get"
      return_value: 1
    ])
    validUserInfoMock = new Mock([
      name: "getRoles"
      callback_args: [
        true
        1
      ]
    ])
    tokenMock = new Mock([
      {
        name: "getToken"
        callback_args: [
          true
          1
        ]
      }
      {
        name: "deleteToken"
        callback_args: [true]
      }
      {
        name: "isAuthorised"
        callback_args: [true]
      }
    ])
    authObj = new Auth(validUserInfoMock, tokenMock)
    authObj.init appMock
    reqMock = new Mock([])
    resMock = new Mock(["send"])
    nextMock = new Mock(["next"])
    reqMock.query = access_token: ""
    authObj.authorise "Admin", reqMock, resMock, ->
      nextMock.next()
      return

    nextMock.next_called.should.be.true
    return

  test "Not Authorised", ->
    appMock = new Mock([
      name: "get"
      return_value: 1
    ])
    validUserInfoMock = new Mock([
      name: "getRoles"
      callback_args: [
        true
        1
      ]
    ])
    tokenMock = new Mock([
      {
        name: "getToken"
        callback_args: [
          true
          1
        ]
      }
      {
        name: "deleteToken"
        callback_args: [true]
      }
      {
        name: "isAuthorised"
        callback_args: [false]
      }
    ])
    authObj = new Auth(validUserInfoMock, tokenMock)
    authObj.init appMock
    reqMock = new Mock([])
    resMock = new Mock(["send"])
    reqMock.query = access_token: ""
    authObj.authorise "Admin", reqMock, resMock, (success, err) ->
      success.should.be.false
      return

    return

  return

suite "Get Roles", ->
  test "Valid user", (done) ->
    appMock = new Mock([
      name: "get"
      return_value: 1
    ])
    tokenMock = new Mock([
      name: "getUid"
      callback_args: [1]
    ])
    validUserInfoMock = new Mock([
      name: "getUserRole"
      callback_args: ["dummyRole"]
    ])
    authObj = new Auth(validUserInfoMock, tokenMock)
    authObj.init appMock
    authObj.getUserRole "", (role) ->
      role.should.be.equal "dummyRole"
      tokenMock.getUid_called.should.be.true
      validUserInfoMock.getUserRole_called.should.be.true
      done()
      return

    return

  test "No Roles", (done) ->
    appMock = new Mock([
      name: "get"
      return_value: 1
    ])
    tokenMock = new Mock([
      name: "getUid"
      callback_args: [1]
    ])
    validUserInfoMock = new Mock([
      name: "getUserRole"
      callback_args: [null]
    ])
    authObj = new Auth(validUserInfoMock, tokenMock)
    authObj.init appMock
    authObj.getUserRole "", (role) ->
      role.should.be.false
      tokenMock.getUid_called.should.be.true
      validUserInfoMock.getUserRole_called.should.be.true
      done()
      return

    return

  test "Invalid User", (done) ->
    appMock = new Mock([
      name: "get"
      return_value: 1
    ])
    tokenMock = new Mock([
      name: "getUid"
      callback_args: [null]
    ])
    validUserInfoMock = new Mock([
      name: "getUserRole"
      callback_args: [null]
    ])
    authObj = new Auth(validUserInfoMock, tokenMock)
    authObj.init appMock
    authObj.getUserRole "", (role) ->
      role.should.be.false
      tokenMock.getUid_called.should.be.true
      should.not.exist validUserInfoMock.getUserRole_called
      done()
      return

    return

  return

suite "Get User Details", ->
  test "Valid user", (done) ->
    appMock = new Mock([
      name: "get"
      return_value: 1
    ])
    tokenMock = new Mock([
      name: "getUid"
      callback_args: [1]
    ])
    validUserInfoMock = new Mock([
      name: "getDetails"
      callback_args: [
        null
        true
      ]
    ])
    authObj = new Auth(validUserInfoMock, tokenMock)
    authObj.init appMock
    authObj.getUserDetails "", (userDetails) ->
      userDetails.should.be.true
      tokenMock.getUid_called.should.be.true
      validUserInfoMock.getDetails_called.should.be.true
      done()
      return

    return

  test "No UID", (done) ->
    appMock = new Mock([
      name: "get"
      return_value: 1
    ])
    tokenMock = new Mock([
      name: "getUid"
      callback_args: [false]
    ])
    validUserInfoMock = new Mock([])
    validUserInfoMock = new Mock([
      name: "getDetails"
      callback_args: [false]
    ])
    authObj = new Auth(validUserInfoMock, tokenMock)
    authObj.init appMock
    authObj.getUserDetails "", (userDetails) ->
      userDetails.should.be.false
      tokenMock.getUid_called.should.be.true
      done()
      return

    return

  test "Invalid User", (done) ->
    appMock = new Mock([
      name: "get"
      return_value: 1
    ])
    tokenMock = new Mock([
      name: "getUid"
      callback_args: [1]
    ])
    invalidUserInfoMock = new Mock([
      name: "getDetails"
      callback_args: [
        null
        false
      ]
    ])
    authObj = new Auth(invalidUserInfoMock, tokenMock)
    authObj.init appMock
    authObj.getUserDetails "", (userDetails) ->
      userDetails.should.be.false
      tokenMock.getUid_called.should.be.true
      done()
      return

    return

  return