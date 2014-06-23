//     Serviceapp Container
//        
//     This module is responsible for initializing the application 
//     and hold everything. This object initializes
//     1. Config Read
//     2. Authentication Setup
//     3. Router Setup
//     4. Plugin Setup
//     5. Restify Server Setup
//         
//     package   ServiceApp 
//     module    ServiceApp Container
//     author    Abhilash Hebbar
//     author    Chethan K
var async   = require('async');
var InternalError = require('restify/lib/errors').InternalError;

function ServiceApp(conf,restify){
    // ***`public` conf: *** Configuration Reader
    this.conf    = conf;

    // ***`public` auth: *** Autentication Object
    this.auth    = null;

    // ***`public` router: *** App Router
    this.router  = null;

    // ***`public` plugins: *** Plugins Container
    this.plugins = null;

    // ***`public` vars: *** A variable to hold all the configuration values.
    this.vars = {};

    // ***`private` restifyServer: *** Reference to the restify server, to listen to the given port.
    var restifyServer,
        // *** `private` app: *** Used when proxy function will be this.
        app = this; 

    // ***`private` configure: *** Function to load the configuration from the config loader object.
    function configure(callback){
        if(app.conf == null) // Failsafe
            throw new Error('Conf not set before initialize.');
        var calls = [
            function(cb){ app.conf.loadBaseConfig(app,cb); },// Setup calls to load the base configuration 
            function(cb){ app.conf.loadEnvSpecificConfigFile(app,cb) } // and then envirnoment specific overrides.
        ]

        async.series(calls,callback);// Execute them in series.
    }

    // ***`private` createServer:*** Function to create and initialize the server.
    function createServer(callback){
        if(restify == null) // Failsafe
            throw new Error('restify must be set before creating the server.');

        restifyServer = restify.createServer();// Create the server

        restifyServer.use(restify.bodyParser());// Add required middleware
        restifyServer.use(restify.queryParser());
        restifyServer.on('uncaughtException', function(req, res, route, err){
            var requestType, routeParams, url, errorMessage, errorDetails
            if(route && route.spec){
                requestType = route.spec.method
                url         = route.spec.path
            }
            if(route){
                routeParams = route.params
            }
            if(err){
                errorMessage = err.message
                errorDetails = err.stack
            }

            console.log(err.stack);
            res.send({status:'failed', errors : [err.message]})
            return (true);
        })
        callback();
    }

    // ***`private` authSetup:*** Function to setup the authenication object.
    function authSetup(callback){
        app.auth.init(app);
        callback();
    }

    // ***`private` routerSetup:*** Function to setup the routes.
    function routerSetup(callback){
        app.router.setup(app,restifyServer,callback);
    }

    // ***`private` pluginsSetup:*** Function to setup and initialize all the plugins.
    function pluginsSetup(callback){
        app.plugins.setup(app,callback);
    }

    // ***`public` set:*** Setter for vaiables
    this.set = function(name,val){ this.vars[name] = val; }

    // ***`public` get:*** Getters for variables
    this.get = function(name){ return this.vars[name]; }

    // ***`public` init:*** Initialize the Application
    this.init = function(callback){
        // Required actions
        var calls = [
            configure, // Configure
            createServer // Create Server
        ];

        // Optional actions
        if(this.auth) calls.push(authSetup); // Auth,
        if(this.router) calls.push(routerSetup);// Router Setup 
        if(this.plugins) calls.push(pluginsSetup);// and Plugins Setup

        async.series(calls,callback);// Call the initializer functions in series
    }

    // ***`public` init:*** Run the application
    this.run = function(){
        restifyServer.listen(this.get('API_PORT'));
        console.log('Listening to http://localhost:' + this.get('API_PORT'))
    }
}

module.exports = ServiceApp;