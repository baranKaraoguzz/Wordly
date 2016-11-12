//
//  LevelService.swift
//  Wordly
//
//  Created by eposta developer on 12/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation


class LevelService : ConnectionDelegate {
    
  
    
    //# MARK: - Send To PostConnection
    //FETCH DATA FROM CONROLLER IN ORDER TO SEND THE POSTCONNECTION
    func dispatchLevelData(model : SelectLevelSend ){
        
        /*
         "id":"5465411186-11",
         "userType":"facebook/twitter/mail",
         "userLevel": "beginner/intermediate/advanced",
         "name":"enis",
         "surname":"yavaş",
         "registeredMail":"enisyavas@yahoo.com"
         */
        
        // 2 DISPATCH PARAMATERS TO THE CONNECTION
       var params = [String: String]()
       params[GlobalData.id.rawValue] = model.id
       params[GlobalData.userType.rawValue] = model.userType
       params[GlobalData.userLevel.rawValue] = model.userLevel
       params[GlobalData.name.rawValue] = model.name
       params[GlobalData.surname.rawValue] = model.surname
       params[GlobalData.registeredMail.rawValue] = model.registeredMail
       connection.makePostConnection(params,subDomain:HttpLink.SELECT_LEVEL_LINK)
        
            }
    
     //# MARK: - Send To Controller
    //TAKES DATA FROM CONNECTION IN ORDER TO SEND THE CONTROLLER
    
    func getJson(subDomain: String, jsonData : NSData) {
        
        if subDomain == HttpLink.SELECT_LEVEL_LINK {
            
            //generate model from json data
            let json = JSON(data: jsonData )
            var selectLevelResponse : SelectLevelResponse = SelectLevelResponse()
            guard let result = json[GlobalData.result.rawValue].string else{
                debugPrint("Select Level Service Json Data result Error")
                return
            }
            selectLevelResponse.result = result
            guard let message = json[GlobalData.message.rawValue].string else{
                debugPrint("Select Level Service Data message Error")
                return
            }
            selectLevelResponse.message = message
            guard let error = json[GlobalData.error.rawValue].string else{
                debugPrint("Select Level Service Json Data error Error")
                return
            }
            selectLevelResponse.error = error
            guard let id = json[GlobalData.id.rawValue].string else{
                debugPrint("Select Level Service Json Data id Error")
                return
            }
            selectLevelResponse.id = id
            guard let userType = json[GlobalData.userType.rawValue].string else{
                debugPrint("Select Level Service Json Data userType Error")
                return
            }
            selectLevelResponse.userType = userType
            guard let userLevel = json[GlobalData.userLevel.rawValue].string else{
                debugPrint("Select Level Service Json Data userLevel Error")
                return
            }
            selectLevelResponse.userLevel = userLevel
            guard let name = json[GlobalData.name.rawValue].string else{
                debugPrint("Select Level Service Json Data name Error")
                return
            }
            selectLevelResponse.name = name
            guard let surname = json[GlobalData.surname.rawValue].string else{
                debugPrint("Select Level Service Json Data surname Error")
                return
            }
            selectLevelResponse.surname = surname
            guard let password = json[GlobalData.password.rawValue].string else{
                debugPrint("Select Level Service Json Data password Error")
                return
            }
            selectLevelResponse.password = password
            guard let registeredMail = json[GlobalData.registeredMail.rawValue].string else{
                debugPrint("Select Level Service Json Data registeredMail Error")
                return
            }
            selectLevelResponse.registeredMail = registeredMail
            guard let notificationMail = json[GlobalData.notificationMail.rawValue].string else{
                debugPrint("Select Level Service Json Data notificationMail Error")
                return
            }
            selectLevelResponse.notificationMail = notificationMail
            guard let notificationFrequency = json[GlobalData.notificationFrequency.rawValue].string else{
                debugPrint("Select Level Service Json Data notificationFrequency Error")
                return
            }
            selectLevelResponse.notificationFrequency = notificationFrequency
            guard let isAudioNotificationOpen = json[GlobalData.isAudioNotificationOpen.rawValue].string else{
                debugPrint("Select Level Service Json Data isAudioNotificationOpen Error")
                return
            }
            selectLevelResponse.isAudioNotificationOpen = isAudioNotificationOpen
            guard let isEmailNotificationOpen = json[GlobalData.isEmailNotificationOpen.rawValue].string else{
                debugPrint("Select Level Service Json Data isEmailNotificationOpen Error")
                return
            }
            selectLevelResponse.isEmailNotificationOpen = isEmailNotificationOpen
            guard let isMobileNotificationOpen = json[GlobalData.isMobileNotificationOpen.rawValue].string else{
                debugPrint("Select Level Service Json Data isMobileNotificationOpen Error")
                return
            }
            selectLevelResponse.isMobileNotificationOpen = isMobileNotificationOpen
            //dispatch model to controller
            if  self.levelDelegate != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.levelDelegate?.getSelectLevelResponseModel(selectLevelResponse)
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
    weak  var  levelDelegate = LevelDelegate?()
    weak var errorDelegate = ErrorDelegate?()
    let  connection = PostConnection()
    
    
    init(){
        self.connection.delegate = self
        
    }
    
    
    
}