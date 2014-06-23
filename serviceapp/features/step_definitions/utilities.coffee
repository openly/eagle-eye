utilitiesStepDefinitionsWrapper = ->
    @World = require("../support/world.coffee").World # overwrite default World constructor

    @When /^I request the url "(.*)"$/, (url, callback) ->
        @helper.get url, callback

    @When /^I post request the url "(.*)" with the JSON$/, (url, params, callback) ->
        @helper.post url, params, callback

    @Then /^I should get the "(.*)" response with status "(.*)"$/, (respKey, status, callback) -> 
        response = @helper.getKey(respKey)
        if typeof(response.status) != 'undefined' && response.status == status
            callback()
        else 
            callback.fail("Expected the #{JSON.stringify(response)} to have status #{status}")
        return

module.exports = utilitiesStepDefinitionsWrapper