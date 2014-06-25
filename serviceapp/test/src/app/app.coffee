should = require 'should'

testDir =  __dirname + '/../../'
Mock = require (testDir + 'mock')

ServiceApp = require testDir + '../src/app/service_app'

suite "Service App", ->
  app = undefined
  restifyMock = undefined
  serverMock = undefined
  confMock = undefined
  routerMock = undefined
  pluginsMock = undefined
  authMock = undefined
  
  setup ->
    confMock = new Mock([
      {
        name: "loadBaseConfig"
      }
      {
        name: "loadEnvSpecificConfigFile"
      }
    ])
    serverMock = new Mock([
      {name: "listen"}
      {name: "use"}
      {
        name: "on"
        return_value: true
      }
    ])
    restifyMock = new Mock([
      {
        name: "createServer"
        return_value: serverMock
      }
      {name: "bodyParser"}
      {name: "queryParser"}
    ])
    app = new ServiceApp(null, restifyMock) # Restify and conf
    return

  suite "Configuration", ->
    test "Null configure object", ->
      (->
        app.init()
        return
      ).should.throw()
      return

    test "Configure call", (done) ->
      app.conf = confMock
      app.init ->
        confMock.loadBaseConfig_called.should.be.true
        return

      done()
      return

    test "Conf get/set", ->
      app.set "ASDF", "DUMMY"
      app.get("ASDF").should.equal "DUMMY"
      return

    return

  suite "Server", ->
    test "Create Without conf", ->
      app = new ServiceApp(null, restifyMock)
      (->
        app.init()
        return
      ).should.throw()
      return

    test "Create with Valid Configuration", ->
      app = new ServiceApp(confMock, restifyMock)
      app.init ->
        restifyMock.createServer_called.should.be.true
        return

      return

    test "Server listen", (done) ->
      app = new ServiceApp(confMock, restifyMock)
      app.init ->
        app.run()
        serverMock.listen_called.should.be.true
        return

      done()
      return

    return

  suite "Route Setup", ->
    test "Setup Router", ->
      routerMock = new Mock(["setup"])
      app = new ServiceApp(confMock, restifyMock)
      app.router = routerMock
      return

    return

  suite "Plugin Setup", ->
    test "Setup Plugins", ->
      pluginsMock = new Mock(["setup"])
      app = new ServiceApp(confMock, restifyMock)
      app.router = pluginsMock
      app.init ->
        pluginsMock.setup_called.should.be.true
        return

      return

    return

  return
