function UserModel(app){
    // *** `private` db :*** local reference to the plugins db  
    var db = app.plugins.db;
    // ***`private` userSchema :*** Schema holder for user.
	var userSchema = new db.Schema({
		username	: String,
		password	: String,
		first_name	: String,
		last_name	: String,
		email		: String,
		client_id   : String,
		phone_number: String,
		role		: String		
	});
    return db.conn.model('user', userSchema);
}

module.exports = UserModel;