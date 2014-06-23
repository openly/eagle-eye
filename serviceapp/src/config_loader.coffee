#     Configuration Loader
#     
#     This module is responsible for loading configuration files.
# 	   We have two files. 
#	   1. Base config file : Holds configuration details, which is same for all, 
#		  irrespective of whichever the environment that we deploy Service APP
#	   2. Environment specific config file: Holds configuration details, 
#		  which changes across the Environments.
#	   Environment Configarution file overrides the values in Base config file
#     
#     @package    ServiceAPP Config Loader
#     @module     Config Loader
#     @author     Abhilash Hebbar
#     @author     Chethan K
ConfigLoader = (baseConfigFile, envSpecificConfigFile, fs) ->
  
  #  *** `public` loadBaseConfig : *** Function to load base configuration file
  @loadBaseConfig = (serviceApp, callback) ->
    serviceApp.set "BASE_DIR", __dirname
    fs.readFile baseConfigFile, "utf8", (err, data) ->
      throw new Error("Cannot read file.")  if err
      conf = JSON.parse(data)
      _.each conf, (val, key) ->
        serviceApp.set key, substitute(serviceApp, val) # Substitute for any configuration variables
        return

      callback()
      return

    return

  
  #  *** `public` loadEnvSpecificConfigFile : *** Function to load Environment specific file
  @loadEnvSpecificConfigFile = (serviceApp, callback) ->
    unless envSpecificConfigFile?
      callback()
      return
    serviceApp.set "BASE_DIR", __dirname
    fs.readFile envSpecificConfigFile, "utf8", (err, data) ->
      throw new Error("Cannot read file.")  if err
      conf = JSON.parse(data)
      _.each conf, (val, key) ->
        serviceApp.set key, substitute(serviceApp, val) # Substitute for any configuration variables
        return

      callback()
      return

    return

  return
_ = require("underscore")
substitute = require("./lib/substitute")
module.exports = ConfigLoader