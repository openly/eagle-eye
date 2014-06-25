should = require 'should'

testDir =  __dirname + '/../'
Mock = require (testDir + 'mock')

ConfigLoader = require(testDir + '../src/config_loader')

suite "Configuration Reader[JSON Based]", ->
  confReader = undefined
  appMock = undefined
  fsMockInvalid = undefined
  fsMockValid = undefined
  setup ->
    appMock = new Mock([
      "get"
      "set"
    ])
    fsMockInvalid = new Mock([
      name: "readFile"
      callback_args: [
        true
        null
      ]
    ])
    fsMockValid = new Mock([
      name: "readFile"
      callback_args: [
        null
        "{\"asdf\":\"qwer\"}"
      ]
    ])
    return

  suite "Load Basic Config File", ->
    test "File Not Exists Negative Test", (done) ->
      confReader = new ConfigLoader("", fsMockInvalid, fsMockInvalid)
      (->
        confReader.loadBaseConfig appMock, ->

        return
      ).should.throw()
      done()
      return

    test "Valid Test", (done) ->
      confReader = new ConfigLoader("", fsMockValid, fsMockValid)
      confReader.loadBaseConfig appMock, ->
        appMock.set_called.should.be.true
        done()
        return

      return

    return

  suite "Environment Specific Config File", ->
    test "File Not Exists Negative Test", (done) ->
      confReader = new ConfigLoader("", fsMockInvalid, fsMockInvalid)
      (->
        confReader.loadEnvSpecificConfigFile appMock, ->

        return
      ).should.throw()
      done()
      return

    test "Valid Test", (done) ->
      confReader = new ConfigLoader("", fsMockValid, fsMockValid)
      confReader.loadEnvSpecificConfigFile appMock, ->
        appMock.set_called.should.be.true
        done()
        return

      return

    return

  return
