should = require 'should'

testDir =  __dirname + '/../../'
Mock = require (testDir + 'mock')

global.EEConstants = require(testDir + '../src/constants.coffee')
LoginRoute = require(testDir + '../src/router/login')

authMock = undefined
appMock = undefined
loginRoute = undefined
suite "Login", ->
  test "Valid User", ->
    authMock = new Mock([
      name: "login"
      callback_args: [
        true
        "dummy"
        "dummy"
        "dummy"
        "dummy"
      ]
    ])
    appMock = auth: authMock
    reqMock = new Mock([])
    reqMock.params =
      user: ""
      pass: ""

    loginRoute = new LoginRoute(appMock)
    loginRoute.login reqMock, (err, res) ->
      res.status.should.equal "success"
      return

    return

  test "Invalid User", ->
    authMock = new Mock([
      name: "login"
      callback_args: [
        false
        "dummy"
        "dummy"
        "dummy"
        "dummy"
      ]
    ])
    appMock = auth: authMock
    reqMock = new Mock([])
    reqMock.params =
      user: ""
      pass: ""

    loginRoute = new LoginRoute(appMock)
    loginRoute.login reqMock, (err, res) ->
      res.status.should.equal "failure"
      return

    return

  return

suite "Log out", ->
  test "Valid User", ->
    authMock = new Mock([
      name: "logout"
      callback_args: []
    ])
    appMock = auth: authMock
    reqMock = new Mock([])
    reqMock.query = access_token: "dummy"
    loginRoute = new LoginRoute(appMock)
    loginRoute.logout reqMock, ->
      authMock.logout_called.should.be.true
      return

    return

  return