RestifyCore = (app) ->
  api = restify.createJsonClient({})
  jsonData = undefined
  
  # url: app.get('KELWAY_API').URL
  @get = (url, callback) ->
    api.get url, (e, req, res, obj) ->
      if res
        
        #todo need to remove this comment.
        app.plugins.error_log.logApiResponse "GET", "", url, e, res, obj
      else
        jsonData =
          url: url
          message: "NULL Response"

        app.plugins.error_log.logJson jsonData, "SEVERE"
      callback e, req, res, obj
      return

    return

  @post = (url, data, callback) ->
    app.plugins.error_log.logString url, "REQUEST"
    res = "testResponse"
    api.post url, data, (e, req, res, obj) ->
      if res
        app.plugins.error_log.logApiResponse "POST", data, url, e, res, obj
      else if res is "testResponse"
        jsonData =
          url: url
          message: "test response"

        app.plugins.error_log.logJson jsonData, "SEVERE"
      else
        jsonData =
          url: url
          message: "NULL Response"

        app.plugins.error_log.logJson jsonData, "SEVERE"
      callback e, req, res, obj
      return

    return

  @put = (url, data, callback) ->
    app.plugins.error_log.logString url, "REQUEST"
    api.put url, (e, req, res, obj) ->
      if res
        app.plugins.error_log.logApiResponse "PUT", data, url, e, res, obj
      else
        jsonData =
          url: url
          message: "NULL Response"

        app.plugins.error_log.logJson jsonData, "SEVERE"
      callback e, req, res, obj
      return

    return

  @del = (url, callback) ->
    app.plugins.error_log.logString url, "REQUEST"
    api.del url, (e, req, res, obj) ->
      if res
        app.plugins.error_log.logApiResponse "DELETE", "", url, e, res, obj
      else
        jsonData =
          url: url
          message: "NULL Response"

        app.plugins.error_log.logJson jsonData, "SEVERE"
      callback e, req, res, obj
      return

    return

  return
restify = require("restify")
module.exports = RestifyCore