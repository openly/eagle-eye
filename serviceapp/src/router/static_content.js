//     Static Content Router
//     
//     @package    ServiceApp Router
//     @module     Static Content Router
//     @author     Abhilash Hebbar

function StaticContent(app){
	
	//  *** `private` respond : *** Generic function to create respone object
	var respond = function(content,sendContent, callback){
		var responseObj = {};

		if(content && sendContent){
			responseObj = content;
		}

		if(content){
			responseObj.status = 'success';
		} else {
			responseObj.status = 'failed';
		}
		callback(null, responseObj)
	}

	this.index = function(req, callback){
		respond(false, false, callback);
	}

	//  *** `private` getContent : *** Function to get static content : Routing
	this.getContent = function(req, callback){
		app.plugins.static_content.getContent(req.params.area,function(content){
			respond(content, true, callback);
		});
	}

	//  *** `private` deleteContent : *** Function to get static content : Routing
	this.deleteContent = function(req, callback){
		app.plugins.static_content.deleteContent(req.params.area,function(content){
			respond(content, false, callback);
		});
	}

	//  *** `private` getContentByVersion : *** Function to get content by version : Routing
	this.getContentByVersion = function(req, callback){
		app.plugins.static_content.getContentByVersion(req.params.area, req.params.version, function(content){
			respond(content, true, callback);
		});
	}

	//  *** `private` activateContentVersion : *** Function to activate content by version : Routing
	this.activateContentVersion = function(req, callback){
		app.plugins.static_content.activateContentVersion(req.params.area, req.params.version, function(success){
			respond(success, false, callback);
		});
	}

	//  *** `private` saveContent : *** function to save content : Routing
	this.saveContent = function(req, callback){
		if(!req.params.content){
			responseObj = {
				status : "failed",
				errors : ["Content is empty"]
			}
			callback(null, responseObj)
		}else {
			app.plugins.static_content.saveContent(req.params.area, req.params.content, function(success){
				respond(success, false, callback);
			});
		}
	}

	//  *** `private` getContentVersions : *** function to get content versions : Routing
	this.getContentVersions = function(req, callback){
		app.plugins.static_content.getContentVersions(req.params.area, function(contentVersions){
			respond(contentVersions, true, callback);
		});
	}
}

module.exports = StaticContent;