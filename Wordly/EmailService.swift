//
//  EmailService.swift
//  Wordly
//
//  Created by eposta developer on 02/09/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation


//ESTABLISHES RELATIONSHIP  THE CONTROLLER BETWEEN THE POSTCONNECTION
class EmailService : ConnectionDelegate {
    
   
    
    
    //# MARK: - Send To PostConnection
    //FETCH DATA FROM CONROLLER IN ORDER TO SEND THE POSTCONNECTION
    
    //get email control model data
    func dispatchLEmailControlModelToConnection(model : EmailControlSend){
        var params = [String: String]()
        params[GlobalData.email.rawValue] = model.email
        params[GlobalData.dbVersion.rawValue] = model.dbVersion
        params[GlobalData.versionCode.rawValue] = model.versionCode
        connection.makePostConnection(params,subDomain:HttpLink.EMAIL_CONTROL_LINK)
    }
    
    //get email login data
    func dispatchLEmailoginModelToConnection(model : EmailLoginSend){
        var params = [String: String]()
        params[GlobalData.idMail.rawValue] = model.idMail
        connection.makePostConnection(params,subDomain:HttpLink.EMAIL_LOGIN_LINK)
        
    }
    
    
    //# MARK: - Send To Controller
    //TAKES DATA FROM CONNECTION IN ORDER TO SEND THE CONTROLLER
    
