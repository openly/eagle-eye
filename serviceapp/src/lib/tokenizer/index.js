//     Tokenizer 
//     
//     Create/Delete/Validate access token.
//     Actions that requires token to get current user data 
//     also included in this module.
//     
//     @package    ServiceApp Library
//     @module     Tokenizer
//     @author     Abhilash Hebbar
//     @author     Chethan K 

var _   = require('underscore'),
    md5 = require('MD5');

function Tokenizer(app, fs, userInfo){
    //  *** `public` tokenize : *** Tokenizer object
    var tokenize = this;
        
    //  *** `public` app : *** Application Object
    tokenize.app = app;
        
    //  *** `public` userInfo : *** UserInfo Object
    tokenize.userInfo = userInfo;

    //  *** `public` createToken : *** Function to create 'token'
    this.createToken = function(uid, callback){
        var timestamp = new Date().getTime()// Create new file with, 
        , token = md5(uid + timestamp + this.app.get('SALT'))// token name as file name and
        , data  = uid + "|" + timestamp // user id with timestamp as its content.
        ;

        fs.writeFile(this.app.get('TOKEN_DIR') + token, data, function(err){
            if(err){ throw new Error('Cannot create file.'); } 
            callback(token);
        });
    }

    //  *** `public` deleteToken : *** Function to delete 'token'
    this.deleteToken    = function(token, callback){
        if(!fs.existsSync(this.app.get('TOKEN_DIR') + token)){
            callback(false);
        }
        fs.unlink(this.app.get('TOKEN_DIR') + token, function(err){
            if(err){ throw new Error('Cannot delete file.')}
            callback(true); 
        })
    }

    //  *** `public` isAuthorised : *** Function to authorise current user's access to the requested action 
    this.isAuthorised = function(accessableRole, token, callback){
        if(!fs.existsSync(this.app.get('TOKEN_DIR') + token)){
            return callback(false);
        }
        fs.readFile(this.app.get('TOKEN_DIR') + token, function(err,data){
            if(err){ throw new Error('Cannot Read file.' + this.app.get('TOKEN_DIR') + token)}
            var userId = data.toString().split("|");
            userId = userId[0];
            tokenize.userInfo.getUserRole(userId, function(userRole){ // Get roles of the current user
                if(!userRole){ 
                    callback(false);
                    return;
                }

                accessableRole = global.EEConstants.priorityOfUserRoles[accessableRole];
                userRole = global.EEConstants.priorityOfUserRoles[userRole];
                
                var checkAuthorised =  accessableRole <= userRole;
                callback(checkAuthorised);
            });
        });
    }

    //  *** `public` getUid : *** Function to get User Id from 'token'
    this.getUid = function(token, callback){
        if(!fs.existsSync(this.app.get('TOKEN_DIR') + token)){
            return callback(false);
        }
        fs.readFile(this.app.get('TOKEN_DIR') + token, function(err,data){
            if(err){
                 throw new Error('Cannot Read File' + err);
            }
            if(data){
                var arr = data.toString().split("|");
                if(md5(arr[0] + arr[1] + tokenize.app.get('SALT')) == token){
                        callback(arr[0]);
                } else  {
                        callback(false);
                }
            } else {
                callback(false);
            }
        })
    }
}

module.exports = Tokenizer;