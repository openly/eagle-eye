//     Substitute
//     
//     Substitute the placeholders in configuration values with previously 
//     Configured values
//
//     @package    ServiceApp Lib
//     @module     Substitute
//     @author     Abhilash Hebbar
var _ = require('underscore');

var substitue = function(app,val){
	// ***`private` substituted :*** Holder for substituted value
	var substituted = val;
	if(_.isArray(val)){ // Evaluate all items in array
		substituted = [];
		_.each(val,function(individualVal){
			substituted.push( substitue(app,individualVal) );
		})
	}
	else if(_.isObject(val)){ // Evaluate all items in ojbect
		substituted = {};
		_.each(val,function(val,key){
			substituted[key] = substitue(app,val);
		})
	}else if(_.isString(val)){ // Evaluate from string.
		var regex = /\$\{(.*?)\}/;
		substituted = val;
		while(regex.test(substituted)){
			var prop = regex.exec(val).pop();
			substituted = val.replace(regex,app.get(prop));
		}
	}
	return substituted;
}

module.exports = substitue;