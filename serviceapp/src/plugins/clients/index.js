var ClientModel = require('./model'),
    md5 = require('MD5'),
    _ = require('underscore');

function Client(app){
    var clientModel = ClientModel(app);

    this.getModel = function() {
        return clientModel;
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

    this.unsetClientHandleOnUpdate = function(params, callback){
        if (params['client_handle']) {
            delete params['client_handle'];
        }
        callback(null, params);
    }
}

module.exports = Client;

