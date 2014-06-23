UserModel = (app) ->
  db = app.plugins.db
  userSchema = new db.Schema(
    username:
      type: "String"
      unique: true
      required: true

    password:
      type: "String"
      required: true

    first_name:
      type: "String"
      required: true

    last_name:
      type: "String"
      required: true

    email:
      type: "String"
      unique: true
      required: true

    client_id: String
    phone_number: String
    role:
      type: "String"
      required: true
      default: "user"

    created_at: Date
    updated_at: Date
  )
  db.conn.model "user", userSchema
module.exports = UserModel