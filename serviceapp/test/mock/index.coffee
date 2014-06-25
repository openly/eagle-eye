_ = require("underscore")
module.exports = (functs, properties) ->
  @addFunct = (name, retval, callback_args) ->
    this[name] = ->
      callback = arguments[arguments.length - 1] # Assume last function is the callback
      this[name + "_called"] = true
      return retval  if retval
      callback.apply callback, callback_args  if typeof callback is "function"
      return

    return

  i = 0

  while i < functs.length
    fnDesc = functs[i]
    if _.isString(fnDesc)
      @addFunct fnDesc
    else
      @addFunct fnDesc.name, fnDesc.return_value, fnDesc.callback_args
    i++
  return