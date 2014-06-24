require __dirname + '/utilities.coffee'

userSD = ->
  supportDir = '../support/'
  @World = require(supportDir + 'world.coffee').World
  
  dataHelper = require supportDir + 'load_data.coffee'
  data = dataHelper.loadData('user')

  @When /^I post request the url '\/users\/create\?access_token=<validToken>' with the invalid data$/, (params, callback) ->
    @helper.post 'user',
      "/users/create?access_token=#{@helper.getKey('token')}",
      data.create.invalid,
      callback
    return

  @Then /^I should get the error messages$/, (callback) ->
    response = @helper.getKey('user')
    if (response.hasOwnProperty('errors'))
      callback()
    else
      callback.fail("Expected #{JSON.stringify(response)} to have property errors")
    return

  @When /^I post request the url '\/users\/create\?access_token=<validToken>' with the valid data$/, (params, callback) ->
    @helper.post 'user',
      "/users/create?access_token=#{@helper.getKey('token')}",
      data.create.valid,
      callback
    return

  userId = undefined
  @Then /^I should get the new user ID$/, (callback) ->
    response = @helper.getKey('user')
    if (response.hasOwnProperty('id'))
      userId = response.id
      callback()
    else
      callback.fail("Expected #{JSON.stringify(response)} to have property id")
    return    

  @When /^I post request the url '\/users\/create\?access_token=<validToken>' with the already existing user handle$/, (params, callback) ->
    @helper.post 'user',
      "/users/create?access_token=#{@helper.getKey('token')}",
      data.create.valid,
      callback
    return

  @When /^I request the url '\/users\?access_token=<validToken>'$/, (callback) ->
    @helper.get 'user',
      "/users?access_token=#{@helper.getKey('token')}",
      callback
    return

  @Then /^I should get the results and total number of results$/, (callback) ->
    response = @helper.getKey('user')
    if (response.hasOwnProperty('result') && response.hasOwnProperty('total'))
      callback()
    else
      callback.fail("Expected #{JSON.stringify(response)} to have property result and total")
    return

  @When /^I post request the url '\/users\/update\/<userId>\?access_token=<validToken>' with the valid data$/, (params, callback) ->
    @helper.post 'user',
      "/users/update/#{userId}?access_token=#{@helper.getKey('token')}",
      data.update.valid
      callback
    return

  @Then /^I should get result$/, (callback) ->
    response = @helper.getKey('user')
    if (response.hasOwnProperty('result'))
      callback()
    else
      callback.fail("Expected #{JSON.stringify(response)} to have property results")
    return

  @When /^I request the url '\/users\/<userId>\?access_token=<validToken>'$/, (callback) ->
    @helper.get 'user',
      "/users/#{userId}?access_token=#{@helper.getKey('token')}",
      callback
    return

  @When /^I request the url '\/users\/delete\/<userId>\?access_token=<validToken>'$/, (callback) ->
    @helper.get 'user',
      "/users/delete/#{userId}?access_token=#{@helper.getKey('token')}",
      callback
    return

module.exports = userSD