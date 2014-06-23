var ProjectModel = require('./model'),
    md5 = require('MD5'),
    _ = require('underscore');

function Project(app){
    projectModel = ProjectModel(app);

    this.checkForDuplicateProjectsWhileCreating = function(params, callback){
        projectModel.findOne({project_handle:params.project_handle }, function(err, projectDetails){
            if(err){
                throw new Error('Cannot Find Project' + err);
            }
            if(projectDetails){
                callback(['Duplicate Project handle.'], params);
            }else {
                callback(null, params);
            }
        });
    }

    this.checkForExistingClients = function(params, callback){
        app.plugins.clients.getModel().findById(params.client_id).exec(function(err, clientDetails){
            if(err){
                throw new Error('Cannot Find Client' + err);
            }
            if(clientDetails){
                callback(null, params);
            }else {
                callback(['Client Id does not exists'], params);
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

module.exports = Project;