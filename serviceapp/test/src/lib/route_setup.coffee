Router = require("../src/lib/router/setup")
Mock = require("./mock")
nodemock = require("nodemock")
should = require("should")
suite "Router setup [JSON Based]", ->
  router = undefined
  appMock = undefined
  serverMock = undefined
  fsMock = undefined
  authMock = undefined
  setup ->
    appMock = nodemock.mock("get").takes("ROUTER_DIR").returns(__dirname + "/mock/router/").times(10)
    appMock.mock("get").takes("ROUTE_CONFIG_FILES").returns(["dummy"]).times 10
    responseMock = new Mock(["send1"])
    requestMock = new Mock([""])
    nextMock = new Mock([""])
    authMock = nodemock.mock("authorise").takes("SuperAdmin", "", responseMock).calls(1, [
      false
      null
    ]).times(6)
    appMock.auth = authMock
    serverMock = nodemock.mock("get").takes("/version", (requestMock, responseMock, nextMock) ->
    ).returns().times(6)
    serverMock.mock("post").takes("/version", (requestMock, responseMock, nextMock) ->
    ).returns().times 6
    serverMock.mock("head").takes("/version", (requestMock, responseMock, nextMock) ->
    ).returns().times 6
    return

  suite "Negative tests", ->
    test "Invalid module", ->

    
    # TODO: Asynchronous exception handling. Not sure how.
    # router = new Router(__dirname + '/tmp/router_invalid_module.json');
    # (function(){ router.setup() }).throw();
    test "Invalid method", ->

    return

  
  # TODO: Asynchronous exception handling. Not sure how.
  suite "Route execution", ->
    test "GET Request", (done) ->
      fsMock = new Mock([
        name: "readFile"
        callback_args: [
          null
          "{\"/version\":{\"module\":\"dummy\",\"authorisation\":\"SuperAdmin\"}}"
        ]
      ])
      router = new Router(fsMock)
      router.setup appMock, serverMock, ->
        
        # serverMock.get_called.should.be.true;
        done()
        return

      return

    test "POST Request", (done) ->
      fsMock = new Mock([
        name: "readFile"
        callback_args: [
          null
          "{\"/version\":{\"module\":\"dummy\",\"req_method\":\"post\",\"authorisation\":\"SuperAdmin\"}}"
        ]
      ])
      router = new Router(fsMock)
      router.setup appMock, serverMock, ->
        
        # serverMock.post_called.should.be.true;
        done()
        return

      return

    test "HEAD Request", (done) ->
      fsMock = new Mock([
        name: "readFile"
        callback_args: [
          null
          "{\"/version\":{\"module\":\"dummy\",\"req_method\":\"head\",\"authorisation\":\"SuperAdmin\"}}"
        ]
      ])
      router = new Router(fsMock)
      router.setup appMock, serverMock, ->
        
        # serverMock.head_called.should.be.true;
        done()
        return

      return

    return

  suite "Authorisation", ->
    test "Valid GET", (done) ->
      fsMock = new Mock([
        name: "readFile"
        callback_args: [
          null
          "{\"/version\":{\"module\":\"dummy\",\"authorisation\":\"SuperAdmin\"}}"
        ]
      ])
      router = new Router(fsMock)
      router.setup appMock, serverMock, ->
        
        # authMock.authorise_called.should.be.true;
        done()
        return

      return

    test "Valid POST", (done) ->
      fsMock = new Mock([
        name: "readFile"
        callback_args: [
          null
          "{\"/version\":{\"module\":\"dummy\",\"authorisation\":\"SuperAdmin\",\"req_method\":\"post\"}}"
        ]
      ])
      router = new Router(fsMock)
      router.setup appMock, serverMock, ->
        
        # authMock.authorise_called.should.be.true;
        done()
        return

      return

    test "Valid HEAD", (done) ->
      fsMock = new Mock([
        name: "readFile"
        callback_args: [
          null
          "{\"/version\":{\"module\":\"dummy\",\"authorisation\":\"SuperAdmin\",\"req_method\":\"head\"}}"
        ]
      ])
      router = new Router(fsMock)
      router.setup appMock, serverMock, ->
        
        # authMock.authorise_called.should.be.true;
        done()
        return

      return

    return

  return
