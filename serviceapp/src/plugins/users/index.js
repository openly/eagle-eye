//    User
//     
//     This Module is mainly responsible for before/after actions,
//     associated with User model and also basic CRUD operations.
//  
//     @package    ServiceApp Plugins
//     @module     User
//     @author     Chethan K

var UserModel = require('./model'),
    md5 = require('MD5'),
    _ = require('underscore');

function User(app){
    //  *** `private` userModel : *** Holds user model object
    var userModel = UserModel(app);

    this.isUserValid = function(username, password, callback){
        userModel.findOne({username:username, password:password }, function(err, userDetails){
            if(err){
                throw new Error('Cannot Find User' + err);
            }
            if(userDetails){
                callback(userDetails);
            }else {
                callback(false);
            }
        });
    }

    this.getUser = function(userID, callback){
        userModel.findById(userID).exec(function(err, userDetails){
            if(err){
                throw new Error('getUser Cannot Find User:' + err);
            }
            if(userDetails){
                callback(userDetails);
            }else {
                callback(false);
            }
        });
    }
}

module.exports = User;