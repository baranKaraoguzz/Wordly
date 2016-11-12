//
//  SettingService.swift
//  Wordly
//
//  Created by eposta developer on 02/08/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation


//ESTABLISHES RELATIONSHIP  THE CONTROLLER BETWEEN THE POSTCONNECTION
class SettingService : ConnectionDelegate {
 
    
      //# MARK: - Send To PostConnection
    //FETCH DATA FROM CONROLLER IN ORDER TO SEND THE POSTCONNECTION
    /*
     "id":"156151616-12",
     "userType":"mail/twitter/facebook",
     "newMail":"abc@gmail.com",
     "dbVersion":"1",
     "versionCode":"1
     */
    func dispatchChangeEmail(model : ChangeEmailSend){
        var params = [String : String]()
        params[GlobalData.id.rawValue] = model.id
        params[GlobalData.userType.rawValue] = model.userType
        params[GlobalData.newMail.rawValue] = model.newMail
        params[GlobalData.dbVersion.rawValue] = model.dbVersion
        params[GlobalData.versionCode.rawValue] = model.versionCode
        connection.makePostConnection(params, subDomain: HttpLink.CHANGE_MAIL_LINK)
    
    }
    
    func dispatchChangeNotifyFrequencyData(model : ChangeNotifyFrequencySend ){
        
        /*
         {
         "id":"1001",
         "userType":"mail/twitter/facebook",
         "count":"12"
         }
        
         */
         // 2 DISPATCH PARAMATERS TO THE CONNECTION
        var params = [String: String]()
        params[GlobalData.id.rawValue] = model.id
        params[GlobalData.count.rawValue] = model.count
        params[GlobalData.userType.rawValue] = model.userType
        connection.makePostConnection(params, subDomain: HttpLink.CHANGE_FREQUENCY_LINK)
    }
    
    
    func dispatchChangeLevelNotification(model : ChangeLevelSend){
    /*
         {
         "id":"1001",
         "userType":"mail/twitter/facebook",
         "newLevel":"intermediate",
         "dbVersion":"1",
         "versionCode":"1"   (0 dikkate alma , kritik değerin altı ise güncellemeye zorla)
         
         }
         
         */
        var params = [String : String]()
        params[GlobalData.id.rawValue] = model.id
        params[GlobalData.userType.rawValue] = model.userType
        params[GlobalData.newLevel.rawValue] = model.newLevel
        params[GlobalData.dbVersion.rawValue] = model.dbVersion
        params[GlobalData.versionCode.rawValue] = model.versionCode
        connection.makePostConnection(params, subDomain: HttpLink.CHANGE_LEVEL_LINK)
    }
    
    func dispatchChangeMailNotification(model : ChangeMailNotifySend) {
        /*
            "id":"1001",
            "userType":"mail/twitter/facebook",
            "isOpen":"true/false",
            "dbVersion":"1"
            
        */

        var params = [String : String]()
        params[GlobalData.id.rawValue] = model.id
        params[GlobalData.isOpen.rawValue] = model.isOpen
        params[GlobalData.userType.rawValue] = model.userType
        params[GlobalData.dbVersion.rawValue] = model.dbVersion
        connection.makePostConnection(params, subDomain: HttpLink.CHANGE_MAIL_NOTIFICATION_LINK)
    }
    
    func dispatchChangeMobileNotification(model : ChangeMobileNotifySend){
        var params = [String : String]()
        params[GlobalData.id.rawValue] = model.id
        params[GlobalData.isOpen.rawValue] = model.isOpen
        params[GlobalData.userType.rawValue] = model.userType
        connection.makePostConnection(params, subDomain: HttpLink.CHANGE_MOBILE_NOTIFICATION_LINK)
    
    }
    
    func dispatchChangeAudioNotification(model : ChangeAudioNotifySend){
    
        var params = [String : String]()
        params[GlobalData.id.rawValue] = model.id
        params[GlobalData.isOpen.rawValue] = model.isOpen
        params[GlobalData.userType.rawValue] = model.userType
        connection.makePostConnection(params, subDomain: HttpLink.CHANGE_AUDIO_NOTIFICATION_LINK)
    }
   
    
    
