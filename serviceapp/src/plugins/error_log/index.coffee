ErrorLog = (app) ->
  
  #To Do: save the response for error catching in the logs file
  @logApiResponse = (requestType, postParams, url, err, res, obj) ->
    if logglyClient
      statusCode = (if res and res.statusCode and res.statusCode then res.statusCode else null)
      loggingData =
        URL: url
        REQUEST_TYPE: requestType
        POST_PARAMS: postParams
        ERRORS: err
        STATUS_CODE: statusCode
        RESULT: obj

      statusTag = (if statusCode is 200 then "SUCCESS" else "FAILURE")
      tags = [
        "SW"
        environmentTag
        statusTag
      ]
      tags.push "STATUS_CODE_" + statusCode  if statusCode
      logglyClient.log loggingData, tags
    return

  @logJson = (jsonData, tag) ->
    if logglyClient
      logglyClient.log jsonData, [
        tag
        environmentTag
      ]
    return

  @logString = (string, tag) ->
    if logglyClient
      logglyClient.log string, [
        tag
        environmentTag
      ]
    return

  return
module.exports = ErrorLog