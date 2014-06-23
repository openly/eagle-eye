helper = require './helpers.coffee'
World = (callback) ->
  
  @helper = new helper()

  # tell Cucumber we're finished and to use 'this' as the world instance
  callback() 
  return

exports.World = World