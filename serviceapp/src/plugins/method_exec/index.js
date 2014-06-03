//     Method Execution
//     
//     This module is resposnsible for excecuting given methods in series.
//	   This module is in conjuction with the db_crud module 
//	   to minimize the complexity involved in db_crud.
//     
//     @package    ServiceApp Plugins
//     @module     Method Execution
//     @author     Chethan K
//     @author     Abhilash Hebbar

var _ = require("underscore"),
async = require('async');
function MethodExec(app){

	//  *** `public` seriesExecutor : *** Executes methods in series
	this.seriesExecutor = function(methods, reqParams){
		return function(mainCallback){
			var calls = [];
			var newParams = reqParams;

			_.each(methods, function(method){
				var splitMethod = method.split(/\./),
					plugin = splitMethod.shift(),
					method = splitMethod.shift();

				calls.push(function(callback){
					app.plugins[plugin][method](newParams,function(err,modifiedParams){
						newParams = modifiedParams;
						callback(err);
					});
				})
			});
			if(calls.length < 1){
				mainCallback(null, reqParams);
				return;
			} 
			async.series(calls,function(err){
				reqParams = newParams;
				mainCallback(err, reqParams);
			});
		}
	};

	//  *** `public` parameteriseQuery : *** Function to parameterise query by substituting dynamic values from request parametres
	this.parameteriseQuery = function(query, reqParams){
		var parameterisedQuery = {};
		_.each(query,function(val,key){
			var newVal = substituteReqVar(val,reqParams);
			parameterisedQuery[key] = newVal;
		})
		return parameterisedQuery;
	};

	//  *** `public` parameteriseMessage : *** Function to Parameterise Given message by updating the values from request parameters
	this.parameteriseMessage = function(val, reqParams){
		return substituteReqVar(val,reqParams);
	};

	//  *** `private` substituteReqVar : *** Substitues values from request parameters
	function substituteReqVar(val,reqParams){
	    if(_.isArray(val)){
	      val = _.map(val,function(singleVal){
	        return substituteReqVar(singleVal,reqParams);
	      })
	    } else if(_.isObject(val)){
	      var newVal = {};
	      _.each(val,function(singleVal,key){
	        newVal[key] = substituteReqVar(singleVal,reqParams);
	      })
	      val = newVal;
	    } else{
	      var regex = /\$\{(.*?)\}/;
	      while(regex.test(val)){
	        var prop = regex.exec(val).pop();
	        val = val.replace(regex, reqParams[prop]);
	      }
	    }
	    return val;
  }

}
module.exports = MethodExec;