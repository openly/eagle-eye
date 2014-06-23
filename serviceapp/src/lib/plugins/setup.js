//     Setup Plugins
//     
//     Set up all the plugins during start of the application.
//	   This Object does the following things
//	   1. Gets the plugin info from 'plugin.json' configuration file.
//	   2. Creates an instance of the plugin and
//	 	  throws error if there is any issue occurred.
//     
//     @package    Service APP
//     @module     ServiceApp Lib
//     @author     Abhilash Hebbar

var _ = require('underscore');

function PluginSetup(file, fs){
	
	//  *** `public` setup : *** Function to set up plugin
	this.setup = function(app,callback){
		var plugins = this;
		fs.readFile(file,function(err,data){
			if(err){ throw new Error('Cannot read file.'); }
			var pluginInfo = JSON.parse(data.toString());
			_.each(pluginInfo,function(module,name){
				console.log('Loading plugin: ' + name);
				var pluginModule;
				try{
					pluginModule = require(app.get('PLUGIN_DIR') + module);
				}catch(e){
					console.log(e)
					throw new Error(module + " plugin doesn't exist.");
				}
				var pluginObj = new pluginModule(app);
				plugins[name] = pluginObj;
			});
			callback();
		});
	}
}

module.exports = PluginSetup;
