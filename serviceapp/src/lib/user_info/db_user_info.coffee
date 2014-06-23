#     DB User Info
#     
#     Actions associated with current user,
#     1. login
#     2. get roles, 
#     3. get complete details
#    
#     @package    ServiceApp Library
#     @module     DB User Info
#     @author     Abhilash Hebbar
#     @author     Chethan K
DBUserInfo = (app) ->
  
  #  *** `public` login : *** Function to login user by getting user name and password
  @login = (user, pass, callback) ->
    app.plugins.user.isUserValid user, pass, (theUser) -> #validate user from user model
      user = null #User,
      unless theUser
        callback false
        return
      if theUser.role is "admin" or theUser.role is "super_admin"
        
        # For Admin and Super Admin,
        callback true, theUser, null, null # No company and account manager
      else
        
        #To Do: for the normal user, get company, project and application names
        callback true, theUser, null, null # No company and account manager
      return

    return

  
  #  *** `public` getRoles : *** Function to get roles, Given User ID 
  @getUserRole = (uid, callback) ->
    app.plugins.user.getUser uid, (theUser) ->
      unless theUser
        callback false
        return
      callback theUser.role
      return

    return

  
  #  *** `public` getDetails : *** Function to get user deatails, Given User ID
  @getDetails = (uid, callback) ->
    app.plugins.user.getUser uid, (theUser) ->
      unless theUser
        callback false
        return
      delete (theUser.password)

      callback true, theUser
      return

    return

  return
_ = require("underscore")
module.exports = DBUserInfo