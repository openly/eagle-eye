function ErrorLog(app){

  //To Do: save the response for error catching in the logs file
  this.logApiResponse = function(requestType, postParams, url, err, res, obj){
  	if(logglyClient){
	  	var statusCode = res && res.statusCode && res.statusCode ? res.statusCode : null,
	  	loggingData = {
	  		URL 		  : url,
	  		REQUEST_TYPE  : requestType,
	  		POST_PARAMS   : postParams,
		    ERRORS		  	: err,
		    STATUS_CODE	  : statusCode,
		    RESULT		  	: obj
			},
	    statusTag = statusCode == 200 ? 'SUCCESS' : 'FAILURE',
			tags = ['SW', environmentTag, statusTag]
			if(statusCode){
				tags.push('STATUS_CODE_' + statusCode)
			}
	  	logglyClient.log(loggingData, tags);
  	}
  }

  this.logJson = function(jsonData, tag){
  	if(logglyClient){
  		logglyClient.log(jsonData, [tag, environmentTag])
  	}
  }

  this.logString = function(string, tag){
  	if(logglyClient) {
  		logglyClient.log(string, [tag, environmentTag])
  	}
  }
}

module.exports = ErrorLog;