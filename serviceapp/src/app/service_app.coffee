#     Serviceapp Container
#        
#     This module is responsible for initializing the application 
#     and hold everything. This object initializes
#     1. Config Read
#     2. Authentication Setup
#     3. Router Setup
#     4. Plugin Setup
#     5. Restify Server Setup
#         
#     package   ServiceApp 
#     module    ServiceApp Container
#     author    Abhilash Hebbar
#     author    Chethan K
ServiceApp = (conf, restify) ->

  # ***`public` conf: *** Configuration Reader
  @conf = conf
  
  # ***`public` auth: *** Autentication Object
  @auth = null
  
  # ***`public` router: *** App Router
  @router = null
  
  # ***`public` plugins: *** Plugins Container
  @plugins = null
  
  # ***`public` vars: *** A variable to hold all the configuration values.
  @vars = {}

  # ***`private` restifyServer: *** Reference to the restify server, to listen to the given port.
  restifyServer = undefined
  
  # *** `private` app: *** Used when proxy function will be this.
  app = this

  # ***`private` configure: *** Function to load the configuration from the config loader object.
  configure = (callback) ->
    # Failsafe
    throw new Error("Conf not set before initialize.")  unless app.conf?
    calls = [
      (cb) -> # Setup calls to load the base configuration
        app.conf.loadBaseConfig app, cb
      (cb) -> # and then envirnoment specific overrides.
        app.conf.loadEnvSpecificConfigFile app, cb
    ]
    async.series calls, callback # Execute them in series.
    return

  handleException = (req, res, route, err) ->
    requestType = undefined
    routeParams = undefined
    url = undefined
    errorMessage = undefined
    errorDetails = undefined
    if route and route.spec
      requestType = route.spec.method
      url = route.spec.path
    routeParams = route.params  if route
    if err
      errorMessage = err.message
      errorDetails = err.stack
      # console.log err.stack
    res.send
      status: global.EEConstants.status.failure
      errors: [errorMessage]
    return true
  
  # ***`private` createServer:*** Function to create and initialize the server.
  createServer = (callback) ->
    # Failsafe
    throw new Error("restify must be set before creating the server.")  unless restify?
    restifyServer = restify.createServer() # Create the server
    restifyServer.use restify.bodyParser() # Add required middleware
    restifyServer.use restify.queryParser()
    restifyServer.on "uncaughtException", handleException

    callback()
    return
  
  # ***`private` authSetup:*** Function to setup the authenication object.
  authSetup = (callback) ->
    app.auth.init app
    callback()
    return
  
  # ***`private` routerSetup:*** Function to setup the routes.
  routerSetup = (callback) ->
    app.router.setup app, restifyServer, callback
    return
  
  # ***`private` pluginsSetup:*** Function to setup and initialize all the plugins.
  pluginsSetup = (callback) ->
    app.plugins.setup app, callback
    return
  
  
  # ***`public` set:*** Setter for vaiables
  @set = (name, val) ->
    @vars[name] = val
    return

  
  # ***`public` get:*** Getters for variables
  @get = (name) ->
    @vars[name]

  
  # ***`public` init:*** Initialize the Application
  @init = (callback) ->
    
    # Required actions
    calls = [
      configure # Configure
      createServer # Create Server
    ]
    
    # Optional actions
    calls.push authSetup  if @auth # Auth,
    calls.push routerSetup  if @router # Router Setup
    calls.push pluginsSetup  if @plugins # and Plugins Setup
    async.series calls, callback # Call the initializer functions in series
    return

  
  # ***`public` init:*** Run the application
  @run = ->
    restifyServer.listen @get("API_PORT")
    console.log "Listening to http://localhost:" + @get("API_PORT")
    return

  return
async = require("async")
InternalError = require("restify/lib/errors").InternalError
module.exports = ServiceApp