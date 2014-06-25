should = require("should")
async = require("async")

testDir =  __dirname + '/../../'
Mock = require (testDir + 'mock')

MethodExec = require(testDir + '../src/plugins/method_exec')

suite "Test seriesExecutor", ->
  test "Valid", (done) ->
    appMock = {}
    MethodMock =
      a: (params, callback) ->
        params.a = "a"
        callback null, params
        return

      b: (params, callback) ->
        params.a = "b"
        callback null, params
        return

      c: (params, callback) ->
        params.a = "c"
        callback null, params
        return

    pluginsMock = mock: MethodMock
    appMock.plugins = pluginsMock
    params = a: "not initialized"
    executor = new MethodExec(appMock).seriesExecutor([
      "mock.a"
      "mock.b"
      "mock.c"
    ], params)
    executor (err, params) ->
      console.log params
      params.a.should.equal "c"
      done()
      return

    return

  test "Invalid", (done) ->
    appMock = {}
    MethodMock =
      a: (params, callback) ->
        params.a = "a"
        callback "error", params
        return

      b: (params, callback) ->
        params.a = "b"
        callback null, params
        return

      c: (params, callback) ->
        params.a = "c"
        callback null, params
        return

    pluginsMock = mock: MethodMock
    appMock.plugins = pluginsMock
    params = a: "not initialized"
    executor = new MethodExec(appMock).seriesExecutor([
      "mock.a"
      "mock.b"
      "mock.c"
    ], params)
    executor (err, params) ->
      err.should.equal "error"
      done()
      return

    return

  test "No methods", (done) ->
    appMock = {}
    MethodMock =
      a: (params, callback) ->
        params.a = "a"
        callback "error", params
        return

      b: (params, callback) ->
        params.a = "b"
        callback null, params
        return

      c: (params, callback) ->
        params.a = "c"
        callback null, params
        return

    pluginsMock = mock: MethodMock
    appMock.plugins = pluginsMock
    params = a: "not initialized"
    executor = new MethodExec(appMock).seriesExecutor([], params)
    executor (err, params) ->
      params.a.should.equal "not initialized"
      done()
      return

    return

  return

suite "Test parameteriseQuery", ->
  test "Query value is expression", (done) ->
    appMock = {}
    mockQuery = id: "${id}"
    mockParams = id: 12123
    calls = [(callback) ->
      query = new MethodExec(appMock).parameteriseQuery(mockQuery, mockParams)
      query.id.should.equal "12123"
      callback()
      return
    ]
    async.series calls, (err, results) ->
      done()
      return

    return

  test "Query value is an array", (done) ->
    appMock = {}
    mockQuery = id: [
      "dummy"
      "dummy2"
    ]
    mockParams = id: 12123
    calls = [(callback) ->
      query = new MethodExec(appMock).parameteriseQuery(mockQuery, mockParams)
      query.id[0].should.equal "dummy"
      callback()
      return
    ]
    async.series calls, (err, results) ->
      done()
      return

    return

  test "Query value is an Object", (done) ->
    appMock = {}
    mockQuery = id:
      key: "dummy"

    mockParams = id: 12123
    calls = [(callback) ->
      query = new MethodExec(appMock).parameteriseQuery(mockQuery, mockParams)
      console.log query
      query.id.key.should.equal "dummy"
      callback()
      return
    ]
    async.series calls, (err, results) ->
      done()
      return

    return

  return
