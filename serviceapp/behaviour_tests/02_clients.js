var restClient  = require('./support/restclient')
    , prepareData = require('./support/prepare_data')
    , dataPool    = require('./support/dataLoader')
    , should      = require('should')
    , superAdminToken
    , clientID
    , created_at
    , last_updated_at
    , data
    ;

describe('Clients', function(){
    before(function(done){
        dataPool.getDataSet("02_clients", function(err, res){
            data = res;
            prepareData.getSuperAdminToken(function(err,data){
                superAdminToken = data.token;
                done();
            })
        })
        
    })

    after(function(done){
        prepareData.deleteSuperAdminToken(superAdminToken, function(err,data){
            done();
        })
    })

    it("List Clients", function(done){
        restClient.get(
            '/clients?access_token=' + superAdminToken,
            function(err, req, res, obj){
                if(err){ throw(err) }
                obj.status.should.equal('success')
                done()
            }
        )
    })

    it("Create : failed, validation errors", function(done){
        //To Do: delete if already exists
        restClient.post(
            '/clients/create?access_token=' + superAdminToken,
            {},
            function(err, req, res, obj){
                if(err){ throw(err) }
                obj.status.should.equal('failed')
                obj.errors.should.have.lengthOf(2)
                done()
            }
        )
    })

    it("Create : success", function(done){
        created_at = new Date();
        last_updated_at = new Date();
        restClient.post(
            '/clients/create?access_token=' + superAdminToken
             , data.create.valid
             , function(err, req, res, obj){
                if(err){ throw(err) }
                clientID = obj.id
                obj.status.should.equal('success')

                //Cross check Account manager
                restClient.get(
                    '/clients/' + clientID + '?access_token=' + superAdminToken,
                    function(err, req, res, obj){
                        if(err){ throw(err) }
                        obj.status.should.equal('success')
                        var respObj = obj.result[0]                    
                        respObj.client_name.should.equal(data.create.valid.client_name)
                        respObj.description.should.equal(data.create.valid.description)
                        respObj.client_handle.should.equal(data.create.valid.client_handle)
                        // respObj.users.should.equal(data.create.valid.users)
                        new Date(respObj.created_at).should.be.greaterThan(created_at)
                        new Date(respObj.updated_at).should.be.greaterThan(last_updated_at)

                        created_at = respObj.created_at;
                        last_updated_at = respObj.updated_at;
                        done()
                    }
                )
            }
        )
    })

    it("Duplicate Client", function(done){
        restClient.post(
            '/clients/create?access_token=' + superAdminToken
             , data.create.valid
             , function(err, req, res, obj){
                if(err){ throw(err) }
                obj.status.should.equal('failed')
                obj.errors.should.have.lengthOf(1)
                done()
            }
        )
    });
    
    it("Get single client", function(done){
        restClient.get(
            '/clients/' + clientID + '?access_token=' + superAdminToken,
            function(err, req, res, obj){
                if(err){ throw(err) }
                obj.status.should.equal('success')

                var respObj = obj.result.shift()                    
                respObj.client_name.should.equal(data.create.valid.client_name)
                respObj.description.should.equal(data.create.valid.description)
                respObj.client_handle.should.equal(data.create.valid.client_handle)
                //respObj.users.should.equal(data.create.valid.users)
                respObj.created_at.should.be.equal(created_at)
                respObj.updated_at.should.be.equal(last_updated_at)

                done()
            }
        )
    })

    it("update : failed, validation errors", function(done){
        restClient.post(
            '/clients/update/' + clientID + '?access_token=' + superAdminToken,
            { },    
            function(err, req, res, obj){
                if(err){ throw(err) }
                obj.status.should.equal('failed')
                obj.errors.should.have.lengthOf(1)
                done()
            }
        )
    }) 

    it("update : success", function(done){
        restClient.post(
            '/clients/update/' + clientID + '?access_token=' + superAdminToken
            , data.update.valid
            , function(err, req, res, obj){
                if(err){ throw(err) }
                obj.status.should.equal('success')
                
                //Cross check Updated Account manager
                restClient.get(
                    '/clients/' + clientID + '?access_token=' + superAdminToken,
                    function(err, req, res, obj){
                        if(err){ throw(err) }
                        obj.status.should.equal('success')
                        var respObj = obj.result.shift()                    
                        respObj.client_name.should.equal(data.update.valid.client_name)
                        respObj.description.should.equal(data.update.valid.description)
                        respObj.client_handle.should.equal(data.create.valid.client_handle)
                        respObj.client_handle.should.not.equal(data.update.valid.client_handle)
                        //respObj.users.should.equal(data.update.valid.users)
                        respObj.created_at.should.be.equal(created_at)
                        respObj.updated_at.should.be.greaterThan(last_updated_at)

                        done()
                    }
                )
            }
        )
    }) 


    it("delete", function(done){
        restClient.get(
            '/clients/delete/' + clientID + '?access_token=' + superAdminToken,
            function(err, req, res, obj){
                if(err){ throw(err) }
                obj.status.should.equal('success')
                
                // cross check delete
                restClient.get(
                    '/clients/' + clientID + '?access_token=' + superAdminToken,
                    function(err, req, res, obj){
                        if(err){ throw(err) }
                        obj.status.should.equal('success')
                        obj.result.should.be.empty
                        done()
                    }
                )
            }
        )
    })

})