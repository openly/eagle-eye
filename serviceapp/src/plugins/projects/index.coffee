Project = (app) ->
  projectModel = ProjectModel(app)
  @checkForExistingClients = (params, callback) ->
    if params["client_id"]
      app.plugins.clients.getModel().findById(params.client_id).exec (err, clientDetails) ->
        throw new Error("Cannot Find Client" + err)  if err
        if clientDetails
          callback null, params
        else
          callback ["Client Id does not exists"], params
        return

    else
      callback null, params
    return

  @unsetProjHandleOnUpdate = (params, callback) ->
    delete params["project_handle"]  if params["project_handle"]
    callback null, params
    return

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

  return
ProjectModel = require("./model")
md5 = require("MD5")
_ = require("underscore")
module.exports = Project