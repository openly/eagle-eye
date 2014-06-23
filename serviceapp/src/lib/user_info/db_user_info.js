//     DB User Info
//     
//     Actions associated with current user,
//     1. login
//     2. get roles, 
//     3. get complete details
//    
//     @package    ServiceApp Library
//     @module     DB User Info
//     @author     Abhilash Hebbar
//     @author     Chethan K


var _ = require('underscore');
function DBUserInfo(app){

  //  *** `public` login : *** Function to login user by getting user name and password
  this.login = function(user, pass, callback){
    
    app.plugins.users.isUserValid(user, pass, function(theUser){ //validate user from user model
      var user = null; //User,
      
      if(!theUser){
        callback(false);
        return;
      }
      
      if(theUser.role == 'admin' || theUser.role == 'super_admin') {
        // For Admin and Super Admin,
        callback(true, theUser, null, null); // No company and account manager 
      } else {
        //To Do: for the normal user, get company, project and application names
        callback(true, theUser, null, null); // No company and account manager
      }
    });
  }

  //  *** `public` getRoles : *** Function to get roles, Given User ID 
  this.getUserRole = function(uid, callback){
    app.plugins.users.getUser(uid, function(theUser){
      if(!theUser){
        callback(false);
        return;
      }
      callback(theUser.role);
    });
  }

  //  *** `public` getDetails : *** Function to get user deatails, Given User ID
  this.getDetails = function(uid, callback){
    app.plugins.users.getUser(uid, function(theUser){
      if(!theUser){
        callback(false);
        return;
      }
      delete(theUser.password);
      callback(true, theUser);
    });
  }
}

module.exports = DBUserInfo;