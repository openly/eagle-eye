#     Substitute
#     
#     Substitute the placeholders in configuration values with previously 
#     Configured values
#
#     @package    ServiceApp Lib
#     @module     Substitute
#     @author     Abhilash Hebbar
_ = require("underscore")
substitue = (app, val) ->
  
  # ***`private` substituted :*** Holder for substituted value
  substituted = val
  if _.isArray(val) # Evaluate all items in array
    substituted = []
    _.each val, (individualVal) ->
      substituted.push substitue(app, individualVal)
      return

  else if _.isObject(val) # Evaluate all items in ojbect
    substituted = {}
    _.each val, (val, key) ->
      substituted[key] = substitue(app, val)
      return

  else if _.isString(val) # Evaluate from string.
    regex = /\$\{(.*?)\}/
    substituted = val
    while regex.test(substituted)
      prop = regex.exec(val).pop()
      substituted = val.replace(regex, app.get(prop))
  substituted

module.exports = substitue