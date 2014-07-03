utilitiesStepDefinitionsWrapper = ->
  @World = require("../support/world.coffee").World # overwrite default World constructor

  @When /^I request the url "(.*)"$/, (url, callback) ->
    @helper.get url, callback
    return

  @When /^I post request the url "(.*)" with the JSON$/, (url, params, callback) ->
    @helper.post url, params, callback
    return

  @Then /^I should get the "(.*)" response with status "(.*)"$/, (respKey, status, callback) -> 
    response = @helper.getKey(respKey)
    if typeof(response.status) != 'undefined' && response.status == status
      callback()
    else 
      callback.fail("Expected the #{JSON.stringify(response)} to have status #{status}")
    return

  @Then /^I should get the error messages for "(.*)"$/, (respKey, callback) ->
    response = @helper.getKey(respKey)
    if (response.hasOwnProperty('errors'))
      callback()
    else
      callback.fail("Expected #{JSON.stringify(response)} to have property errors")
    return

  @Then /^I should get the "(.*)"s and total number of "(.*)"$/, (respKey, param, callback) ->
    response = @helper.getKey(respKey)
    if(typeof(response) != 'undefined' and 
      response.hasOwnProperty('result') and
      response.hasOwnProperty('total')
    )
      callback()
    else
      callback.fail("Expected #{JSON.stringify(response)} to have property result and total")
    return

  @Then /^I should get the "(.*)" as result$/, (respKey, callback) ->
    response = @helper.getKey(respKey)
    if typeof(response) != 'undefined' and response.hasOwnProperty('result')
      callback()
    else
      callback.fail("Expected #{JSON.stringify(response)} to have property result and total")

module.exports = utilitiesStepDefinitionsWrapper