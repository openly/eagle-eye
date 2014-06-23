tagHooks = ->
  dataHelper = require './load_data.coffee'
  data = dataHelper.loadData('login_logout')

  @Before "@adminLogin", (callback) ->
    @helper.login(data.superAdmin.username, data.superAdmin.password, callback)

  @After "@adminLogin", (callback) ->
    @helper.logout(callback)

  return

module.exports = tagHooks