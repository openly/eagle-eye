require __dirname + '/utilities.coffee'

loginLogoutSD = ->
  supportDir = '../support/'
  @World = require(supportDir + 'world.coffee').World
  
  dataHelper = require supportDir + 'load_data.coffee'
  data = dataHelper.loadData('login_logout')

  @When /^I post request the url '\/login' with the invalid user$/, (params, callback) ->
    @helper.login 'invalidUser', 'invalidPassword', callback

  @When /^I post request the url '\/login' with the valid user$/, (params, callback) ->
    @helper.login data.superAdmin.username, data.superAdmin.password, callback

  validToken = undefined
  @Then /^I should get the access token$/, (callback) ->
    response = @helper.getKey('login')
    if typeof(response.token) != 'undefined'
      validToken = response.token
      callback()
    else
      callback.fail("Expected #{JSON.stringify(response)} to have property token")

  @When /^I request the url '\/logout' without the token$/, (callback) ->
    @helper.get 'logout', '/logout', callback

  @When /^I request the url '\/logout\?access_token=<invalidToken>' with the invalid token$/, (callback) ->
    url = '/logout?access_token=invalidToken'
    @helper.get 'logout', url, callback

  @When /^I request the url '\/logout\?access_token=<validToken>' with the valid token$/, (callback) ->
    url = '/logout?access_token=' + validToken
    @helper.get 'logout', url, callback

module.exports = loginLogoutSD