     //# MARK: - Send To Controller
    //TAKES DATA FROM CONNECTION IN ORDER TO SEND THE CONTROLLER
    func getJson(subDomain: String, jsonData : NSData) {
        
        //change frequency response
        if subDomain == HttpLink.CHANGE_FREQUENCY_LINK {
            
            //generate model from json data
            let json = JSON(data: jsonData )
            var model : CommonModelResponse = CommonModelResponse()
            guard let result = json[GlobalData.result.rawValue].string else{
                debugPrint("Setting Service CHANGE_FREQUENCY_LINK Json Data result Error")
                return
            }
            model.result = result
            guard let message = json[GlobalData.message.rawValue].string else{
                debugPrint("Setting Service CHANGE_FREQUENCY_LINK Json Data message Error")
                return
            }
            model.message = message
            guard let error = json[GlobalData.error.rawValue].string else{
                debugPrint("Setting Service CHANGE_FREQUENCY_LINK Json Data error Error")
                return
            }
            model.error = error
            if  self.settingDelegate != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.settingDelegate?.getChangeNotificationFrequencyModel(model)
                })
           }
                    }
            //change email            
        else if subDomain == HttpLink.CHANGE_MAIL_LINK {
            //generate model from json data
            let json = JSON(data: jsonData )
            var model : CommonVersionModelResponse = CommonVersionModelResponse()
            guard let result = json[GlobalData.result.rawValue].string else{
                debugPrint("Setting Service CHANGE_MAIL_LINK Json Data result Error")
                return
            }
            model.result = result
            guard let message = json[GlobalData.message.rawValue].string else{
                debugPrint("Setting Service CHANGE_MAIL_LINK Json Data message Error")
                return
            }
            model.message = message
            guard let error = json[GlobalData.error.rawValue].string else{
                debugPrint("Setting Service CHANGE_MAIL_LINK Json Data error Error")
                return
            }
            model.error = error
            guard let dbVersion = json[GlobalData.databaseVersion.rawValue].string else {
                debugPrint("Setting Service CHANGE_MAIL_LINK Json Data databaseVersion Error")
                return
            }
            model.databaseVersion = dbVersion
            guard let isUpdated = json[GlobalData.isUpdated.rawValue].string else {
                debugPrint("Setting Service CHANGE_MAIL_LINK Json Data isUpdated Error")
                return
            }
            model.isUpdated = isUpdated
            guard let forcedToUpdate = json[GlobalData.forcedToUpdate.rawValue].string else {
                debugPrint("Setting Service CHANGE_MAIL_LINK Json Data forcedToUpdate Error")
                return
            }
            model.forcedToUpdate = forcedToUpdate
            if  self.settingDelegate != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.settingDelegate?.getChangeEmailModel(model)
                })
            }
            
        }
            
            
            //change level response
           else if subDomain == HttpLink.CHANGE_LEVEL_LINK {
            let json = JSON(data:jsonData)
            var model : CommonVersionModelResponse = CommonVersionModelResponse()
            guard  let result = json[GlobalData.result.rawValue].string else {
            debugPrint("Setting Service CHANGE_LEVEL_LINK Json Data result Error")
                return
            }
            model.result = result
            guard let message = json[GlobalData.message.rawValue].string else {
                debugPrint("Setting Service CHANGE_LEVEL_LINK Json Data message Error")
                return
            }
            model.message = message
            guard let error = json[GlobalData.error.rawValue].string else {
                debugPrint("Setting Service CHANGE_LEVEL_LINK Json Data error Error")
                return
            }
            model.error = error
            guard let dbVersion = json[GlobalData.databaseVersion.rawValue].string else {
                debugPrint("Setting Service CHANGE_LEVEL_LINK Json Data databaseVersion Error")
                return
            }
            model.databaseVersion = dbVersion
            guard let isUpdated = json[GlobalData.isUpdated.rawValue].string else {
                debugPrint("Setting Service CHANGE_LEVEL_LINK Json Data isUpdated Error")
                return
            }
            model.isUpdated = isUpdated
            if  self.settingDelegate != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                 self.settingDelegate?.getChangeLevelNotifictionModel(model)
                })
            }
        
        }
            //change email response
        else if subDomain == HttpLink.CHANGE_MAIL_NOTIFICATION_LINK {
            //generate model from json data
            let json = JSON(data: jsonData )
            var model : CommonVersionModelResponse = CommonVersionModelResponse()
            guard let result = json[GlobalData.result.rawValue].string else{
                debugPrint("Setting Service CHANGE_MAIL_NOTIFICATION_LINK Json Data result Error")
                return
            }
            model.result = result
            guard let message = json[GlobalData.message.rawValue].string else{
                debugPrint("Setting Service CHANGE_MAIL_NOTIFICATION_LINK Json Data message Error")
                return
            }
            model.message = message
            guard let error = json[GlobalData.error.rawValue].string else{
                debugPrint("Setting Service CHANGE_MAIL_NOTIFICATION_LINK Json Data error Error")
                return
            }
            model.error = error
            guard let dbVersion = json[GlobalData.databaseVersion.rawValue].string else {
                debugPrint("Setting Service CHANGE_MAIL_NOTIFICATION_LINK Json Data dbVersion Error")
                return
                        }
            model.databaseVersion = dbVersion
            guard let isUpdated = json[GlobalData.isUpdated.rawValue].string else {
            debugPrint("Setting Service CHANGE_MAIL_NOTIFICATION_LINK Json Data isUpdated Error")
                return
            }
            model.isUpdated = isUpdated
            if  self.settingDelegate != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                 self.settingDelegate?.getChangeMailNotificationModel(model)
                })
            }
            
        }
            //change mobile response
        else if subDomain == HttpLink.CHANGE_MOBILE_NOTIFICATION_LINK {
            //generate model from json data
            let json = JSON(data: jsonData )
            var model : CommonModelResponse = CommonModelResponse()
            guard let result = json[GlobalData.result.rawValue].string else{
                debugPrint("Setting Service CHANGE_MOBILE_NOTIFICATION_LINK Json Data result Error")
                return
            }
            model.result = result
            guard let message = json[GlobalData.message.rawValue].string else{
                debugPrint("Setting Service CHANGE_MOBILE_NOTIFICATION_LINK Json Data message Error")
                return
            }
            model.message = message
            guard let error = json[GlobalData.error.rawValue].string else{
                debugPrint("Setting Service CHANGE_MOBILE_NOTIFICATION_LINK Json Data error Error")
                return
            }
            model.error = error
            if  self.settingDelegate != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                  self.settingDelegate?.getChangeMobileNotificationModel(model)
                })
            }
         
        }
            //change audio response
        else if subDomain == HttpLink.CHANGE_AUDIO_NOTIFICATION_LINK {
            //generate model from json data
            let json = JSON(data: jsonData )
            var model : CommonModelResponse = CommonModelResponse()
            guard let result = json[GlobalData.result.rawValue].string else{
                debugPrint("Setting Service CHANGE_AUDIO_NOTIFICATION_LINK Json Data result Error")
                return
            }
            model.result = result
            guard let message = json[GlobalData.message.rawValue].string else{
                debugPrint("Setting Service CHANGE_AUDIO_NOTIFICATION_LINK Json Data message Error")
                return
            }
            model.message = message
            guard let error = json[GlobalData.error.rawValue].string else{
                debugPrint("Setting Service CHANGE_AUDIO_NOTIFICATION_LINK Json Data error Error")
                return
            }
            model.error = error
            if  self.settingDelegate != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.settingDelegate?.getChangeAudioNotificationModel(model)
                })
            }
            
        }
        
        }
    
    
    func getError(errMessage : String) {
        
        if  errorDelegate != nil {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.errorDelegate?.onError(errMessage)
            })
        }
        
    }
    
      //# MARK: - Class Variables / Members / Constructors
    weak  var  settingDelegate = SettingDelegate?()
    weak var errorDelegate = ErrorDelegate?()
    let  connection = PostConnection()
    
    
    init(){
        self.connection.delegate = self
        
    }
    
    
}