#     Static Content
#     
#     This Module is responsible for CRUD Operation on
#     Static content model.
#     
#     @package    ServiceApp Plugins
#     @module     Static Content
#     @author     Chethan K
StaticContent = (app) ->
  
  #  *** `private` staticContentModel : *** Holds static content model object.
  
  #  *** `public` getContent : *** Function to get content.
  
  #  *** `public` deleteContnet : *** Function to delete content.
  
  #  *** `public` getContentByVersion : *** Function to get content for a given version
  
  #  *** `public` name : *** Function activate given version of the content
  
  #  *** `private` getLatestVersion : *** Function to Get the latest content
  getLatestVersion = (areaName, callback) ->
    staticContentModel.findOne(areaName: areaName).sort("-version").exec (err, staticContent) ->
      throw new Error("Cannot find content." + err)  if err
      if staticContent?
        callback staticContent.version
      else
        callback false
      return

    return
  
  #  *** `private` deActivateCurrentVersion : *** Function to deactivate current version
  deActivateCurrentVersion = (areaName, callback) ->
    staticContentModel.findOneAndUpdate
      areaName: areaName
      active: true
    ,
      active: false
    , (err, staticContent) ->
      throw new Error("Cannot find content." + err)  if err
      if staticContent?
        callback true
      else
        callback false
      return

    return
  staticContentModel = StaticContentModel(app)
  @getContent = (areaName, callback) ->
    staticContentModel.findOne
      areaName: areaName
      active: true
    , (err, staticContent) ->
      throw new Error("Cannot find content" + err)  if err
      if staticContent?
        decodedContent = new Buffer(staticContent.content, "base64").toString("ascii")
        staticContentinfo =
          content: decodedContent
          version: staticContent.version

        callback staticContentinfo
      else
        callback false
      return

    return

  @deleteContent = (areaName, callback) ->
    staticContentModel.remove
      areaName: areaName
    , (err, data) ->
      throw new Error("Cannot delete content" + err)  if err
      callback true
      return

    return

  @getContentByVersion = (areaName, version, callback) ->
    staticContentModel.findOne
      areaName: areaName
      version: version
    , (err, staticContent) ->
      throw new Error("Cannot find content." + err)  if err
      if staticContent?
        decodedContent = new Buffer(staticContent.content, "base64").toString("ascii")
        content =
          content: decodedContent
          version: staticContent.version

        callback content
      else
        callback false
      return

    return

  @activateContentVersion = (areaName, version, callback) ->
    deActivateCurrentVersion areaName, (success) ->
      if success
        staticContentModel.findOneAndUpdate
          areaName: areaName
          version: version
        ,
          active: true
        , (err, staticContent) ->
          throw new Error("Cannot find content." + err)  if err
          if staticContent?
            callback true
          else
            callback false
          return

      else
        callback false
      return

    return

  
  #  *** `public` saveContent : *** Function to save staic content
  @saveContent = (areaName, content, callback) ->
    SCRIPT_REGEX = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/g
    content = content.replace(SCRIPT_REGEX, "") # Remove javascript from the given content
    contentEncrypted = new Buffer(content).toString("base64")
    deActivateCurrentVersion areaName, (success) ->
      currentVersion = 1
      getLatestVersion areaName, (version) ->
        currentVersion = version + 1  if version
        params =
          areaName: areaName
          content: contentEncrypted
          version: currentVersion
          active: true

        staticContentModel(params).save (err) ->
          throw new Error("Cannot save content." + err)  if err
          callback true
          return

        return

      return

    return

  
  #  *** `public` getContentVersions : *** Function to get all the content versions
  @getContentVersions = (areaName, callback) ->
    staticContentModel.find
      areaName: areaName
    , (err, contentVersions) ->
      throw new Error("Cannot find content." + err)  if err
      unless contentVersions
        callback false
      else
        contentInfo = []
        contentVersions.forEach (contentVersion) ->
          decodedContent = new Buffer(contentVersion.content, "base64").toString("ascii")
          content =
            content: decodedContent
            version: contentVersion.version

          contentInfo.push content
          return

        callback contentInfo
      return

    return

  return
StaticContentModel = require("./model")
module.exports = StaticContent