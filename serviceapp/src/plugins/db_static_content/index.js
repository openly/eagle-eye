//     Static Content
//     
//     This Module is responsible for CRUD Operation on
//     Static content model.
//     
//     @package    ServiceApp Plugins
//     @module     Static Content
//     @author     Chethan K

var StaticContentModel = require('./model');

function StaticContent(app){
    //  *** `private` staticContentModel : *** Holds static content model object.
    var staticContentModel = StaticContentModel(app);

    //  *** `public` getContent : *** Function to get content.
    this.getContent = function(areaName,callback){
        
        staticContentModel.findOne({areaName:areaName,active:true}, function(err,staticContent){        
            if(err){
               throw new Error('Cannot find content' + err);
            }

            if(staticContent != null){
                var decodedContent = new Buffer(staticContent.content, 'base64').toString('ascii');
                var staticContentinfo = {
                    content :  decodedContent,
                    version :  staticContent.version
                }
                callback(staticContentinfo);
            }else{
                callback(false);  
            }
        });
    }

     //  *** `public` deleteContnet : *** Function to delete content.
    this.deleteContent = function(areaName,callback){
        
        staticContentModel.remove({areaName:areaName}, function(err, data){        
            if(err){
               throw new Error('Cannot delete content' + err);
            }
            callback(true);
        });
    }

    //  *** `public` getContentByVersion : *** Function to get content for a given version
    this.getContentByVersion = function(areaName, version, callback){
        
        staticContentModel.findOne({areaName:areaName, version:version},function(err,staticContent){
            if(err){
                throw new Error('Cannot find content.' + err);
            }
            if(staticContent != null ){
                var decodedContent = new Buffer(staticContent.content, 'base64').toString('ascii');
                var content = {
                    content :  decodedContent,
                    version :  staticContent.version
                }
                callback(content);
            }else{
                callback(false);
            }
        });
    }   

    //  *** `public` name : *** Function activate given version of the content
    this.activateContentVersion = function(areaName, version, callback){
        
        deActivateCurrentVersion(areaName, function(success){
            if(success){
                staticContentModel.findOneAndUpdate({areaName:areaName,version:version},{active:true}, function(err,staticContent){  
                    if(err){
                       throw new Error('Cannot find content.' + err);
                    }
                    if(staticContent != null ){
                        callback(true);
                    }else {
                        callback(false);
                    }
                });
            } else {
                callback(false);
            }
        });
    }

    //  *** `private` getLatestVersion : *** Function to Get the latest content
    function getLatestVersion(areaName, callback){
        
        staticContentModel.findOne({areaName:areaName}).sort('-version').exec(function(err,staticContent){
            if(err){
                throw new Error('Cannot find content.' + err);
            }
            if(staticContent != null){
                callback(staticContent.version);    
            } else {
                callback(false);
            }
        });
    }

    //  *** `private` deActivateCurrentVersion : *** Function to deactivate current version
    function deActivateCurrentVersion(areaName, callback){
        
        staticContentModel.findOneAndUpdate({areaName:areaName,active:true},{active:false}, function(err,staticContent){
            if(err){
                throw new Error('Cannot find content.' + err);
            }
            if(staticContent != null){
                callback(true);
            } else {
                callback(false);
            }
        });
    }
   
    //  *** `public` saveContent : *** Function to save staic content
    this.saveContent = function(areaName,content,callback){

        var SCRIPT_REGEX = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi;
       
            content = content.replace(SCRIPT_REGEX, ""); // Remove javascript from the given content

        var contentEncrypted = new Buffer(content).toString('base64');
        deActivateCurrentVersion(areaName, function(success){
            var currentVersion = 1;
            getLatestVersion(areaName, function(version){
                if(version){
                    currentVersion = version + 1;
                }
                var params = {
                    areaName : areaName,
                    content  : contentEncrypted,
                    version  : currentVersion,
                    active   : true
                }
                staticContentModel(params).save(function(err){
                    if(err){
                        throw new Error('Cannot save content.' + err);
                    }
                    callback(true);
                });
            });
        });
    }

    //  *** `public` getContentVersions : *** Function to get all the content versions
    this.getContentVersions = function(areaName,callback){
        
        staticContentModel.find({areaName:areaName},function(err, contentVersions){
            if(err){
               throw new Error('Cannot find content.' + err);
            }
            if(!contentVersions){
                callback(false);
            }else {
                var contentInfo = []; 
                contentVersions.forEach(function(contentVersion){
                   var decodedContent = new Buffer(contentVersion.content, 'base64').toString('ascii');
                    var content = {
                        content :  decodedContent,
                        version :  contentVersion.version
                    }
                    contentInfo.push(content);
                });
                callback(contentInfo);
            }
        });
    }
}

module.exports = StaticContent;

