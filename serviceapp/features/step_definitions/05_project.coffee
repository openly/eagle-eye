require __dirname + '/utilities.coffee'

projectSD = ->
  supportDir = '../support/'
  @World = require(supportDir + 'world.coffee').World
  
  dataHelper = require supportDir + 'load_data.coffee'
  data = dataHelper.loadData('project')

  @When /^I post request the url '\/projects\/create\?access_token=<validToken>' with the invalid client data$/, (params, callback) ->
    @helper.post 'project',
      "/projects/create?access_token=#{@helper.getKey('token')}",
      data.create.invalidClient,
      callback
    return

  @When /^I post request the url '\/projects\/create\?access_token=<validToken>' with the invalid data$/, (params, callback) ->
    @helper.post 'project',
      "/projects/create?access_token=#{@helper.getKey('token')}",
      data.create.invalid,
      callback
    return

  @When /^I post request the url '\/projects\/create\?access_token=<validToken>' with the valid data$/, (params, callback) ->
    response = @helper.getKey('client')
    if response.status == 'failure'
      callback.fail('Client creation failed with error:' + response.errors)
    else
      clientId = response.id
      @helper.setKey('clientId', clientId)
      data.create.valid['client_id'] = clientId
      @helper.post 'project',
        "/projects/create?access_token=#{@helper.getKey('token')}",
        data.create.valid,
        callback
    return

  projectID = undefined
  @Then /^I should get the new project ID$/, (callback) ->
    response = @helper.getKey('project')
    if (response.hasOwnProperty('id'))
      projectID = response.id
      callback()
    else
      callback.fail("Expected #{JSON.stringify(response)} to have property id")
    return    

  @When /^I post request the url '\/projects\/create\?access_token=<validToken>' with the already existing project handle$/, (params, callback) ->
    @helper.post 'project',
      "/projects/create?access_token=#{@helper.getKey('token')}",
      data.create.valid,
      callback
    return

  @When /^I request the url '\/projects\?access_token=<validToken>'$/, (callback) ->
    @helper.get 'project',
      "/projects?access_token=#{@helper.getKey('token')}",
      callback
    return

  @When /^I post request the url '\/projects\/update\/<projectID>\?access_token=<validToken>' with the invalid data$/, (params, callback) ->
    @helper.post 'project',
      "/projects/update/#{projectID}?access_token=#{@helper.getKey('token')}",
      data.update.invalid
      callback
    return

  @When /^I post request the url '\/projects\/update\/<projectID>\?access_token=<validToken>' with the valid data$/, (params, callback) ->
    response = @helper.getKey('client')
    if response.status == 'failure'
      callback.fail('Client creation failed with error:' + response.errors)
    else
      clientId = response.id
      @helper.setKey('clientId', clientId)
      data.update.valid['client_id'] = clientId

      @helper.post 'project',
        "/projects/update/#{projectID}?access_token=#{@helper.getKey('token')}",
        data.update.valid
        callback
    return

  @When /^I request the url '\/projects\/<projectID>\?access_token=<validToken>'$/, (callback) ->
    @helper.get 'project',
      "/projects/#{projectID}?access_token=#{@helper.getKey('token')}",
      callback
    return

  @When /^I request the url '\/projects\/delete\/<projectID>\?access_token=<validToken>'$/, (callback) ->
    @helper.get 'project',
      "/projects/delete/#{projectID}?access_token=#{@helper.getKey('token')}",
      callback
    return

module.exports = projectSD