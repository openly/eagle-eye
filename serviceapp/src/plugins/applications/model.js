function ApplicationModel(app){
    // *** `private` db :*** local reference to the plugins db  
    var db = app.plugins.db;
    // ***`private` userSchema :*** Schema holder for user.
    var applicationSchema = new db.Schema({
        app_name        : String,
        description     : String,
        plugins_added   : Array,
        project_id      : String,
        notify_email    : Array,
        created_at      : Date,
        updated_at      : Date
    });
    return db.conn.model('applications', applicationSchema);
}

module.exports = ApplicationModel;