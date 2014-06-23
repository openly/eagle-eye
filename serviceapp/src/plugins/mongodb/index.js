//     Mongo DB
//     
//     This module returns mongoose Schema, 
//	   connection object that inturn helps to create model
//		
//     
//     @package    ServiceApp Plugins
//     @module     MongoDB
//     @author     Abhilash Hebbar

var mongoose	= require('mongoose');

function DB(app){
	//  *** `public` Schema : *** Holds mongoose schema
	this.Schema = mongoose.Schema ;

	//  *** `public` conn : *** Returns Connection Object
	this.conn 	= mongoose.createConnection(app.get('DB_URL') + app.get('DB_NAME'));

	//  *** `public` getModel : *** returns model for the given schema 
	this.getModel = function(name){ return this.conn.model(name); }
}

module.exports = DB;