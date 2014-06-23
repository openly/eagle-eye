function ProjectModel(app){
    // *** `private` db :*** local reference to the plugins db  
    var db = app.plugins.db;
    // ***`private` userSchema :*** Schema holder for user.
    var projectSchema = new db.Schema({
        project_name    : String,
        description     : String,
        project_handle  : String,
        client_id       : String,
        notify_email    : Array,
        users           : Array,
        created_at      : Date,
        updated_at      : Date
    });
    return db.conn.model('projects', projectSchema);
}

module.exports = ProjectModel;