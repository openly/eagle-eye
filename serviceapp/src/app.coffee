#     Injects all the dependencies to ServiceApp Container 

# Load required modules.
restify = require("restify")
fs = require("fs-extra")
ServiceApp = require("./app/service_app") # Main app
JSONRouteSetup = require("./lib/router/setup") # Router
JSONPluginSetup = require("./lib/plugins/setup") # Plugin Container
Auth = require("./lib/auth") # Authoriser
APIUserInfo = require("./lib/user_info/db_user_info") # User info
Tokenizer = require("./lib/tokenizer")
baseConfigFile = __dirname + "/conf/conf.json" # Base Config file
pluginConfFile = __dirname + "/conf/plugins.json" # Plugins config
ConfigLoader = require("./config_loader.coffee") # Configuration loader.
siteConfigFile = null
global.EEConstants = require("./constants.coffee")
siteConfigFile = __dirname + "/conf/env/" + process.env.NODE_ENV + ".json"  if process.env.NODE_ENV
theApp = new ServiceApp(new ConfigLoader(baseConfigFile, siteConfigFile, fs), restify)
theApp.router = new JSONRouteSetup(fs)
theApp.plugins = new JSONPluginSetup(pluginConfFile, fs)

#To Do: the App doesn't have the configuration variables until you run the init
userInfo = new APIUserInfo(theApp)
tokenizer = new Tokenizer(theApp, fs, userInfo)
theApp.auth = new Auth(userInfo, tokenizer)

#To Do: By default create super admin
theApp.init ->
  theApp.run()
  return
