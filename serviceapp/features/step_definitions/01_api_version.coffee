require __dirname + '/utilities.coffee'

versionSD = ->
  @World = require('../support/world.coffee').World # overwrite default World constructor

  @When /^I request the url '\/'$/, (callback) ->
    @helper.get 'api', '/', callback

  @Then /^I should get the API response with version number$/, (callback) ->
    response = @helper.getKey('api')
    if typeof(response.version) != 'undefined'
      callback()
    else
      callback.fail("Expected the #{JSON.stringify(response)} to have version number")

module.exports = versionSD