var restClient  = require('./restclient'),
    should      = require('should'),
    dataPool    = require('./dataLoader');

module.exports = {

    
    getSuperAdminToken: function(callback){
        dataPool.getDataSet("01_login_logout", function(err, data){
            
            restClient.post(
                '/login',
                {user: data.superAdminUserName.valid[0], pass: data.superAdminPassword.valid[0]},
                function(err, req, res, obj){
                    if(err){ throw(err) };
                    if(!obj.token){ throw new Error('Did not find access token') };
                    obj.status.should.equal('success');
                    this.superAdminToken = obj.token;
                    var res = {
                        token : obj.token
                    }
                    callback(null,res);
                }
            )
        })
    },

    deleteSuperAdminToken : function(superAdminToken, callback){
        restClient.get(
            '/logout?access_token=' + superAdminToken,
            function(err, req, res, obj){
                if(err){ throw(err) }
                if(obj.errors){ throw new Error('Did not logout.') }
                obj.status.should.equal('success')
                callback(null,true);
            }
        )
    }

}