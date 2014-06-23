//     Router setup
//     
//     Reads from the routes configuration and intializes restify 
//     to listen to those routes
//     
//     @package    ServiceApp Lib
//     @module     Router Setup
//     @author     Abhilash Hebbar

var _     = require('underscore');
var async = require('async');

function RouteSetup(fs) {

  // ***`private` EventHooks :*** Variable holding all the hooks to events.
  var EventHooks = {
    BeforeRoute : [],
    BeforeAuth  : [],
    AuthSuccess : [],
    AuthFailure : [],
    AfterRoute  : []
  }

  // ***`public` on :*** Hook a handler to the routing event
  this.on = function(eventName,callback){
    var curHooks = EventHooks[eventName];
    if(!_.isArray(curHooks)) throw new Error("Unsupported event (" + eventName + ")");
    curHooks.push(callback);
  }

  // ***`public` setup :*** Read all the configuration files and set up the routes
  this.setup = function (app, restify, callback) {
    var calls = []; // Calls for configuring individual route config files
    //To Do: Get all the files in the ROUTE_CONFIG_FOLDER by default
    _.each(app.get('ROUTE_CONFIG_FILES'), function (file) {
      calls.push(setupRouteForFile(file,app,restify)); // Push the read function to calls
    });
    async.parallel(calls, callback); // Setup the routes parallely. No dep on prev file.
  }

  // ***`private` setupRouteForFile :*** Returns a function that will set up the 
  // route for an individual file
  function setupRouteForFile(file,app,restify){
    return function (callback) {
      fs.readFile(file, function (err, data) { // Read the file
        if (err) { // Report if the file is not present
          throw new Error('Cannot read file.' + file);
        }
        var routeInfo = JSON.parse(data.toString()); // Parse the data from file
        _.each(routeInfo, function (info, route) { // For all the route configurations
          var routerClass = require(app.get('ROUTER_DIR') + info.module); // Load the module
          recursiveRouteSetup(route, info, routerClass, app, restify) // Set up the route recurrsively. (Can include subroutes)
        });
        callback();
      })
    }
  }

  // ***`private` recursiveRouteSetup :*** Setup the routing recurssively. This will set up
  // the route and also all the subroutes present.
  function recursiveRouteSetup(route, routeInfo, routerClass, app, restify) {

    if (!routeInfo.method) {
      routeInfo.method = "index"; // Set index as the default method
    }
    if (routeInfo.module) {
      routerClass = require(app.get('ROUTER_DIR') + routeInfo.module);
    }

    if (routeInfo.req_method == "post") { // Handle post
      restify.post(route, executeRoute(routeInfo, routerClass, app));
    } else if (routeInfo.req_method == "head") { // Handle head. (Have we ever used it.)
      restify.head(route, executeRoute(routeInfo, routerClass, app));
    } else { // Use get as default
      restify.get(route, executeRoute(routeInfo, routerClass, app));
    }

    // Set up the sub routes if present.
    if (routeInfo.subroutes && routeInfo.subroutes instanceof Object)
      _.each(routeInfo.subroutes, function (subRouteInfo, subRoute) {
        recursiveRouteSetup(route + subRoute, subRouteInfo, routerClass, app, restify)
      })
  }

  // ***`private` executeRoute :*** Returns the function that handles the route.
  function executeRoute(routeInfo, routerClass, app) {
    return function (req, res, next) {
      var routerObj = new routerClass(app, routeInfo.params); // Load the router obj

      sendEvent('BeforeRoute', req, routeInfo); // Send the events

      if (!routeInfo.authorisation) { // Authorise not needed.
        routerObj[routeInfo.method](req, function(err,data){
          res.send(data); // Directly execute the route method, and send the data.
          sendEvent('AfterRoute', req, routeInfo, data)
          next()
        });
        return;
      }

      sendEvent('BeforeAuth', req, routeInfo); // Send the BeforeAuth event.

      app.auth.authorise(routeInfo.authorisation, req, res, function (success, failureData) {
        if (success) { // if authorization success
          sendEvent('AuthSuccess', req, routeInfo); // Send auth success event

          routerObj[routeInfo.method](req, function(err,data){ // Execute the route and send data
            res.send(data);
            sendEvent('AfterRoute', req, routeInfo, data); //Send the after route event
            next();
          });
        }else{
          sendEvent('AuthFailure', req, routeInfo, failureData); // Send auth failure event.
          res.send(failureData);
        }
      });
    }
  }

  // ***`private` sendEvent :*** Send the event notification to all the hooks.
  function sendEvent(eventName, req, routeInfo, data){
    var hooks = EventHooks[eventName]; // Get list of hooks
    var eventParams = arguments; // Get the list of parameters.

    var clonedParams = _.map(eventParams,_.clone); // clone them, to avoid conflict

    var calls = [];
    if(_.isArray(hooks)){ // execute each hooks.
      async.applyEach(hooks, clonedParams[1], clonedParams[2], clonedParams[3],function(){})
    }
  }

}

module.exports = RouteSetup;