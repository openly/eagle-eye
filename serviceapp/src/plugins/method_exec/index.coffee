#     Method Execution
#     
#     This module is resposnsible for excecuting given methods in series.
#	   This module is in conjuction with the db_crud module 
#	   to minimize the complexity involved in db_crud.
#     
#     @package    ServiceApp Plugins
#     @module     Method Execution
#     @author     Chethan K
#     @author     Abhilash Hebbar
MethodExec = (app) ->
  
  #  *** `public` seriesExecutor : *** Executes methods in series
  
  #  *** `public` parameteriseQuery : *** Function to parameterise query by substituting dynamic values from request parametres
  
  #  *** `public` parameteriseMessage : *** Function to Parameterise Given message by updating the values from request parameters
  
  #  *** `private` substituteReqVar : *** Substitues values from request parameters
  substituteReqVar = (val, reqParams) ->
    if _.isArray(val)
      val = _.map(val, (singleVal) ->
        substituteReqVar singleVal, reqParams
      )
    else if _.isObject(val)
      newVal = {}
      _.each val, (singleVal, key) ->
        newVal[key] = substituteReqVar(singleVal, reqParams)
        return

      val = newVal
    else
      regex = /\$\{(.*?)\}/
      while regex.test(val)
        prop = regex.exec(val).pop()
        val = val.replace(regex, reqParams[prop])
    val
  @seriesExecutor = (methods, reqParams) ->
    (mainCallback) ->
      calls = []
      newParams = reqParams
      _.each methods, (method) ->
        splitMethod = method.split(/\./)
        plugin = splitMethod.shift()
        method = splitMethod.shift()
        calls.push (callback) ->
          app.plugins[plugin][method] newParams, (err, modifiedParams) ->
            newParams = modifiedParams
            callback err
            return

          return

        return

      if calls.length < 1
        mainCallback null, reqParams
        return
      async.series calls, (err) ->
        reqParams = newParams
        mainCallback err, reqParams
        return

      return

  @parameteriseQuery = (query, reqParams) ->
    parameterisedQuery = {}
    _.each query, (val, key) ->
      newVal = substituteReqVar(val, reqParams)
      parameterisedQuery[key] = newVal
      return

    parameterisedQuery

  @parameteriseMessage = (val, reqParams) ->
    substituteReqVar val, reqParams

  return
_ = require("underscore")
async = require("async")
module.exports = MethodExec