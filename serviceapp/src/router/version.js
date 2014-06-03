function VersionRoute(app){
	this.index = function(req, callback){
		callback(null,{version:app.get('VERSION')});
	}
}

module.exports = VersionRoute;