var restify = require('restify')

function RestifyCore(app){

  var api = restify.createJsonClient({
		// url: app.get('KELWAY_API').URL
	}), jsonData;
  

  this.get = function(url, callback){
		api.get(url, function(e, req, res, obj) {
      if(res){
        //todo need to remove this comment.
        // app.plugins.error_log.logApiResponse('GET', '', url, e, res, obj)
      } else {
        jsonData = {
          url : url,
          message: 'NULL Response'
        }
        app.plugins.error_log.logJson(jsonData, 'SEVERE');
      }
  	  callback(e, req, res, obj)
  	})
  }
  
  this.post = function(url, data, callback){
    app.plugins.error_log.logString(url, 'REQUEST');
    res = "testResponse";
    api.post(url, data, function(e, req, res, obj) {

      if(res){
        app.plugins.error_log.logApiResponse('POST', data, url, e, res, obj)
      } else if(res == 'testResponse'){
        jsonData = {
          url : url,
          message: 'test response'
        }
        app.plugins.error_log.logJson(jsonData, 'SEVERE');
      } else {
        jsonData = {
          url : url,
          message: 'NULL Response'
        }
        app.plugins.error_log.logJson(jsonData, 'SEVERE');
      }
  	  callback(e, req, res, obj)
  	})
  }

  this.put = function(url, data, callback){
    app.plugins.error_log.logString(url, 'REQUEST');
  	api.put(url, function(e, req, res, obj) {
      if(res){
  		  app.plugins.error_log.logApiResponse('PUT', data, url, e, res, obj)
      } else {
        jsonData = {
          url : url,
          message: 'NULL Response'
        }
        app.plugins.error_log.logJson(jsonData, 'SEVERE');
      }
  	  callback(e, req, res, obj)
  	})
  }

  this.del = function(url, callback){
    app.plugins.error_log.logString(url, 'REQUEST');
  	api.del(url, function( e, req, res, obj) {
      if(res){
  		  app.plugins.error_log.logApiResponse('DELETE', '', url, e, res, obj)
      } else {
        jsonData = {
          url : url,
          message: 'NULL Response'
        }
        app.plugins.error_log.logJson(jsonData, 'SEVERE');
      }
  	  callback(e, req, res, obj)
  	})
  } 
}

module.exports = RestifyCore;