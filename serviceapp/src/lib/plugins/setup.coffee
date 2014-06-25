#     Setup Plugins
#     
#     Set up all the plugins during start of the application.
#	   This Object does the following things
#	   1. Gets the plugin info from 'plugin.json' configuration file.
#	   2. Creates an instance of the plugin and
#	 	  throws error if there is any issue occurred.
#     
#     @package    Service APP
#     @module     ServiceApp Lib
#     @author     Abhilash Hebbar
PluginSetup = (file, fs) ->
  
  #  *** `public` setup : *** Function to set up plugin
  @setup = (app, callback) ->
    plugins = this
    fs.readFile file, (err, data) ->
      throw new Error("Cannot read file.")  if err
      pluginInfo = JSON.parse(data.toString())
      _.each pluginInfo, (module, name) ->
        # console.log "Loading plugin: " + name
        pluginModule = undefined
        try
          pluginModule = require(app.get("PLUGIN_DIR") + module)
        catch e
          throw new Error(module + " plugin doesn't exist.")
        pluginObj = new pluginModule(app)
        plugins[name] = pluginObj
        return

      callback()
      return

    return

  return
_ = require("underscore")
module.exports = PluginSetup