
# var should = require('should'),
# 	DBCurd = require('../src/router/db_curd'),
# 	Mock   = require('./mock');

# suite("DB CURD",function() {

# 	var dbCurd, appMock, dbMock, okValidationMock, notOkValidationMock, modelMock;

# 	setup(function(){

# 		modelMock = new Mock([
# 			{name:'save',}
# 		])

# 		notOkValidationMock = new Mock([
# 			{name: 'validate','return_value': false},
# 			{name: 'getErrors','return_value': ['error1','error2']}
# 		]);

# 		okValidationMock = new Mock([
# 			{name: 'validate','return_value': true},
# 			{name: 'getErrors','return_value': []}
# 		])

# 		appMock = new Mock([]);
# 		appMock.plugins = {
# 			db: {
# 				Schema : function(){},
# 				conn   : new Mock([{name: 'model', return_value: false}])
# 			},
# 			validation : new Mock([{name:'get',return_value: notOkValidationMock}])
# 		}
# 	})

# 	suite("General",function(){
# 		test("Invalid Model",function(){
# 			dbCurd = new DBCurd(appMock,{model:'Dummy'});
# 			(function(){
# 				dbCurd.read(null,null,null)
# 			}).throw();
# 		})
# 	})

# 	suite("Create",function(){
# 		test("Validation fail",function(){
# 			appMock.plugins.db.conn = new Mock([
# 				// {name:'model',return_value: }
# 			])
# 		})
# 		test("Valid",function(){

# 		})
# 	})

# 	suite("Update",function(){
# 		test("Validation fail",function(){

# 		})
# 		test("Valid",function(){

# 		})
# 	})

# 	suite("Read",function(){
# 		test("List all",function(){

# 		})
# 		test("Load one",function(){

# 		})
# 	})

# 	suite("Delete",function(){
# 		test("No Record",function(){

# 		})
# 		test("Valid",function(){

# 		})
# 	})
# })