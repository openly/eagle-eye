function ClientModel(app){
    var db = app.plugins.db
    , clientSchema = new db.Schema({
        client_name     : { type: 'String', required: true },
        description     : String,
        client_handle   : { type: 'String', unique:true, required: true },
        users           : Array,
        created_at      : Date,
        updated_at      : Date
    });

    return db.conn.model('clients', clientSchema);
}

module.exports = ClientModel;