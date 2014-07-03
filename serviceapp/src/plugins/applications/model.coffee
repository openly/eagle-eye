ApplicationModel = (app) ->
  
  # *** `private` db :*** local reference to the plugins db  
  db = app.plugins.db
  
  # ***`private` userSchema :*** Schema holder for user.
  applicationSchema = new db.Schema(
    application_name:
      type: "String"
      required: true
    description: String
    application_handle:
      type: "String"
      unique: true
      required: true
    project_id:
      type: "String"
      required: true
    plugins_added: Array
    created_at: Date
    updated_at: Date
  )
  db.conn.model "applications", applicationSchema
module.exports = ApplicationModel