//         StaticContentModel
//        
//         This is the model describing the schema for Static Content.
// 
//         @package    ServiceApp Plugins
//         @module     StaticContentModel
//         @author     Chetan K

function StaticContentModel(app){
	// *** `private` db :*** local reference to the plugins db   
    var db = app.plugins.db;

    // ***`private` staticContentSchema :*** Schema holder for static content.
	var staticContentSchema = new db.Schema({
		areaName          : String,
		content           : String,
        version           : Number,
        versionComment    : String,
        active            : Boolean
	});

    return db.conn.model('staticContent', staticContentSchema);
}

module.exports = StaticContentModel;


