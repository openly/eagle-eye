restify = require 'restify'

helperFn = () ->
  #================== Rest Client==========================
  #To Do: Set this based on different environment
  @url = 'http://localhost:4444'

  @restClient = restify.createJsonClient({
    url: @url
  });

  @get = (resKey, url, callback) ->
    @setKey(resKey, undefined)
    @restClient.get url, (err, req, res, obj) =>
      throw (err)  if err
      @setKey(resKey, obj)
      callback()
      return
    return

  @post = (resKey, url, params, callback) ->
    @setKey(resKey, undefined)
    params = JSON.parse(params) if typeof(params) != 'object'
    @restClient.post url, params, (err, req, res, obj) =>
      throw (err)  if err
      @setKey(resKey, obj)
      callback()
      return
    return

  #================== Key Value Pairs==========================
  @keyValPairs = {}
  @setKey = (key, val) ->
    @keyValPairs[key] = val
    return

  @getKey = (key) ->
    if @keyValPairs.hasOwnProperty(key)
      return @keyValPairs[key]
    else
      return undefined

  #================== Login Logout=============================
  @login = (username, password, callback) ->
    @post 'login',
      '/login',
      username: username
      password: password,
      () =>
        @setKey('token', @getKey('login').token)
        callback()

  @logout = (callback) ->
    @get 'logout', 
      "/logout?access_token=#{@getKey('token')}",
      ()=>
        @setKey('login', undefined)
        callback()

  return

module.exports = helperFn