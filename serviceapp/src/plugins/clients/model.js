function ClientModel(app){
    var db = app.plugins.db
    , clientSchema = new db.Schema({
        client_name     : String,
        description     : String,
        users           : Array,
        created_at      : Date,
        updated_at      : Date
    });

    return db.conn.model('clients', clientSchema);
}

module.exports = ClientModel;