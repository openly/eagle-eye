Authoriser = (userInfo, tokenizer) ->
  encrypt = (string) ->
    md5 string + auth.app.get("SALT")
  auth = this
  destroyTimer = {}
  @userInfo = userInfo
  @tokenizer = tokenizer
  @init = (app) ->
    @app = app
    return

  @login = (user, pass, callback) ->
    pass = encrypt(pass)
    @userInfo.login user, pass, (success, user, company, contacts) ->
      unless success
        callback false
        return
      auth.tokenizer.createToken user._id, (token) ->
        auth.setDestroyTimer token
        theUser = null
        theCompany = null
        theAccountManager = null
        theSDManager = null
        if user
          theUser =
            first_name: user.first_name
            last_name: user.last_name
            roles: user.roles
            email: user.email
        callback true, token, theUser, theCompany, theAccountManager, theSDManager
        return

      return

    return

  @logout = (token, callback) ->
    unless token
      e = ["Access Token is not valid"]
      callback e, false
      return
    @tokenizer.deleteToken token, (tokenDeleted) ->
      unless tokenDeleted
        e = []
        e.push "Could not delete access token"  unless tokenDeleted
        callback e, false
        return
      callback null, true
      return

    return

  @authorise = (role, req, res, callback) ->
    auth.tokenizer.isAuthorised role, req.query.access_token, (authorised) ->
      if authorised
        auth.setDestroyTimer req.query.access_token
        callback true, null
      else
        callback false,
          errors: ["Not authorised"]
          status: "403"

      return

    return

  @setDestroyTimer = (token) ->
    if auth.app.get("TOKEN_TIMEOUT") or auth.app.get("TOKEN_TIMEOUT") > 0
      timeOut = 1000 * auth.app.get("TOKEN_TIMEOUT")
      clearTimeout destroyTimer[token]
      destroyTimer[token] = setTimeout(->
        auth.logout token, ->
        return
      , timeOut)
    else
      throw new Error("Token Time Out is Not defined")
    return

  @getUserRole = (token, callback) ->
    auth.tokenizer.getUid token, (uid) ->
      unless uid
        callback false
        return
      auth.userInfo.getUserRole uid, (role) ->
        if role
          callback role
        else
          callback false
        return

      return

    return

  @getUserDetails = (token, callback) ->
    auth.tokenizer.getUid token, (uid) ->
      unless uid
        callback false
        return
      auth.userInfo.getDetails uid, (err, userDetails) ->
        if userDetails
          callback userDetails
        else
          callback false
        return

      return

    return

  return
md5 = require("MD5")
async = require("async")
module.exports = Authoriser