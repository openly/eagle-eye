ApplicationModel = (app) ->
  
  # *** `private` db :*** local reference to the plugins db  
  db = app.plugins.db
  
  # ***`private` userSchema :*** Schema holder for user.
  applicationSchema = new db.Schema(
    app_name: String
    description: String
    plugins_added: Array
    project_id: String
    notify_email: Array
    created_at: Date
    updated_at: Date
  )
  db.conn.model "applications", applicationSchema
module.exports = ApplicationModel