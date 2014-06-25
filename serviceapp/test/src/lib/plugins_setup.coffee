should = require("should")

testDir =  __dirname + '/../../'
Mock = require (testDir + 'mock')

pluginSetUp = require(testDir + '../src/lib/plugins/setup')

suite "Plugins setup [JSON Based]", ->
  appMock = undefined
  setup ->

    appMock = new Mock([
      name: "get"
      return_value: testDir + "/tmp/plugins/"
    ])
    
    return

  suite "Negative tests", ->
    test "Invalid File", ->

      fsMockInvalid = new Mock([
        name: "readFile"
        callback_args: [
          true
          null
        ]
      ])

      plugin = new pluginSetUp(null, fsMockInvalid)
      (->
        plugin.setup appMock, ->

        return
      ).should.throw "Cannot read file."
      return

    test "Invalid Plugin", ->

      fsMockInvalidPlugin = new Mock([
        name: "readFile"
        callback_args: [
          null
          '{"invalidPlugin":"invalidPlugin"}'
        ]
      ])
      
      plugin = new pluginSetUp(null, fsMockInvalidPlugin)
      (->
        plugin.setup appMock, ->
        return
      ).should.throw "invalidPlugin plugin doesn't exist."
      return

    return

  suite "Plugin Access", ->
    test "Valid based", (done) ->
      fsMockValid = new Mock([
        name: "readFile"
        callback_args: [
          null
          "{\"dummy\":\"dummy\"}"
        ]
      ])
      plugin = new pluginSetUp(null, fsMockValid)
      plugin.setup appMock, ->
        pluginObj = plugin["dummy"]
        pluginObj.dummy()
        pluginObj.dummy_called.should.be.true
        done()
        return

      return

    return

  return
