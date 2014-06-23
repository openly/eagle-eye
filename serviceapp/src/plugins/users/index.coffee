#    User
#     
#     This Module is mainly responsible for before/after actions,
#     associated with User model and also basic CRUD operations.
#  
#     @package    ServiceApp Plugins
#     @module     User
#     @author     Chethan K
User = (app) ->
  
  #  *** `private` userModel : *** Holds user model object
  userModel = UserModel(app)
  @getModel = ->
    userModel

  @updateCreatedDate = (params, callback) ->
    curDate = new Date()
    params["created_at"] = curDate
    params["updated_at"] = curDate
    callback null, params
    return

  @updateLastUpdatedDate = (params, callback) ->
    params["updated_at"] = new Date()
    callback null, params
    return

  @unsetUsernameOnUpdate = (params, callback) ->
    delete params["username"]  if params["username"]
    callback null, params
    return

  @isUserValid = (username, password, callback) ->
    userModel.findOne
      username: username
      password: password
    , (err, userDetails) ->
      throw new Error("Cannot Find User" + err)  if err
      if userDetails
        callback userDetails
      else
        callback false
      return

    return

  @getUser = (userID, callback) ->
    userModel.findById(userID).exec (err, userDetails) ->
      throw new Error("getUser Cannot Find User:" + err)  if err
      if userDetails
        callback userDetails
      else
        callback false
      return

    return

  @validateTwoPasswords = (params, callback) ->
    e = null
    e = ["Please enter same password"]  if typeof (params["password"]) isnt "undefined" and params["password"] isnt params["confirm_password"]
    callback null, params
    return

  @encryptPasswords = (params, callback) ->
    params["password"] = md5(params["password"] + app.get("SALT"))
    callback null, params
    return

  return
UserModel = require("./model")
md5 = require("MD5")
_ = require("underscore")
module.exports = User