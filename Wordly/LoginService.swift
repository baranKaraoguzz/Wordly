//
//  LoginService.swift
//  Wordly
//
//  Created by eposta developer on 01/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

//ESTABLISHES RELATIONSHIP  THE CONTROLLER BETWEEN THE POSTCONNECTION
class LoginService : ConnectionDelegate {
   
    
     //# MARK: - Send To PostConnection
    //FETCH DATA FROM CONROLLER IN ORDER TO SEND THE POSTCONNECTION
    
    func dispatchLoginModelToConnection(model : LoginSend){
        /*
        "email":"abc@gmail.com",
        "password":"12345",
        "dbVersion":"1",
        "versionCode":"1"
                */
        
        
        // 2 DISPATCH PARAMATERS TO THE CONNECTION
        var params = [String: String]()
        params[GlobalData.email.rawValue] = model.email
        params[GlobalData.password.rawValue] = model.password
        params[GlobalData.dbVersion.rawValue] = model.dbVersion
        params[GlobalData.versionCode.rawValue] = model.versionCode
        connection.makePostConnection(params,subDomain:HttpLink.LOGIN_LINK)

        
    }
    
    
     //# MARK: - Send To Controller
    //TAKES DATA FROM CONNECTION IN ORDER TO SEND THE CONTROLLER
    
    func getJson(subDomain: String, jsonData : NSData) {
        /*  // if 
        {
            "result": "OK",
            "message": "Giriş başarılı. / “Kullanıcı adı veya şifre hatalı. /{"Bir hata oluştu." Lütfen daha sonra tekrar deneyiniz."} ,
        "error": "null/true",
        "idMail": "12131021051-1",
        "isNewUser": "false/true",   ***(level seçili değilse true)
        "password":"123546",
        "userType":"mail",
        "userLevel": "intermediate/null",
        "registeredMail":"enisyavas@yahoo.com",
        "notificationMail":"enisyavas@yahoo.com",
        "notificationFrequency":"12",
        "isAudioNotificationOpen":"true",
        "isEmailNotificationOpen":"true",
        "isMobileNotificationOpen":"true",
        "databaseVersion":"5",
        "isUpdated":"true/false",
        "forcedToUpdate":"false" 
    }
*/
        
        if subDomain == HttpLink.LOGIN_LINK {
            //generate model from json data
            let json = JSON(data: jsonData )
            var loginResponseModel : LoginResponse = LoginResponse()
            //result
            guard let result = json[GlobalData.result.rawValue].string else{
                debugPrint("Login Service Json Data  result Error")
                return
            }
            loginResponseModel.result = result
            //message
            guard let message = json[GlobalData.message.rawValue].string else{
                debugPrint("Login Service Json Data  message Error")
                return
            }
            loginResponseModel.message = message
            //error
            guard let error = json[GlobalData.error.rawValue].string else{
                debugPrint("Login Service Json Data  error Error")
                return
            }
            loginResponseModel.error = error
            //idMail
            guard let idMail = json[GlobalData.idMail.rawValue].string else{
                debugPrint("Login Service Json Data  idMail Error")
                return
            }
            loginResponseModel.idMail = idMail
            //isNewUser
            guard let isNewUser = json[GlobalData.isNewUser.rawValue].string else{
                debugPrint("Login Service Json Data  isNewUser Error")
                return
            }
            loginResponseModel.isNewUser = isNewUser
            //password
            guard let password = json[GlobalData.password.rawValue].string else{
                debugPrint("Login Service Json Data  password Error")
                return
            }
            loginResponseModel.password = password
            //userType
            guard let userType = json[GlobalData.userType.rawValue].string else{
                debugPrint("Login Service Json Data  userType Error")
                return
            }
            loginResponseModel.userType = userType
            //userLevel
            guard let userLevel = json[GlobalData.userLevel.rawValue].string else{
                debugPrint("Login Service Json Data  userLevel Error")
                return
            }
            loginResponseModel.userLevel = userLevel
            //registeredMail
            guard let registeredMail = json[GlobalData.registeredMail.rawValue].string else{
                debugPrint("Login Service Json Data  registeredMail Error")
                return
            }
            loginResponseModel.registeredMail = registeredMail
            //notificationMail
            guard let notificationMail = json[GlobalData.notificationMail.rawValue].string else{
                debugPrint("Login Service Json Data  notificationMail Error")
                return
            }
            loginResponseModel.notificationMail = notificationMail
            //notificationFrequency
            guard let notificationFrequency = json[GlobalData.notificationFrequency.rawValue].string else{
                debugPrint("Login Service Json Data  notificationFrequency Error")
                return
            }
            loginResponseModel.notificationFrequency = notificationFrequency
            //isAudioNotificationOpen
            guard let isAudioNotificationOpen = json[GlobalData.isAudioNotificationOpen.rawValue].string else{
                debugPrint("Login Service Json Data  isAudioNotificationOpen Error")
                return
            }
            loginResponseModel.isAudioNotificationOpen = isAudioNotificationOpen
            //isEmailNotificationOpen
            guard let isEmailNotificationOpen = json[GlobalData.isEmailNotificationOpen.rawValue].string else{
                debugPrint("Login Service Json Data  isEmailNotificationOpen Error")
                return
            }
            loginResponseModel.isEmailNotificationOpen = isEmailNotificationOpen
            //isMobileNotificationOpen
            guard let isMobileNotificationOpen = json[GlobalData.isMobileNotificationOpen.rawValue].string else{
                debugPrint("Login Service Json Data  isMobileNotificationOpen Error")
                return
            }
            loginResponseModel.isMobileNotificationOpen = isMobileNotificationOpen
            //databaseVersion
            guard let databaseVersion = json[GlobalData.databaseVersion.rawValue].string else{
                debugPrint("Login Service Json Data  databaseVersion Error")
                return
            }
           loginResponseModel.databaseVersion = databaseVersion
            //isUpdated
            guard let isUpdated = json[GlobalData.isUpdated.rawValue].string else{
                debugPrint("Login Service Json Data  isUpdated Error")
                return
            }
            loginResponseModel.isUpdated = isUpdated
            //forcedToUpdate
            guard let forcedToUpdate = json[GlobalData.forcedToUpdate.rawValue].string else{
                debugPrint("Login Service Json Data  forcedToUpdate Error")
                return
            }
            loginResponseModel.forcedToUpdate = forcedToUpdate
            
            //dispatch model to controller
            if  self.loginDelegate != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.loginDelegate?.getLoginResponseModel(loginResponseModel)
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
    weak  var  loginDelegate = LoginDelegate?()
    weak var errorDelegate = ErrorDelegate?()
    let  connection = PostConnection()
    
    
    init(){
        self.connection.delegate = self
    }
    
    
}
