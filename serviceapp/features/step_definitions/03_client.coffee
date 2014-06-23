require __dirname + '/utilities.coffee'

clientSD = ->
  supportDir = '../support/'
  @World = require(supportDir + 'world.coffee').World
  
  dataHelper = require supportDir + 'load_data.coffee'
  data = dataHelper.loadData('client')

  @When /^I post request the url '\/clients\/create\?access_token=<validToken>' with the invalid data$/, (params, callback) ->
    @helper.post 'client',
      "/clients/create?access_token=#{@helper.getKey('token')}",
      data.create.invalid,
      callback
    return

  @Then /^I should get the error messages$/, (callback) ->
    response = @helper.getKey('client')
    if (response.hasOwnProperty('errors'))
      callback()
    else
      callback.fail("Expected #{JSON.stringify(response)} to have property errors")
    return

  @When /^I post request the url '\/clients\/create\?access_token=<validToken>' with the valid data$/, (params, callback) ->
    @helper.post 'client',
      "/clients/create?access_token=#{@helper.getKey('token')}",
      data.create.valid,
      callback
    return

  clientId = undefined
  @Then /^I should get the new client ID$/, (callback) ->
    response = @helper.getKey('client')
    if (response.hasOwnProperty('id'))
      clientId = response.id
      callback()
    else
      callback.fail("Expected #{JSON.stringify(response)} to have property id")
    return    

  @When /^I post request the url '\/clients\/create\?access_token=<validToken>' with the already existing client handle$/, (params, callback) ->
    @helper.post 'client',
      "/clients/create?access_token=#{@helper.getKey('token')}",
      data.create.valid,
      callback
    return

  @When /^I request the url '\/clients\?access_token=<validToken>'$/, (callback) ->
    @helper.get 'client',
      "/clients?access_token=#{@helper.getKey('token')}",
      callback
    return

  @Then /^I should get the results and total number of results$/, (callback) ->
    response = @helper.getKey('client')
    if (response.hasOwnProperty('result') && response.hasOwnProperty('total'))
      callback()
    else
      callback.fail("Expected #{JSON.stringify(response)} to have property result and total")
    return

  @When /^I post request the url '\/clients\/update\/<clientId>\?access_token=<validToken>' with the valid data$/, (params, callback) ->
    @helper.post 'client',
      "/clients/update/#{clientId}?access_token=#{@helper.getKey('token')}",
      data.update.valid
      callback
    return

  @Then /^I should get result$/, (callback) ->
    response = @helper.getKey('client')
    if (response.hasOwnProperty('result'))
      callback()
    else
      callback.fail("Expected #{JSON.stringify(response)} to have property results")
    return

  @When /^I request the url '\/clients\/<clientId>\?access_token=<validToken>'$/, (callback) ->
    @helper.get 'client',
      "/clients/#{clientId}?access_token=#{@helper.getKey('token')}",
      callback
    return

  @When /^I request the url '\/clients\/delete\/<clientId>\?access_token=<validToken>'$/, (callback) ->
    @helper.get 'client',
      "/clients/delete/#{clientId}?access_token=#{@helper.getKey('token')}",
      callback
    return

module.exports = clientSD