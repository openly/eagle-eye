//     Validator
//     
//     This module is responsible for all sort of form validations.
//     
//     @package    ServiceApp Plugins
//     @module     Validator
//     @author     Abhilash Hebbar
//     @author     Chathan K

var Validator = require('validator').Validator,
	_ 		  = require('underscore');

//  *** `private` RuleExec : *** Holds all the validation Rules 
var RuleExec = {
	required:     function(vcheck)            { vcheck.notEmpty()                   			},
	length :      function(vcheck,params)     { vcheck.len(params.min,params.max);  			},
	email:        function(vcheck)            { vcheck.isEmail();                   			},
	url:          function(vcheck)            { vcheck.isUrl();                     			},
	alphanumeric: function(vcheck)	          { vcheck.isAlphanumeric()			    			},
	msServerName: function(vcheck)            { vcheck.regex(/^[a-zA-Z][a-zA-Z0-9-]*$/) 					},
	phone: 		  function(vcheck)	          { vcheck.regex( /^\d{3}-?\d{3}-?\d{4}$/g)			},
	ip: 		  function(vcheck)			  {
		vcheck.regex(/^\d\d?\d?\.\d\d?\d?\.\d\d?\d?\.\d\d?\d?$/);
	}
}

//  *** `private` DefaultErrMessages : *** Holds default messages for every rule failures
var DefaultErrMessages = {
	required:     "is required.",
	length :      "has invalid length.",
	email:        "should be a valid email.",
	url:          "should be a valid url.",
	alphanumeric: "should be alphanumeric.",
	phone: 		  "should be a valid phone number[xxx-xxx-xxxx].",
	msServerName: "should be a valid object name. Allowed characters are A to Z, a to z, 0 to 9 and -",
	ip: 		  "should be a valid IP address[xxx.xxx.xxx.xxx]."
}

function ValidatorService(app){

//  *** `private` validateExecutor : *** Executes validation rules
	this.validateExecutor = function(rules,params){
		return function(callback){
			var v = new ServiceAppValidator(rules);
			v.validate(params,callback);
		}
	}
}

//  *** `private` ServiceAppValidator : *** Parse each and every rules and 
// returns an array of error messages, 
// If any failure in the validation rule 
function ServiceAppValidator(rules){
	var errors;

	this.ruleExec = RuleExec;
	this.errMsgs = DefaultErrMessages;

	this.validate = function(params,callback){
		var v = new Validator(),
			theValidator = this;
		errors =[];
		v.error = function(msg) { errors.push(msg); };
		_.each(rules, function(rule, paramName){
			var errorLength = errors.length; // No of errors before this parameter gets validated
			_.each(rule, function(ruleArgs, ruleName){
				if(errors.length > errorLength) return; // Only one error per paramater.
				var errMessage = ruleArgs.error_message ? 
									ruleArgs.error_message : 
									paramName + ' ' + theValidator.errMsgs[ruleName];
				var vcheck = v.check(params[paramName],errMessage);
				theValidator.ruleExec[ruleName](vcheck,ruleArgs);
			})	
		})
		callback(errors.length < 1?null:errors);
	}
	this.getErrors = function(){ return errors; }
}

module.exports = ValidatorService;