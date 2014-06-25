SCModel = require("../src/plugins/db_static_content")
Mock = require("./mock")
mongoose = require("mongoose")
should = require("should")
scModel = undefined

#Clear 'orange_testing' Database before excecuting testcases.
conn = mongoose.createConnection("mongodb://localhost:27017/orange_testing")
mongoose.connection.on "open", ->
  mongoose.connection.db.dropDatabase (err) ->
    throw new Error("Cannot drop DB." + err)  if err
    return

  return


# Create Static content model, Before calling any methods on it.
dbMock =
  Schema: mongoose.Schema
  conn: conn

pluginMock = db: dbMock
appMock = plugins: pluginMock
scModel = new SCModel(appMock)
setup (done) ->
  scModel.saveContent "validGlobalArea", "dummy content", (success) ->
    success.should.be.true
    done()
    return

  return

suiteTeardown (done) ->
  mongoose.connection.close()
  done()
  return

suite "Get Static Content", ->
  test " Valid Area", (done) ->
    scModel.getContent "validGlobalArea", (content) ->
      content.should.not.be.false
      done()
      return

    return

  test "Invalid Area", (done) ->
    scModel.getContent "invalidGlobalArea", (success) ->
      success.should.be.false
      done()
      return

    return

  return

suite "Get Static Content By Version", ->
  test " Valid Version", (done) ->
    scModel.getContentByVersion "validGlobalArea", 1, (content) ->
      content.should.not.be.false
      done()
      return

    return

  test "Invalid Valid Version", (done) ->
    scModel.getContentByVersion "validGlobalArea", 0, (success) ->
      success.should.be.false
      done()
      return

    return

  return

suite "Save Version Of Active Static Content", ->
  test "valid Area", (done) ->
    scModel.activateContentVersion "validGlobalArea", 1, (success) ->
      success.should.be.true
      done()
      return

    return

  test "Invalid Area", (done) ->
    scModel.activateContentVersion "invalidGlobalArea", "saa", (success) ->
      success.should.be.false
      done()
      return

    return

  return

suite "Save Static Content", ->
  test "Valid Area", (done) ->
    scModel.saveContent "validGlobalArea", "dummy content", (success) ->
      success.should.be.true
      done()
      return

    return

  return

suite "Get Static Content Versions", ->
  test "Valid Area", (done) ->
    scModel.getContentVersions "validGlobalArea", (success) ->
      success.should.not.be.false
      done()
      return

    return

  test "Invalid Area", (done) ->
    scModel.getContentVersions "invalidGlobalArea", (success) ->
      success.should.not.be.false
      done()
      return

    return

  return
