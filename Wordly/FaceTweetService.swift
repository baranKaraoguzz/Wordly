//
//  FaceTweetService.swift
//  Wordly
//
//  Created by eposta developer on 29/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation


//ESTABLISHES RELATIONSHIP  THE CONTROLLER BETWEEN THE POSTCONNECTION
class FaceTweetService : ConnectionDelegate {
    
    


     //# MARK: - Send To PostConnection
      //FETCH DATA FROM CONROLLER IN ORDER TO SEND THE POSTCONNECTION
    func dispatchFaceTweetModelToConnection(model  : FaceTweetSend ){
        
        /*"id":"1051051511145",
        "userType":"facebook/twitter",
        "dbVersion":"1",
        "versionCode":"1"*/
        
         // 2 DISPATCH PARAMATERS TO THE CONNECTION
        var params = [String : String]()
        params[GlobalData.id.rawValue] = model.id
        params[GlobalData.userType.rawValue] = model.userType
        params[GlobalData.dbVersion.rawValue] = model.dbVersion
        params[GlobalData.versionCode.rawValue] = model.versionCode
        connection.makePostConnection(params, subDomain: HttpLink.FACETWEET_LINK)
        
    }
    
    //# MARK: - Send To Controller
    //TAKES DATA FROM CONNECTION IN ORDER TO SEND THE CONTROLLER
    
    func getJson(subDomain: String, jsonData : NSData) {
        
        
        /*  // REGISTERTED  USER
         
         "result": "OK",
         "message": "Ok" / {"Bir hata oluştu." Lütfen daha sonra tekrar deneyiniz."} ,
         "error": "null/true",
         "isRegisteredUser": "true/false",
         "userType":"facebook/twitter",
         "userLevel": "intermediate/null",
         "registeredMail":"enisyavas@yahoo.com",
         "notificationMail":"enisyavas@yahoo.com",
         "notificationFrequency":"5",
         "isAudioNotificationOpen":"true",
         "isEmailNotificationOpen":"true",
         "isMobileNotificationOpen":"true",
         "databaseVersion":"5",
         "isUpdated":"true/false",
         "forcedToUpdate":"false"
         }
         
         //UNREGISTERED USER
         //kayıtlı olmayan facebook, twitter kullanıcısı
         {
         "result": "OK",
         "message": "Ok" / {"Bir hata oluştu." Lütfen daha sonra tekrar deneyiniz."} ,
         "error": "null/true",
         "isRegisteredUser": "true/false",
         "databaseVersion":"5",
         "isUpdated":"true/false",
         "forcedToUpdate":"false"
         
         */
        
        if subDomain == HttpLink.FACETWEET_LINK {
            //generate model from JSON data
            
            let json = JSON(data:jsonData)
           debugPrint(mLogTag + "FaceTweet Parse Json.")
            var faceTweetResponseModel : FaceTweetResponse = FaceTweetResponse()
            //result
            guard let result = json[GlobalData.result.rawValue].string else{
                debugPrint("FaceTweet Service Json Data  result Error")
                return
            }
            faceTweetResponseModel.result = result
            //message
            guard let message = json[GlobalData.message.rawValue].string else{
                debugPrint("FaceTweet Service Json Data  message Error")
                return
            }
            faceTweetResponseModel.message = message
            //error
            guard let error = json[GlobalData.error.rawValue].string else{
                debugPrint("FaceTweet Service Json Data  error Error")
                return
            }
            faceTweetResponseModel.error = error
            //databaseVersion
            guard let databaseVersion = json[GlobalData.databaseVersion.rawValue].string else{
                debugPrint("FaceTweet Service Json Data  databaseVersion Error")
                return
            }
            faceTweetResponseModel.databaseVersion = databaseVersion
            //isUpdated
            guard let isUpdated = json[GlobalData.isUpdated.rawValue].string else{
                debugPrint("FaceTweet Service Json Data  isUpdated Error")
                return
            }
            faceTweetResponseModel.isUpdated = isUpdated
            //forcedToUpdate
            guard let forcedToUpdate = json[GlobalData.forcedToUpdate.rawValue].string else{
                debugPrint("FaceTweet Service Json Data  forcedToUpdate Error")
                return
            }
            faceTweetResponseModel.forcedToUpdate = forcedToUpdate
            
            //isRegisteredUser
            guard let isRegisteredUser = json[GlobalData.isRegisteredUser.rawValue].string else{
                debugPrint("FaceTweet Service Json Data  isRegisteredUser Error")
                return
            }
            faceTweetResponseModel.isRegisteredUser = isRegisteredUser
          
            if isRegisteredUser == FinalString.TRUE
            {
          debugPrint()
            //-----------------------------------------------------------
            //              ONLY FOR REGISTERED USER
            //-----------------------------------------------------------
            
            //userType
            guard let userType = json[GlobalData.userType.rawValue].string else{
                debugPrint("FaceTweet Service Json Data  userType Error")
                return
            }
            faceTweetResponseModel.userType = userType
            //userLevel
            guard let userLevel = json[GlobalData.userLevel.rawValue].string else{
                debugPrint("FaceTweet Service Json Data  userLevel Error")
                return
            }
            faceTweetResponseModel.userLevel = userLevel
            //registeredMail
            guard let registeredMail = json[GlobalData.registeredMail.rawValue].string else{
                debugPrint("FaceTweet Service Json Data  registeredMail Error")
                return
            }
            faceTweetResponseModel.registeredMail = registeredMail
            //notificationMail
            guard let notificationMail = json[GlobalData.notificationMail.rawValue].string else{
                debugPrint("FaceTweet Service Json Data  notificationMail Error")
                return
            }
            faceTweetResponseModel.notificationMail = notificationMail
            //notificationFrequency
            guard let notificationFrequency = json[GlobalData.notificationFrequency.rawValue].string else{
                debugPrint("FaceTweet Service Json Data  notificationFrequency Error")
                return
            }
            faceTweetResponseModel.notificationFrequency = notificationFrequency
            //isAudioNotificationOpen
            guard let isAudioNotificationOpen = json[GlobalData.isAudioNotificationOpen.rawValue].string else{
                debugPrint("FaceTweet Service Json Data  isAudioNotificationOpen Error")
                return
            }
            faceTweetResponseModel.isAudioNotificationOpen = isAudioNotificationOpen
            //isEmailNotificationOpen
            guard let isEmailNotificationOpen = json[GlobalData.isEmailNotificationOpen.rawValue].string else{
                debugPrint("FaceTweet Service Json Data  isEmailNotificationOpen Error")
                return
            }
            faceTweetResponseModel.isEmailNotificationOpen = isEmailNotificationOpen
            //isMobileNotificationOpen
            guard let isMobileNotificationOpen = json[GlobalData.isMobileNotificationOpen.rawValue].string else{
                debugPrint("FaceTweet Service Json Data  isMobileNotificationOpen Error")
                return
            }
            faceTweetResponseModel.isMobileNotificationOpen = isMobileNotificationOpen
            }
            //------------------------ ONLY FOR REGISTERED USER ---------------------------
          
            //dispatch model to controller
            if  self.faceTweetDelegate != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.faceTweetDelegate?.getFaceTweetResponseModel(faceTweetResponseModel)
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
    weak var faceTweetDelegate = FaceTweetDelegate?()
    weak var errorDelegate = ErrorDelegate?()
    let  connection = PostConnection()
    private let mLogTag : String = "FaceTweetService "
    
    init(){
        self.connection.delegate = self
        
    }
    

}
