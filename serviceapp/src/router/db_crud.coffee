#     DB CRUD Route
#     
#     A generic route to handle all the db related operations
#     
#     @package    ServiceApp Route
#     @module     DBCrud
#     @author     Abhilash Hebbar
#     @author     Chetan K

async = require("async")
_ = require("underscore")
sanitize = require("validator").sanitize

# ***DBCRUDRoute :*** Handling the DB related operations
# RouteParams contain the configration needed for operation like, the model,
# query, parameters, fields affected etc. 
DBCRUDRoute = (app, routeParams) ->
  
  # ***`public` create :*** Route to handle create operations.
  
  # ***model :*** Reference of mongoose model
  
  # ***reqParams :*** Reference to the request parameters
  
  # ***calls :*** List of all the calls needed in the order of execution.
  # These calls are executed in series to get the result
  # Validate
  # Execute before methods
  # Create new record
  # Execute after methods
  # last but one has the ID
  
  # ***`public` update :*** Route to handle update operations.
  
  # ***model :*** Reference of mongoose model
  
  # ***query :*** query to find which records to update
  
  # ***reqParams :*** Reference to the request parameters
  
  # ***calls :*** List of calls to be executed for the operation.
  # Validate
  # Execute before methods
  # Replace query placeholders
  # update the record
  # Execute after methods
  
  # ***`public` delete :*** Route to handle delete operations.
  
  # ***model :*** Reference of mongoose model
  
  # ***reqParams :*** Reference to the request parameters
  
  # ***calls :*** List of calls to be executed for the operation.
  # Execute before methods
  # Execute before methods 
  
  # ***`public` read :*** Route to handle read operations.
  
  # ***model :*** Reference of mongoose model
  
  # ***mongooseQuery :*** Prepared query for mongoose
  
  # ***calls :*** List of calls to be executed for the operation.
  # Pre-process
  # Replace query prarmeters
  # Get the count, used in pagination
  # Get the record
  # If sort by cols are entered, use that
  # Pagination
  # Only integer
  # get current page
  # Records reference
  # Record count
  # Initialize response object
  # Post-process and send the single record
  # Post process all the records and send out.
  
  # ***`private` appendResult :*** Append the result to the object, along with the ID.
  appendResult = (obj, res, fields) ->
    _.each fields, (field) ->
      obj[field] = res[field]
      return

    obj["id"] = res["_id"]
    return
  
  # ***`private` afterMethods :*** post process the read records
  afterMethods = (reqParams, mainCallback) ->
    calls = []
    newParams = reqParams
    _.each routeParams.after, (method) ->
      splitMethod = method.split(/\./)
      plugin = splitMethod.shift()
      method = splitMethod.shift()
      calls.push (callback) ->
        app.plugins[plugin][method] newParams, (err, modifiedParams) ->
          newParams = modifiedParams
          callback()
          return

        return

      return

    if calls.length < 1
      mainCallback null, reqParams
      return
    async.parallel calls, ->
      mainCallback null, newParams
      return

    return
  sanitizeReq = (params, model) ->
    paths = model.schema.paths
    retval = {}
    _.each paths, (path, key) ->
      return  unless _.has(params, key) # Do not validate undefined values
      return  if key is "_id" or key is "__v" # Do not validate defaults
      switch path.instance
        when "String"
          retval[key] = sanitize(params[key]).escape()
        when "Number", "Integer"
          retval[key] = sanitize(params[key]).toInt()
        else
          retval[key] = params[key] # If we add any other data type sanitize that.
      retval[key] = null  if _.isNull(params[key]) # Some force null values.
      return

    retval
  @create = (req, callback) ->
    model = app.plugins.db.getModel(routeParams.model)
    reqParams = req.params
    calls = [
      app.plugins.validator.validateExecutor(routeParams.validation, reqParams)
      app.plugins.method_exec.seriesExecutor(routeParams.before, reqParams)
      (callback) ->
        new model(sanitizeReq(reqParams, model)).save (err, results) ->
          err = [err.err]  if err.name  if err
          callback err, results
          return

      app.plugins.method_exec.seriesExecutor(routeParams.after, reqParams)
    ]
    async.series calls, (err, results) ->
      if err
        callback null,
          status: global.EEConstants.status.failure
          errors: err

      else
        result = results.pop()
        result = results.pop()
        callback null,
          status: global.EEConstants.status.success
          id: result._id

      return

    return

  @update = (req, callback) ->
    model = app.plugins.db.getModel(routeParams.model)
    query = undefined
    reqParams = req.params
    calls = [
      app.plugins.validator.validateExecutor(routeParams.validation, reqParams)
      app.plugins.method_exec.seriesExecutor(routeParams.before, reqParams)
      (callback) ->
        query = app.plugins.method_exec.parameteriseQuery(routeParams.query, reqParams)
        callback()
      (callback) ->
        model.findOneAndUpdate query, sanitizeReq(reqParams, model), (err, results) ->
          err = [err.errmsg]  if err.name is "MongoError"  if err
          callback err, results
          return

      app.plugins.method_exec.seriesExecutor(routeParams.after, reqParams)
    ]
    async.series calls, (err, results) ->
      if err
        callback null,
          status: global.EEConstants.status.failure
          errors: err

      else
        callback null,
          status: global.EEConstants.status.success

      return

    return

  @delete = (req, callback) ->
    model = app.plugins.db.getModel(routeParams.model)
    query = undefined
    reqParams = req.params
    calls = [
      app.plugins.method_exec.seriesExecutor(routeParams.before, reqParams)
      (next) ->
        query = app.plugins.method_exec.parameteriseQuery(routeParams.query, reqParams)
        next()
      (next) ->
        model.remove query, (err, results) ->
          if !err and results <= 0
            err = 'No record deleted'
          next(err, results)

      app.plugins.method_exec.seriesExecutor(routeParams.after, reqParams)
    ]
    async.series calls, (err, results) ->

      if err
        callback null,
          status: global.EEConstants.status.failure
          errors: err
      else
        callback null,
          status: global.EEConstants.status.success
      return

    return

  @read = (req, callback) ->
    model = app.plugins.db.getModel(routeParams.model)
    query = undefined
    reqParams = req.params
    mongooseQuery = undefined
    calls = [
      app.plugins.method_exec.seriesExecutor(routeParams.before, reqParams)
      (callback) ->
        query = app.plugins.method_exec.parameteriseQuery(routeParams.query, reqParams)
        callback()
      (callback) ->
        unless routeParams.single_record
          model.find(query).count callback
        else
          callback()
      (callback) ->
        if routeParams.single_record
          mongooseQuery = model.findOne(query)
        else
          mongooseQuery = model.find(query)
          mongooseQuery.sort routeParams.sort  if routeParams.sort
          if reqParams.page and reqParams.items_per_page
            page = parseInt(reqParams.page)
            items = parseInt(reqParams.items_per_page)
            mongooseQuery.skip((page - 1) * items).limit items
          mongooseQuery.exec callback
    ]
    async.series calls, (err, results) ->
      if err
        callback null,
          status: global.EEConstants.status.failure
          errors: err

      else
        dbResults = results.pop()
        count = (if routeParams.single_record then 1 else results.pop())
        responseObj =
          status: global.EEConstants.status.success
          total: count

        calls = []

        if routeParams.single_record
          appendResult responseObj, dbResults, routeParams.fields
          calls.push (callback) ->
            afterMethods responseObj, (err, newSingleRes) ->
              newSingleRes.idx = 0
              responseObj = newSingleRes
              callback()
              return

            return

        else
          responseObj.result = []
          _.each dbResults, (dbRes, i) ->
            singleRes = {}
            appendResult singleRes, dbRes, routeParams.fields
            singleRes.idx = i
            calls.push (callback) ->
              afterMethods singleRes, (err, newSingleRes) ->
                singleRes = newSingleRes
                responseObj.result.push singleRes
                callback()
                return

              return

            return

        async.parallel calls, ->
          if responseObj.result
            responseObj.result = _.sortBy(responseObj.result, (res) ->
              res.idx
            )
          callback null, responseObj
          return

      return

    return

  return

module.exports = DBCRUDRoute