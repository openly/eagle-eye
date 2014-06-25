
# var ServiceAppValidator	= require('../src/plugins/validator'),
# 	Mock 		= require('./mock'),
# 	should 		= require('should');
# var validatorObj;
# suite("validate Required",function(){
# 	test("Valid Scenario",function(done){
# 		 var rules = {
# 		 	name: {'required' : true}
# 		}
# 		var params = {
# 			name 	: "dummyName",
# 		}

# 		validatorObj = new ServiceAppValidator(rules);
# 		validatorObj.validate(params, function(errors){
# 			errors.should.be.empty;
# 			done();
# 		})
# 	})

# 	test("Invalid Scenario",function(done){
# 		 var rules = {
# 		 	name: {'required' : true}
# 		}
# 		var params = {
# 			name 	: "",
# 		}

# 		validatorObj = new ServiceAppValidator(rules);
# 		validatorObj.validate(params, function(errors){
# 			errors.should.not.be.empty;
# 			done();
# 		})
# 	})

# 	test("Invalid Scenario With No Input Variable",function(done){
# 		 var rules = {
# 		 	name: {'required' : true}
# 		}
# 		var params = {
# 		}

# 		validatorObj = new ServiceAppValidator(rules);
# 		validatorObj.validate(params, function(errors){
# 			errors.should.not.be.empty;
# 			done();
# 		})
# 	})
# })

# suite("validate Length",function(){
# 	test("Valid Scenario",function(done){
# 		var rules = {
# 		 	name: {required: true, length : { min : 10, max :100 }},
# 		}
# 		var params = {
# 			name 	: "dummyNameWithinCharacter10To100",
# 		}

# 		validatorObj = new ServiceAppValidator(rules);
# 		validatorObj.validate(params, function(errors){
# 			errors.should.be.empty;
# 			done();
# 		})
# 	})

# 	test("Invalid Scenario With Length Less Than Minimum",function(done){
# 		 var rules = {
# 		 	name: {required: true, length : { min : 10, max :100 }},
# 		}
# 		var params = {
# 			name 	: "dummyName",
# 		}

# 		validatorObj = new ServiceAppValidator(rules);
# 		validatorObj.validate(params, function(errors){
# 			errors.should.not.be.empty;
# 			done();
# 		})
# 	})

# 	test("Invalid Scenario With Length More Than Maximum",function(done){
# 		 var rules = {
# 		 	name: {required: true, length : { min : 1, max :10 }},
# 		}
# 		var params = {
# 			name 	: "dummyNameWithLengthMoreThanMax",
# 		}

# 		validatorObj = new ServiceAppValidator(rules);
# 		validatorObj.validate(params, function(errors){
# 			errors.should.not.be.empty;
# 			done();
# 		})
# 	})
# })

# suite("validate Email",function(){
# 	test("Valid Scenario",function(done){
# 		 var rules = {
# 			email: {'required' : true, 'email' : true}
# 		}
# 		var params = {
# 			email		: "dummy@email.com"
# 		}

# 		validatorObj = new ServiceAppValidator(rules);
# 		validatorObj.validate(params, function(errors){
# 			errors.should.be.empty;
# 			done();
# 		})
# 	})

# 	test("Invalid Scenario",function(done){
# 		 var rules = {
# 			email: {'required' : true, 'email' : true}
# 		}
# 		var params = {
# 			email		: "dummyInvalidEmail"
# 		}

# 		validatorObj = new ServiceAppValidator(rules);
# 		validatorObj.validate(params, function(errors){
# 			errors.should.not.be.empty;
# 			done();
# 		})
# 	})
# })

# suite("validate URL",function(){
# 	test("Valid Scenario",function(done){
# 		 var rules = {
# 			url: {'required' : true, 'url' : true}
# 		}
# 		var params = {
# 			url		: "www.dummyurl.com"
# 		}

# 		validatorObj = new ServiceAppValidator(rules);
# 		validatorObj.validate(params, function(errors){
# 			errors.should.be.empty;
# 			done();
# 		})
# 	})

# 	test("Invalid Scenario",function(done){
# 		var rules = {
# 			url: {'required' : true, 'url' : true}
# 		}
# 		var params = {
# 			url		: "wwwdummyurlcom"
# 		}

# 		validatorObj = new ServiceAppValidator(rules);
# 		validatorObj.validate(params, function(errors){
# 			errors.should.not.be.empty;
# 			done();
# 		})
# 	})
# })