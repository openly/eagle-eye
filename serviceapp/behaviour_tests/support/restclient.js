var restify = require('restify'),
fs = require('fs');



function getPort(){
	var baseConfigFile  = __dirname + '/../../src/conf/conf.json', 
	  	nodeEnv 		= 'local'; // Base Config file

	if(process.env.NODE_ENV){
		nodeEnv = process.env.NODE_ENV ;
	}
	var siteConfigFile  = __dirname + '/../../src/conf/env/'+ nodeEnv +'.json';

	var baseData = fs.readFileSync(baseConfigFile,'utf8')
	  , baseJsonData = JSON.parse(baseData);

	if(nodeEnv){
		var envData = fs.readFileSync(siteConfigFile, 'utf8')
		  , jsonData = JSON.parse(envData);
		if(jsonData.API_PORT) {
			return jsonData.API_PORT
		} else {
			return baseJsonData.API_PORT
		}
	} else {
		return baseJsonData.API_PORT
	}
}

var port = getPort();
module.exports = restify.createJsonClient({
	url: 'http://localhost:' + port 
});