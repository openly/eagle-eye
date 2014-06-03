var md5 = require('MD5'),
async = require('async');

function Authoriser(userInfo, tokenizer){
    
    var auth        = this,

    destroyTimer    = {};
    
    this.userInfo   = userInfo;
    
    this.tokenizer  = tokenizer;


    this.init = function(app){
        this.app = app;
    }

    this.login = function(user,pass,callback){
        pass = encrypt(pass);
        this.userInfo.login(user, pass, function(success, user, company, contacts){
            if(!success){
                callback(false);
                return;
            }
            auth.tokenizer.createToken(user._id, function(token){
                auth.setDestroyTimer(token);
                
                var theUser             = null,
                    theCompany          = null,
                    theAccountManager   = null,
                    theSDManager        = null;

                if(user){
                    theUser = {
                        first_name  : user.first_name,
                        last_name   : user.last_name,
                        roles       : user.roles,
                        email       : user.email 
                    }
                }
                callback(true, token, theUser, theCompany, theAccountManager, theSDManager);
            })
        })
    }

    this.logout = function(token, callback){
        if (!token) {
            var e = ["Access Token is not valid"];
            callback(e, false);
            return;
        }
        this.tokenizer.deleteToken(token, function(tokenDeleted){
            console.log(token + ':' + tokenDeleted);
            if(!tokenDeleted){
                var e = [];
                if(!tokenDeleted) {
                    e.push("Could not delete access token")
                }
                callback(e, false);
                return;
            }
            callback(null, true);
        });
    }

    this.authorise = function(role, req, res, callback){
        auth.tokenizer.isAuthorised(role, req.query.access_token, function(authorised){
            if(authorised){
                auth.setDestroyTimer(req.query.access_token);

                callback(true, null);
            }
            else{
                callback(false, {errors:["Not authorised"],status:'403'});
            }
        })
    }

    this.setDestroyTimer = function(token){
        if(auth.app.get('TOKEN_TIMEOUT') || auth.app.get('TOKEN_TIMEOUT') > 0){
            var timeOut = 1000 * auth.app.get('TOKEN_TIMEOUT');
            clearTimeout(destroyTimer[token]);
            destroyTimer[token] = setTimeout(function() {
                auth.logout(token, function(){});
            }, timeOut)
        }else {
            throw new Error('Token Time Out is Not defined'); 
        }
    }

    this.getUserRole = function(token, callback){
        auth.tokenizer.getUid(token, function(uid){
            if(!uid){
                callback(false);
                return;
            }   
            auth.userInfo.getUserRole(uid, function(role){
                if(role){
                    callback(role);
                }else{
                    callback(false);
                }
            })  
        })
    }

    this.getUserDetails = function(token, callback){
        auth.tokenizer.getUid(token, function(uid){
            if(!uid){
                callback(false);
                return;
            }
            auth.userInfo.getDetails(uid, function(err, userDetails){
                if(userDetails){
                    callback(userDetails);
                }else{
                    callback(null);
                }
            })  
        })
    }

    function encrypt(string){
        return md5(string + auth.app.get('SALT'));
    }
}

module.exports = Authoriser;