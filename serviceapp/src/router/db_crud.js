//     DB CRUD Route
//     
//     A generic route to handle all the db related operations
//     
//     @package    ServiceApp Route
//     @module     DBCrud
//     @author     Abhilash Hebbar
//     @author     Chetan K

var async = require('async'),
	_     = require('underscore'),
	sanitize = require('validator').sanitize;
// ***DBCRUDRoute :*** Handling the DB related operations
// RouteParams contain the configration needed for operation like, the model,
// query, parameters, fields affected etc. 
function DBCRUDRoute(app,routeParams){
	// ***`public` create :*** Route to handle create operations.
	this.create = function(req, callback){
		// ***model :*** Reference of mongoose model
		var model = app.plugins.db.getModel(routeParams.model),
		// ***reqParams :*** Reference to the request parameters
			reqParams = req.params;
		// ***calls :*** List of all the calls needed in the order of execution.
		// These calls are executed in series to get the result
		var calls = [
			app.plugins.validator.validateExecutor(routeParams.validation, reqParams), // Validate
			app.plugins.method_exec.seriesExecutor(routeParams.before, reqParams), // Execute before methods
			function(callback){ 
				new model(sanitizeReq(reqParams, model)).save(function(err, results){
					if(err){
						if (err.name) {
							err = [err.err]
						}
					}
					callback(err, results)
				}); 
			}, // Create new record
			app.plugins.method_exec.seriesExecutor(routeParams.after, reqParams) // Execute after methods
		];

		async.series(calls, function(err, results){
			if(err && err.length > 0){
				callback(null, {status:'failed', errors:err});
			}else{
				var result = results.pop();
				result = results.pop(); // last but one has the ID
				callback(null, {status:'success','id':result._id});
			}
		})
	}

	// ***`public` update :*** Route to handle update operations.
	this.update = function(req, callback){
		// ***model :*** Reference of mongoose model
		var model = app.plugins.db.getModel(routeParams.model), 
		// ***query :*** query to find which records to update
					query, 
		// ***reqParams :*** Reference to the request parameters
			reqParams = req.params;
			// ***calls :*** List of calls to be executed for the operation.
		var calls = [
			app.plugins.validator.validateExecutor(routeParams.validation,reqParams), // Validate
			app.plugins.method_exec.seriesExecutor(routeParams.before,reqParams), // Execute before methods
			function(callback){ // Replace query placeholders
				query = app.plugins.method_exec.parameteriseQuery(routeParams.query, reqParams);
				callback();
			},
			function(callback){ 
				model.findOneAndUpdate(query, sanitizeReq(reqParams, model), function(err, results){
					if(err){
						if (err.name) {
							err = [err.err]
						}
					}
					callback(err, results)
				}); 
			}, // update the record
			app.plugins.method_exec.seriesExecutor(routeParams.after,reqParams), // Execute after methods
		];
		async.series(calls,function(err,results){
			if(err && err.length > 0){
				callback(null, {status:'failed',errors:err});
			}else{
				callback(null, {status:'success'});
			}
		})
	}

	// ***`public` delete :*** Route to handle delete operations.
	this.delete = function(req, callback){
		
		// ***model :*** Reference of mongoose model
		var model = app.plugins.db.getModel(routeParams.model), query,
		// ***reqParams :*** Reference to the request parameters
			reqParams = req.params;
		// ***calls :*** List of calls to be executed for the operation.
		var calls = [
			app.plugins.method_exec.seriesExecutor(routeParams.before,reqParams), // Execute before methods
			function(callback){
				query = app.plugins.method_exec.parameteriseQuery(routeParams.query, reqParams);
				callback();
			},
			function(callback){ 
				model.remove(query, callback);
			},
			app.plugins.method_exec.seriesExecutor(routeParams.after,reqParams), // Execute before methods 
		];

		async.series(calls,function(err,results){
			if(err && err.length > 0){
				callback(null, {status:'failed',errors:err});
			}else{
				callback(null, {status:'success'});
			}
		})
	}

	// ***`public` read :*** Route to handle read operations.
	this.read = function(req, callback){
		// ***model :*** Reference of mongoose model
		var model = app.plugins.db.getModel(routeParams.model), query, reqParams = req.params;
		// ***mongooseQuery :*** Prepared query for mongoose
		var mongooseQuery;
		// ***calls :*** List of calls to be executed for the operation.
		calls = [
			app.plugins.method_exec.seriesExecutor(routeParams.before,reqParams), // Pre-process
			function(callback){ // Replace query prarmeters
				query = app.plugins.method_exec.parameteriseQuery(routeParams.query, reqParams);
				callback();
			},
			function(callback){ // Get the count, used in pagination
				if(!routeParams.single_record)
					model.find(query).count(callback)
				else
					callback();
			},
			function(callback){ // Get the record
				if(routeParams.single_record)
					mongooseQuery = model.findOne(query);
				else{
					mongooseQuery = model.find(query);

					if(routeParams.sort){ // If sort by cols are entered, use that
						mongooseQuery.sort(routeParams.sort);
					}

					if(reqParams.page && reqParams.items_per_page){ // Pagination
						var page = parseInt( reqParams.page ), // Only integer
							items = parseInt( reqParams.items_per_page );
						
						mongooseQuery.skip((page -1) * items).limit(items); // get current page
					}

					mongooseQuery.exec(callback);
				}
			}
		];
		
		async.series(calls,function(err,results){
			if(err && err.length > 0){
				callback(null, {status:'failed',errors:err});
			}else{
				var dbResults = results.pop(), // Records reference
					count = routeParams.single_record ? 1: results.pop(); // Record count
					responseObj = {status:'success',total:count}, calls = []; // Initialize response object
				if(routeParams.single_record){
					appendResult(responseObj,dbResults,routeParams.fields); // Post-process and send the single record
					calls.push(function(callback){
						afterMethods(responseObj,function(err,newSingleRes){
							newSingleRes.idx = 0;
							responseObj = newSingleRes;
							callback();
						})
					})
				}
				else{ // Post process all the records and send out.
					responseObj.result = [];	
					_.each(dbResults,function(dbRes,i){
						var singleRes = {};
						appendResult(singleRes,dbRes,routeParams.fields);
						singleRes.idx = i;
						calls.push(function(callback){
							afterMethods(singleRes,function(err,newSingleRes){
								singleRes = newSingleRes;
								responseObj.result.push(singleRes);
								callback();
							})
						})
						
					});
				}
				async.parallel(calls,function(){
					if(responseObj.result){
						responseObj.result = _.sortBy(responseObj.result, function(res){ return res.idx; })
					}
					callback(null, responseObj);
				})
			}
		})
	}

	// ***`private` appendResult :*** Append the result to the object, along with the ID.
	function appendResult(obj,res,fields){
		_.each(fields,function(field){
			obj[field] = res[field];
		})
		obj['id'] = res['_id'];
	}

	// ***`private` afterMethods :*** post process the read records
	function afterMethods(reqParams,mainCallback){
		var calls = [];
		var newParams = reqParams;

		_.each(routeParams.after, function(method){
			var splitMethod = method.split(/\./),
				plugin = splitMethod.shift(),
				method = splitMethod.shift();

			calls.push(function(callback){
				app.plugins[plugin][method](newParams,function(err,modifiedParams){
					newParams = modifiedParams;
					callback();
				});
			})
		});
		if(calls.length < 1){
			mainCallback(null,reqParams);
			return;
		} 
		async.parallel(calls,function(){
			mainCallback(null,newParams)
		});
	}

	function sanitizeReq(params, model){
		var paths = model.schema.paths;

		var retval = {};

		_.each(paths,function(path,key){
			if(!_.has(params, key)) return; // Do not validate undefined values
			if(key == '_id' || key == '__v') return; // Do not validate defaults
			switch(path.instance){
				case 'String':
					retval[key] = sanitize( params[key] ).escape();
					break;
				case 'Number': 
				case 'Integer': 
					retval[key] = sanitize( params[key] ).toInt();
					break;
				default: 
					retval[key] = params[key]; // If we add any other data type sanitize that.
			}
			if(_.isNull(params[key])) retval[key] = null; // Some force null values.
		})


		return retval;
	}

}

module.exports = DBCRUDRoute;