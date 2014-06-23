#     Validator
#     
#     This module is responsible for all sort of form validations.
#     
#     @package    ServiceApp Plugins
#     @module     Validator
#     @author     Abhilash Hebbar
#     @author     Chathan K
isNotUndefined = (value) ->
  typeof (value) isnt "undefined"

#  *** `private` RuleExec : *** Holds all the validation Rules 

#  *** `private` DefaultErrMessages : *** Holds default messages for every rule failures
ValidatorService = (app) ->
  
  #  *** `private` validateExecutor : *** Executes validation rules
  @validateExecutor = (rules, params) ->
    (callback) ->
      v = new ServiceAppValidator(rules)
      v.validate params, callback
      return

  return

#  *** `private` ServiceAppValidator : *** Parse each and every rules and 
# returns an array of error messages, 
# If any failure in the validation rule 
ServiceAppValidator = (rules) ->
  errors = undefined
  @ruleExec = RuleExec
  @errMsgs = DefaultErrMessages
  @validate = (params, callback) ->
    v = new Validator()
    theValidator = this
    errors = []
    v.error = (msg) ->
      errors.push msg
      return

    _.each rules, (rule, paramName) ->
      errorLength = errors.length # No of errors before this parameter gets validated
      _.each rule, (ruleArgs, ruleName) ->
        return  if errors.length > errorLength # Only one error per paramater.
        errMessage = (if ruleArgs.error_message then ruleArgs.error_message else paramName + " " + theValidator.errMsgs[ruleName])
        vcheck = v.check(params[paramName], errMessage)
        theValidator.ruleExec[ruleName] vcheck, ruleArgs, params[paramName]
        return

      return

    callback (if errors.length < 1 then null else errors)
    return

  @getErrors = ->
    errors

  return
Validator = require("validator").Validator
_ = require("underscore")
RuleExec =
  required: (vcheck) ->
    vcheck.notEmpty()
    return

  length: (vcheck, ruleArgs, origValue) ->
    vcheck.len ruleArgs.min, ruleArgs.max  if isNotUndefined(origValue)
    return

  email: (vcheck, ruleArgs, origValue) ->
    vcheck.isEmail()  if isNotUndefined(origValue)
    return

  url: (vcheck, ruleArgs, origValue) ->
    vcheck.isUrl()  if isNotUndefined(origValue)
    return

  alphanumeric: (vcheck, ruleArgs, origValue) ->
    vcheck.isAlphanumeric()  if isNotUndefined(origValue)
    return

  msServerName: (vcheck, ruleArgs, origValue) ->
    vcheck.regex /^[a-zA-Z][a-zA-Z0-9-]*$/  if isNotUndefined(origValue)
    return

  phone: (vcheck, ruleArgs, origValue) ->
    vcheck.regex /^\d{3}-?\d{3}-?\d{4}$/g  if isNotUndefined(origValue)
    return

  ip: (vcheck, ruleArgs, origValue) ->
    vcheck.regex /^\d\d?\d?\.\d\d?\d?\.\d\d?\d?\.\d\d?\d?$/  if isNotUndefined(origValue)
    return

DefaultErrMessages =
  required: "is required."
  length: "has invalid length."
  email: "should be a valid email."
  url: "should be a valid url."
  alphanumeric: "should be alphanumeric."
  phone: "should be a valid phone number[xxx-xxx-xxxx]."
  msServerName: "should be a valid object name. Allowed characters are A to Z, a to z, 0 to 9 and -"
  ip: "should be a valid IP address[xxx.xxx.xxx.xxx]."

module.exports = ValidatorService