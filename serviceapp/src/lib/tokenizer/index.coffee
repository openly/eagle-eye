#     Tokenizer 
#     
#     Create/Delete/Validate access token.
#     Actions that requires token to get current user data 
#     also included in this module.
#     
#     @package    ServiceApp Library
#     @module     Tokenizer
#     @author     Abhilash Hebbar
#     @author     Chethan K 
Tokenizer = (app, fs, userInfo) ->
  
  #  *** `public` tokenize : *** Tokenizer object
  tokenize = this
  
  #  *** `public` app : *** Application Object
  tokenize.app = app
  
  #  *** `public` userInfo : *** UserInfo Object
  tokenize.userInfo = userInfo
  
  #  *** `public` createToken : *** Function to create 'token'
  @createToken = (uid, callback) ->
    timestamp = new Date().getTime() # Create new file with,
    token = md5(uid + timestamp + @app.get("SALT")) # token name as file name and
    data = uid + "|" + timestamp # user id with timestamp as its content.
    fs.outputFile @app.get("TOKEN_DIR") + token, data, (err) ->
      throw new Error("Cannot create file.")  if err
      callback token
      return

    return

  
  #  *** `public` deleteToken : *** Function to delete 'token'
  @deleteToken = (token, callback) ->
    file = @app.get("TOKEN_DIR") + token
    unless fs.existsSync(file)
      callback false
    else
      fs.unlink file, (err) ->
        throw new Error("Cannot Delete Token file:" + file)  if err  if err
        callback true
        return

    return

  
  #  *** `public` isAuthorised : *** Function to authorise current user's access to the requested action 
  @isAuthorised = (accessableRole, token, callback) ->
    file = @app.get("TOKEN_DIR") + token
    unless fs.existsSync(file)
      callback false
    else
      fs.readFile file, (err, data) ->
        throw new Error("Cannot Read file:" + file)  if err
        userId = data.toString().split("|")
        userId = userId[0]
        tokenize.userInfo.getUserRole userId, (userRole) -> # Get roles of the current user
          unless userRole
            callback false
            return
          accessableRole = global.EEConstants.priorityOfUserRoles[accessableRole]
          userRole = global.EEConstants.priorityOfUserRoles[userRole]
          checkAuthorised = accessableRole <= userRole
          callback checkAuthorised
          return

        return

    return

  
  #  *** `public` getUid : *** Function to get User Id from 'token'
  @getUid = (token, callback) ->
    return callback(false)  unless fs.existsSync(@app.get("TOKEN_DIR") + token)
    fs.readFile @app.get("TOKEN_DIR") + token, (err, data) ->
      throw new Error("Cannot Read File" + err)  if err
      if data
        arr = data.toString().split("|")
        if md5(arr[0] + arr[1] + tokenize.app.get("SALT")) is token
          callback arr[0]
        else
          callback false
      else
        callback false
      return

    return

  return
_ = require("underscore")
md5 = require("MD5")
module.exports = Tokenizer