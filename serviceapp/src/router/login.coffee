#     Login Router
#     
#     @package    ServiceApp Router
#     @module     Login Router
#     @author     Abhilash Hebbar
#     @author     Chethan K
LoginRoute = (app, routeParams) ->
  
  #  *** `public` login : *** function to route to login action
  @login = (req, callback) ->
    app.auth.login req.params.username, req.params.password, (success, token, user, company, accountManager, sdManager) ->
      if success
        responseObj =
          status: global.EEConstants.status.success
          token: token
          user: user

        callback null, responseObj
      else
        callback null,
          status: global.EEConstants.status.failure

      return

    return

  
  #  *** `public` logout : *** function to route to logout action
  @logout = (req, callback) ->
    if req.query.access_token
      token = req.query.access_token
      app.auth.logout token, (e, obj) ->
        if e
          callback null,
            status: global.EEConstants.status.failure
            errors: e

        else
          callback null,
            status: global.EEConstants.status.success

        return

    else
      callback null,
        status: global.EEConstants.status.failure
        errors: ["Access token not found"]

    return

  return
module.exports = LoginRoute