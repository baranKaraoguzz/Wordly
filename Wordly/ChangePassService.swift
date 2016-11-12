//
//  ChangePassService.swift
//  Wordly
//
//  Created by eposta developer on 03/08/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

//ESTABLISHES RELATIONSHIP  THE CONTROLLER BETWEEN THE POSTCONNECTION
class ChangePassService : ConnectionDelegate {
    
  
    
    
    //FETCH DATA FROM CONROLLER IN ORDER TO SEND THE POSTCONNECTION
    func dispatchChangePasswordData(model : ChangePasswordSend){
        /*
         "idMail":"156151616-12",
         "newPassword":"1223312"
         */
        var params = [String : String]()
        params[GlobalData.idMail.rawValue] = model.idMail
        params[GlobalData.newPassword.rawValue] = model.newPassword
        connection.makePostConnection(params, subDomain: HttpLink.CHANGE_PASSWORD_LINK)
    }
    
    
    //TAKES DATA FROM CONNECTION IN ORDER TO SEND THE CONTROLLER
    
    func getJson(subDomain: String, jsonData : NSData) {
        
                // change password response
        if subDomain == HttpLink.CHANGE_PASSWORD_LINK {
            
            
            //generate model from json data
            let json = JSON(data: jsonData )
            var model : CommonModelResponse = CommonModelResponse()
            guard let result = json[GlobalData.result.rawValue].string else{
                debugPrint("ChangePass Service CHANGE_PASSWORD_LINK Json Data result Error")
                return
            }
            model.result = result
            guard let message = json[GlobalData.message.rawValue].string else{
                debugPrint("ChangePass Service CHANGE_PASSWORD_LINK Json Data message Error")
                return
            }
            model.message = message
            guard let error = json[GlobalData.error.rawValue].string else{
                debugPrint("ChangePass Service CHANGE_PASSWORD_LINK Json Data error Error")
                return
            }
            model.error = error
            if  self.changePassDelegate != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.changePassDelegate?.getChangePasswordModel(model)
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
    weak  var  changePassDelegate = ChangePassDelegate?()
    weak var errorDelegate = ErrorDelegate?()
    let  connection = PostConnection()
    
    
    init(){
        self.connection.delegate = self
        
    }
    
    
}