#     Static Content Router
#     
#     @package    ServiceApp Router
#     @module     Static Content Router
#     @author     Abhilash Hebbar
StaticContent = (app) ->
  
  #  *** `private` respond : *** Generic function to create respone object
  respond = (content, sendContent, callback) ->
    responseObj = {}
    responseObj = content  if content and sendContent
    if content
      responseObj.status = "success"
    else
      responseObj.status = "failed"
    callback null, responseObj
    return

  @index = (req, callback) ->
    respond false, false, callback
    return

  
  #  *** `private` getContent : *** Function to get static content : Routing
  @getContent = (req, callback) ->
    app.plugins.static_content.getContent req.params.area, (content) ->
      respond content, true, callback
      return

    return

  
  #  *** `private` deleteContent : *** Function to get static content : Routing
  @deleteContent = (req, callback) ->
    app.plugins.static_content.deleteContent req.params.area, (content) ->
      respond content, false, callback
      return

    return

  
  #  *** `private` getContentByVersion : *** Function to get content by version : Routing
  @getContentByVersion = (req, callback) ->
    app.plugins.static_content.getContentByVersion req.params.area, req.params.version, (content) ->
      respond content, true, callback
      return

    return

  
  #  *** `private` activateContentVersion : *** Function to activate content by version : Routing
  @activateContentVersion = (req, callback) ->
    app.plugins.static_content.activateContentVersion req.params.area, req.params.version, (success) ->
      respond success, false, callback
      return

    return

  
  #  *** `private` saveContent : *** function to save content : Routing
  @saveContent = (req, callback) ->
    unless req.params.content
      responseObj =
        status: "failed"
        errors: ["Content is empty"]

      callback null, responseObj
    else
      app.plugins.static_content.saveContent req.params.area, req.params.content, (success) ->
        respond success, false, callback
        return

    return

  
  #  *** `private` getContentVersions : *** function to get content versions : Routing
  @getContentVersions = (req, callback) ->
    app.plugins.static_content.getContentVersions req.params.area, (contentVersions) ->
      respond contentVersions, true, callback
      return

    return

  return
module.exports = StaticContent