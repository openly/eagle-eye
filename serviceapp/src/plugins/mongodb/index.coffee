#     Mongo DB
#     
#     This module returns mongoose Schema, 
#	   connection object that inturn helps to create model
#		
#     
#     @package    ServiceApp Plugins
#     @module     MongoDB
#     @author     Abhilash Hebbar
DB = (app) ->
  
  #  *** `public` Schema : *** Holds mongoose schema
  @Schema = mongoose.Schema
  
  #  *** `public` conn : *** Returns Connection Object
  @conn = mongoose.createConnection(app.get("DB_URL") + app.get("DB_NAME"))
  
  #  *** `public` getModel : *** returns model for the given schema 
  @getModel = (name) ->
    @conn.model name

  return
mongoose = require("mongoose")
module.exports = DB