VersionRoute = (app) ->
  @index = (req, callback) ->
    callback null,
      version: app.get("VERSION")

    return

  return
module.exports = VersionRoute