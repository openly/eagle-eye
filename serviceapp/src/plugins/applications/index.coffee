ApplicationModel = require("./model")

Application = (app) ->
  applicationModel = ApplicationModel(app)
  
  @getModel = ->
    applicationModel

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

  @unsetApplicationHandleOnUpdate = (params, callback) ->
    delete params["application_handle"]  if params["application_handle"]
    callback null, params
    return

  @checkForExistingProjects = (params, callback) ->
    if params["project_id"]
      console.log app.plugins.projects
      app.plugins.projects.getModel().findById(params.project_id).exec (err, projectDetails) ->
        throw new Error("Cannot Find Project" + err)  if err
        if projectDetails
          callback null, params
        else
          callback ["Project Id does not exists"], params
        return

    else
      callback null, params
    return

  return
  
module.exports = Application