var ClientModel = require('./model'),
    md5 = require('MD5'),
    _ = require('underscore');

function Client(app){
    var clientModel = ClientModel(app);

    this.getModel = function() {
        return clientModel;
    }
    this.checkForDuplicateClientsWhileCreating = function(params, callback){
        clientModel.findOne({client_handle:params.client_handle }, function(err, clientDetails){
            if(err){
                throw new Error('Cannot Find Client' + err);
            }
            if(clientDetails){
                callback(['Duplicate Client handle.'], params);
            }else {
                callback(null, params);
            }
        });
    }

    this.updateCreatedDate = function(params, callback){
        var curDate = new Date();
        params['created_at'] = curDate;
        params['updated_at'] = curDate;
        callback(null, params);
    }

    this.updateLastUpdatedDate = function(params, callback){
        params['updated_at'] = new Date();
        callback(null, params);
    }
}

module.exports = Client;

