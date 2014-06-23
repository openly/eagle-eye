ProjectModel = (app) ->
  
  # *** `private` db :*** local reference to the plugins db  
  db = app.plugins.db
  
  # ***`private` userSchema :*** Schema holder for user.
  projectSchema = new db.Schema(
    project_name:
      type: "String"
      required: true

    description: String
    project_handle:
      type: "String"
      unique: true
      required: true

    client_id:
      type: "String"
      required: true

    notify_email: Array
    users: Array
    created_at: Date
    updated_at: Date
  )
  db.conn.model "projects", projectSchema
module.exports = ProjectModel