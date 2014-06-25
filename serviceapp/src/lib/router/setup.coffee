#     Router setup
#     
#     Reads from the routes configuration and intializes restify 
#     to listen to those routes
#     
#     @package    ServiceApp Lib
#     @module     Router Setup
#     @author     Abhilash Hebbar
RouteSetup = (fs) ->
  
  # ***`private` EventHooks :*** Variable holding all the hooks to events.
  
  # ***`public` on :*** Hook a handler to the routing event
  
  # ***`public` setup :*** Read all the configuration files and set up the routes
  # Calls for configuring individual route config files
  #To Do: Get all the files in the ROUTE_CONFIG_FOLDER by default
  # Push the read function to calls
  # Setup the routes parallely. No dep on prev file.
  
  # ***`private` setupRouteForFile :*** Returns a function that will set up the 
  # route for an individual file
  setupRouteForFile = (file, app, restify) ->
    (callback) ->
      fs.readFile file, (err, data) -> # Read the file
        # Report if the file is not present
        throw new Error("Cannot read file." + file)  if err
        routeInfo = JSON.parse(data.toString()) # Parse the data from file
        _.each routeInfo, (info, route) -> # For all the route configurations
          routerClass = require(app.get("ROUTER_DIR") + info.module) # Load the module
          recursiveRouteSetup route, info, routerClass, app, restify # Set up the route recurrsively. (Can include subroutes)
          return

        callback()
        return

      return
  
  # ***`private` recursiveRouteSetup :*** Setup the routing recurssively. This will set up
  # the route and also all the subroutes present.
  recursiveRouteSetup = (route, routeInfo, routerClass, app, restify) ->
    routeInfo.method = "index"  unless routeInfo.method # Set index as the default method
    routerClass = require(app.get("ROUTER_DIR") + routeInfo.module)  if routeInfo.module
    if routeInfo.req_method is "post" # Handle post
      restify.post route, executeRoute(routeInfo, routerClass, app)
    else if routeInfo.req_method is "head" # Handle head. (Have we ever used it.)
      restify.head route, executeRoute(routeInfo, routerClass, app)
    else # Use get as default
      restify.get route, executeRoute(routeInfo, routerClass, app)
    
    # Set up the sub routes if present.
    if routeInfo.subroutes and routeInfo.subroutes instanceof Object
      _.each routeInfo.subroutes, (subRouteInfo, subRoute) ->
        recursiveRouteSetup route + subRoute, subRouteInfo, routerClass, app, restify
        return

    return
  
  # ***`private` executeRoute :*** Returns the function that handles the route.
  executeRoute = (routeInfo, routerClass, app) ->
    (req, res, next) ->
      routerObj = new routerClass(app, routeInfo.params) # Load the router obj
      sendEvent "BeforeRoute", req, routeInfo # Send the events
      unless routeInfo.authorisation # Authorise not needed.
        routerObj[routeInfo.method] req, (err, data) ->
          res.send data # Directly execute the route method, and send the data.
          sendEvent "AfterRoute", req, routeInfo, data
          next()
          return

        return
      sendEvent "BeforeAuth", req, routeInfo # Send the BeforeAuth event.
      app.auth.authorise routeInfo.authorisation, req, res, (success, failureData) ->
        if success # if authorization success
          sendEvent "AuthSuccess", req, routeInfo # Send auth success event
          routerObj[routeInfo.method] req, (err, data) -> # Execute the route and send data
            res.send data
            sendEvent "AfterRoute", req, routeInfo, data #Send the after route event
            next()
            return

        else
          sendEvent "AuthFailure", req, routeInfo, failureData # Send auth failure event.
          res.send failureData
        return

      return
  
  # ***`private` sendEvent :*** Send the event notification to all the hooks.
  sendEvent = (eventName, req, routeInfo, data) ->
    hooks = EventHooks[eventName] # Get list of hooks
    eventParams = arguments # Get the list of parameters.
    clonedParams = _.map(eventParams, _.clone) # clone them, to avoid conflict
    calls = []
    if _.isArray(hooks) # execute each hooks.
      async.applyEach hooks, clonedParams[1], clonedParams[2], clonedParams[3], ->

    return
  EventHooks =
    BeforeRoute: []
    BeforeAuth: []
    AuthSuccess: []
    AuthFailure: []
    AfterRoute: []

  @on = (eventName, callback) ->
    curHooks = EventHooks[eventName]
    throw new Error("Unsupported event (" + eventName + ")")  unless _.isArray(curHooks)
    curHooks.push callback
    return

  @setup = (app, restify, callback) ->
    calls = []
    _.each app.get("ROUTE_CONFIG_FILES"), (file) ->
      calls.push setupRouteForFile(file, app, restify)
      return

    async.parallel calls, callback
    return

  return
_ = require("underscore")
async = require("async")
module.exports = RouteSetup