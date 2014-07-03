require __dirname + '/utilities.coffee'

applicationSD = ->
  supportDir = '../support/'
  @World = require(supportDir + 'world.coffee').World
  
  dataHelper = require supportDir + 'load_data.coffee'
  data = dataHelper.loadData('application')

  @When /^I post request the url '\/applications\/create\?access_token=<validToken>' with the invalid project data$/, (params, callback) ->
    @helper.post 'application',
      "/applications/create?access_token=#{@helper.getKey('token')}",
      data.create.invalidProject,
      callback
    return

  @When /^I post request the url '\/applications\/create\?access_token=<validToken>' with the invalid data$/, (params, callback) ->
    @helper.post 'application',
      "/applications/create?access_token=#{@helper.getKey('token')}",
      data.create.invalid,
      callback
    return

  @When /^I post request the url '\/applications\/create\?access_token=<validToken>' with the valid data$/, (params, callback) ->
    response = @helper.getKey('project')
    if response.status == 'failure'
      callback.fail('Project creation failed with error:' + response.errors)
    else
      projectId = response.id
      @helper.setKey('projectId', projectId)
      data.create.valid['project_id'] = projectId
      @helper.post 'application',
        "/applications/create?access_token=#{@helper.getKey('token')}",
        data.create.valid,
        callback
    return

  applicationID = undefined
  @Then /^I should get the new application ID$/, (callback) ->
    response = @helper.getKey('application')
    if (response.hasOwnProperty('id'))
      applicationID = response.id
      callback()
    else
      callback.fail("Expected #{JSON.stringify(response)} to have property id")
    return    

  @When /^I post request the url '\/applications\/create\?access_token=<validToken>' with the already existing application handle$/, (params, callback) ->
    @helper.post 'application',
      "/applications/create?access_token=#{@helper.getKey('token')}",
      data.create.valid,
      callback
    return

  @When /^I request the url '\/applications\?access_token=<validToken>'$/, (callback) ->
    @helper.get 'application',
      "/applications?access_token=#{@helper.getKey('token')}",
      callback
    return

  @When /^I post request the url '\/applications\/update\/<applicationID>\?access_token=<validToken>' with the invalid data$/, (params, callback) ->
    @helper.post 'application',
      "/applications/update/#{applicationID}?access_token=#{@helper.getKey('token')}",
      data.update.invalid
      callback
    return

  @When /^I post request the url '\/applications\/update\/<applicationID>\?access_token=<validToken>' with the valid data$/, (params, callback) ->
    response = @helper.getKey('project')
    if response.status == 'failure'
      callback.fail('Client creation failed with error:' + response.errors)
    else
      projectId = response.id
      @helper.setKey('projectId', projectId)
      data.update.valid['project_id'] = projectId

      @helper.post 'application',
        "/applications/update/#{applicationID}?access_token=#{@helper.getKey('token')}",
        data.update.valid
        callback
    return

  @When /^I request the url '\/applications\/<applicationID>\?access_token=<validToken>'$/, (callback) ->
    @helper.get 'application',
      "/applications/#{applicationID}?access_token=#{@helper.getKey('token')}",
      callback
    return

  @When /^I request the url '\/applications\/delete\/<applicationID>\?access_token=<validToken>'$/, (callback) ->
    @helper.get 'application',
      "/applications/delete/#{applicationID}?access_token=#{@helper.getKey('token')}",
      callback
    return

module.exports = applicationSD