fs = require 'fs'

module.exports = loadData: (file) ->
    return JSON.parse(fs.readFileSync(__dirname + "/../data_set/" + file + ".json", "utf8"))

  return