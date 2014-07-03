ClientModel = require("./model")

Client = (app) ->
  clientModel = ClientModel(app)
  @getModel = ->
    clientModel

  @updateCreatedDate = (params, callback) ->
    curDate = new Date()
    params["created_at"] = curDate
    params["updated_at"] = curDate
    callback null, params
    return

  @updateLastUpdatedDate = (params, callback) ->
    params["updated_at"] = new Date()
    callback null, params
    return

  @unsetClientHandleOnUpdate = (params, callback) ->
    delete params["client_handle"]  if params["client_handle"]
    callback null, params
    return

  return

module.exports = Client