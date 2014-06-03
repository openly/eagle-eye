//     Login Router
//     
//     @package    ServiceApp Router
//     @module     Login Router
//     @author     Abhilash Hebbar
//     @author     Chethan K
function LoginRoute(app, routeParams){
	
	//  *** `public` login : *** function to route to login action
	this.login = function(req, callback){
		app.auth.login(req.params.username, req.params.password, function(success, token, user, company, accountManager, sdManager){
			if(success){
				var responseObj = {
					status			:'success',
					token 			: token,
					user 			: user,
				}
				callback(null, responseObj);
			}else{
				callback(null, {status:'failed'});
			}
		})
	}
	
	//  *** `public` logout : *** function to route to logout action
	this.logout = function(req, callback){
		if (req.query.access_token) {
			var token = req.query.access_token;
			app.auth.logout(token, function(e, obj){
				if(e){
					callback(e, {status:'failed', errors: e});
				} else {
					callback(null, {status:'success'});
				}
			});
		} else {
			callback(null, {status:'failed', errors:['Access token not found'] });
		}
	}
}

module.exports = LoginRoute;