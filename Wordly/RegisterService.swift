//
//  RegisterService.swift
//  Wordly
//
//  Created by eposta developer on 30/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation


//ESTABLISHES RELATIONSHIP  THE CONTROLLER BETWEEN THE POSTCONNECTION
class RegisterService : ConnectionDelegate {
    
 
    //# MARK: - Send To PostConnection
    //FETCH DATA FROM CONTROLLER IN ORDER TO SEND THE POSTCONNECTION
    func dispatchRegisterModelToConnection(model : RegisterSend){
        
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
        connection.makePostConnection(params,subDomain:HttpLink.REGISTER_LINK)
        
    }
    
    
    //# MARK: - Send To Controller
    //TAKES DATA FROM CONNECTION IN ORDER TO SEND THE CONTROLLER
    
    func getJson(subDomain: String, jsonData : NSData) {
        
        /*
         "result": "OK",
         "message": "Lütfen hesabınızı aktif edin" / {"Bir hata oluştu. Lütfen daha sonra tekrar deneyiniz."},
         "error": "null/true",
         "userId": "12131021051-1/",
         "databaseVersion":"5",
         "isUpdated":"true/false",
         "forcedToUpdate":"false"
         
         */
        
        if subDomain == HttpLink.REGISTER_LINK {
            
            //generate model from json data
            let json = JSON(data: jsonData )
            var registerResponseModel : RegisterResponse = RegisterResponse()
            guard let result = json[GlobalData.result.rawValue].string else{
                debugPrint("Register Service Json Data  result Error")
                return
            }
            registerResponseModel.result = result
            guard let message = json[GlobalData.message.rawValue].string else{
                debugPrint("Register Service Json Data  message Error")
                return
            }
            registerResponseModel.message = message
            guard let error = json[GlobalData.error.rawValue].string else{
                debugPrint("Register Service Json Data  error Error")
                return
            }
            registerResponseModel.error = error
            guard let userId = json[GlobalData.userId.rawValue].string else{
                debugPrint("Register Service Json Data  userId Error")
                return
            }
            registerResponseModel.userId = userId
            guard let databaseVersion = json[GlobalData.databaseVersion.rawValue].string else{
                debugPrint("Register Service Json Data  databaseVersion Error")
                return
            }
            registerResponseModel.databaseVersion = databaseVersion
            guard let isUpdated = json[GlobalData.isUpdated.rawValue].string else{
                debugPrint("Register Service Json Data  isUpdated Error")
                return
            }
            registerResponseModel.isUpdated = isUpdated
            guard let forcedToUpdate = json[GlobalData.forcedToUpdate.rawValue].string else{
                debugPrint("Register Service Json Data  forcedToUpdate Error")
                return
            }
            registerResponseModel.forcedToUpdate = forcedToUpdate
            
            //dispatch model to controller
            if  self.registerDelegate != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.registerDelegate?.getRegisterResponseModel(registerResponseModel)
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
    weak  var  registerDelegate = RegisterDelegate?()
    weak var errorDelegate = ErrorDelegate?()
    let  connection = PostConnection()
    
    init(){
        self.connection.delegate = self
        
    }
    
    
}