    func getJson(subDomain: String, jsonData : NSData) {
        
        /**
         "result": "OK",
         "message": "Ok" / {"Bir hata oluştu." Lütfen daha sonra tekrar deneyiniz."} ,
         "error": "null/true",
         "isRegisteredUser": "true / false",
         "idMail": "12131021051-1 l",
         "databaseVersion":"5",
         "isUpdated":"true/false",
         "forcedToUpdate": "true/false”
         */
        if subDomain == HttpLink.EMAIL_CONTROL_LINK {
            //generate model from json data
            let json = JSON(data: jsonData )
            var emailControlResponseModel : EmailControlResponse = EmailControlResponse()
            //result
            guard let result = json[GlobalData.result.rawValue].string else{
                debugPrint("Email Control Service Json Data  result Error")
                return
            }
            emailControlResponseModel.result = result
            //message
            guard let message = json[GlobalData.message.rawValue].string else{
                debugPrint("Email Control Service Json Data  message Error")
                return
            }
            emailControlResponseModel.message = message
            //error
            guard let error = json[GlobalData.error.rawValue].string else{
                debugPrint("Email Control Service Json Data  error Error")
                return
            }
            emailControlResponseModel.error = error
            //idMail
            guard let idMail = json[GlobalData.idMail.rawValue].string else{
                debugPrint("Email Control Service Json Data  idMail Error")
                return
            }
            emailControlResponseModel.idMail = idMail
            //isRegisteredUser
            guard let isRegisteredUser = json[GlobalData.isRegisteredUser.rawValue].string else{
                debugPrint("Email Control Service Json Data  isRegisteredUser Error")
                return
            }
            emailControlResponseModel.isRegisteredUser = isRegisteredUser
            //databaseVersion
            guard let databaseVersion = json[GlobalData.databaseVersion.rawValue].string else{
                debugPrint("Email Control Service Json Data  databaseVersion Error")
                return
            }
            emailControlResponseModel.databaseVersion = databaseVersion
            //isUpdated
            guard let isUpdated = json[GlobalData.isUpdated.rawValue].string else{
                debugPrint("Email Control Service Json Data  isUpdated Error")
                return
            }
            emailControlResponseModel.isUpdated = isUpdated
            //forcedToUpdate
            guard let forcedToUpdate = json[GlobalData.forcedToUpdate.rawValue].string else{
                debugPrint("Email Control Service Json Data  forcedToUpdate Error")
                return
            }
            emailControlResponseModel.forcedToUpdate = forcedToUpdate
            //dispatch model to controller
            if  self.emailDelegate != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.emailDelegate?.getEmailControlResponseModel(emailControlResponseModel)
                })                
            }
        }
            
            /*
             "result": "OK",
             "message": "Giriş başarılı. / {"Bir hata oluştu." Lütfen daha sonra tekrar deneyiniz."} ,
             "error": "null/true",
             "idMail": "12131021051-1",
             "isNewUser": "false/true",
             "userType":"mail",
             "userLevel": "intermediate/null",
             "registeredMail":"enisyavas@yahoo.com",
             "notificationMail":"enisyavas@yahoo.com",
             "notificationFrequency":"12",
             "isAudioNotificationOpen":"true",
             "isEmailNotificationOpen":"true",
             "isMobileNotificationOpen":"true"
             
             */
        else if subDomain == HttpLink.EMAIL_LOGIN_LINK {
            //generate model from json data
            let json = JSON(data: jsonData )
            var emailLoginResponseModel : EmailLoginResponse = EmailLoginResponse()
            //result
            guard let result = json[GlobalData.result.rawValue].string else{
                debugPrint("Email Login Service Json Data  result Error")
                return
            }
            emailLoginResponseModel.result = result
            //message
            guard let message = json[GlobalData.message.rawValue].string else{
                debugPrint("Email Login Service Json Data  message Error")
                return
            }
            emailLoginResponseModel.message = message
            //error
            guard let error = json[GlobalData.error.rawValue].string else{
                debugPrint("Email Login Service Json Data  error Error")
                return
            }
            emailLoginResponseModel.error = error
            //idMail
            guard let idMail = json[GlobalData.idMail.rawValue].string else{
                debugPrint("Email Login Service Json Data  idMail Error")
                return
            }
            emailLoginResponseModel.idMail = idMail
            //isNewUser
            guard let isNewUser = json[GlobalData.isNewUser.rawValue].string else{
                debugPrint("Email Login Service Json Data  isNewUser Error")
                return
            }
            emailLoginResponseModel.isNewUser = isNewUser
            //userType
            guard let userType = json[GlobalData.userType.rawValue].string else{
                debugPrint("Email Login Service Json Data  userType Error")
                return
            }
            emailLoginResponseModel.userType = userType
            //userLevel
            guard let userLevel = json[GlobalData.userLevel.rawValue].string else{
                debugPrint("Email Login Service Json Data  userLevel Error")
                return
            }
            emailLoginResponseModel.userLevel = userLevel
            //registeredMail
            guard let registeredMail = json[GlobalData.registeredMail.rawValue].string else{
                debugPrint("Email Login Service Json Data  registeredMail Error")
                return
            }
            emailLoginResponseModel.registeredMail = registeredMail
            //notificationMail
            guard let notificationMail = json[GlobalData.notificationMail.rawValue].string else{
                debugPrint("Email Login Service  Json Data  notificationMail Error")
                return
            }
            emailLoginResponseModel.notificationMail = notificationMail
            //notificationFrequency
            guard let notificationFrequency = json[GlobalData.notificationFrequency.rawValue].string else{
                debugPrint("Email Login Service Json Data  notificationFrequency Error")
                return
            }
            emailLoginResponseModel.notificationFrequency = notificationFrequency
            //isAudioNotificationOpen
            guard let isAudioNotificationOpen = json[GlobalData.isAudioNotificationOpen.rawValue].string else{
                debugPrint("Email Login Service Json Data  isAudioNotificationOpen Error")
                return
            }
            emailLoginResponseModel.isAudioNotificationOpen = isAudioNotificationOpen
            //isEmailNotificationOpen
            guard let isEmailNotificationOpen = json[GlobalData.isEmailNotificationOpen.rawValue].string else{
                debugPrint("Email Login Service Json Data  isEmailNotificationOpen Error")
                return
            }
            emailLoginResponseModel.isEmailNotificationOpen = isEmailNotificationOpen
            //isMobileNotificationOpen
            guard let isMobileNotificationOpen = json[GlobalData.isMobileNotificationOpen.rawValue].string else{
                debugPrint("Email Login Service Json Data  isMobileNotificationOpen Error")
                return
            }
            emailLoginResponseModel.isMobileNotificationOpen = isMobileNotificationOpen
            //dispatch model to controller
            if  self.emailDelegate != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.emailDelegate?.getEmailLoginResponseModel(emailLoginResponseModel)
                })
            }

            
        }///-
        
    }
    
    func getError(errMessage : String) {
        
        if  errorDelegate != nil {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.errorDelegate?.onError(errMessage)
            })
        }
        
    }
    
     //# MARK: - Class Variables / Members / Constructors
    
    weak  var  emailDelegate = EmailDelegate?()
    weak  var errorDelegate = ErrorDelegate?()
    let  connection = PostConnection()
    
    init(){
        self.connection.delegate = self
        
    }

    
}