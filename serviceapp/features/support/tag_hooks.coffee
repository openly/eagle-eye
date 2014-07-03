tagHooks = ->
  dataHelper = require './load_data.coffee'

  @Before "@adminLogin", (callback) ->
    data = dataHelper.loadData('login_logout')
    @helper.login(data.superAdmin.username, data.superAdmin.password, callback)

  @After "@adminLogin", (callback) ->
    @helper.logout(callback)

  @Before "@createClient", (callback) ->
    data = dataHelper.loadData('client')
    @helper.post 'client',
      "/clients/create?access_token=#{@helper.getKey('token')}",
      data.create.valid,
      callback

  @After "@createClient", (callback) ->
    clientId = @helper.getKey('clientId')
    @helper.get 'client',
      "/clients/delete/#{clientId}?access_token=#{@helper.getKey('token')}",
      callback

  @Before "@createProject", (callback) ->
    data = dataHelper.loadData('project')
    response = @helper.getKey('client')
    if response.status == 'failure'
      callback.fail('Project creation failed with error:' + response.errors)
    else
      clientId = response.id
      @helper.setKey('clientId', clientId)
      data.create.valid['client_id'] = clientId
      @helper.post 'project',
        "/projects/create?access_token=#{@helper.getKey('token')}",
        data.create.valid,
        callback

  @After "@createProject", (callback) ->
    projectId = @helper.getKey('projectId')
    @helper.get 'project',
      "/projects/delete/#{projectId}?access_token=#{@helper.getKey('token')}",
      callback

  return

module.exports = tagHooks