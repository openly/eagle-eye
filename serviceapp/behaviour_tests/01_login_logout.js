var restClient = require('./support/restclient'),
    should     = require('should'),
    dataPool   = require('./support/dataLoader'),
    accessToken, data;

describe('User Authentication', function(){
    before(function(done){
        dataPool.getDataSet("01_login_logout", function(err, res){
            data = res;
            done();
        })
    })

    it('Should provide me a access token when I request login with valid credentials', function(done){
        restClient.post(
            '/login',
            {username:data.superAdmin.valid.username , password:data.superAdmin.valid.password},
            function(err, req, res, obj){
                if(err){ throw(err) }
                if(obj.errors){ throw new Error('Did not login.') }
                if(!obj.token){ throw new Error('Did not find access token') }
                accessToken = obj.token
                obj.status.should.equal('success');
                done();
                
                //Perform some user action with the token to verify logged in or not..?
                // restClient.get(
                //  '/roles?access_token=' + accessToken,
                //  function(err, req, res, obj){
                //      if(err){ throw(err) }
                //      obj.status.should.equal('success')
                //      done()
                //  }
                // )
            }
        )
    })
    
    it('Should logout',function(done){
        restClient.get(
            '/logout?access_token=' + accessToken,
            function(err, req, res, obj){
                if(err){ throw(err) }
                if(obj.errors){ throw new Error('Did not logout.') }
                obj.status.should.equal('success')
                done();
                
                //Perform some user action with the token to verify logged out or not..?
                // restClient.get(
                //  '/roles?accessToken=' + accessToken,
                //  function(err, req, res, obj){
                //      should.exist(err)
                //      done()
                //  }
                // )
            }
        )
    })

    it('Should give status as failed when login with invalid credentials',function(done){
        restClient.post(
            '/login',
            {username:data.superAdmin.inValid.username, password:data.superAdmin.inValid.password},
            function(err, req, res, obj){
                if(err){ throw(err) }
                should.not.exist(obj.token)
                obj.status.should.equal('failed')
                done()
            }
        )
    })
    
    it('Should give status as success when logout without access token.',function(done){
        restClient.get(
            '/logout',
            function(err, req, res, obj){
                if(err){ throw(err) }
                obj.status.should.equal('failed')
                obj.errors[0].should.equal('Access token not found')
                done()
            }
        )
    })
    
    it('Should throw exception when provide with invalid access token',function(done){
        restClient.get(
            '/logout?access_token=dummy',
            function(err, req, res, obj){
                obj.status.should.equal('failed');
                obj.errors[0].should.equal('Could not delete access token');
                done()
            }
        )
    })
})