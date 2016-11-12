//
//  ForgotService.swift
//  Wordly
//
//  Created by eposta developer on 13/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

//ESTABLISHES RELATIONSHIP  THE CONTROLLER BETWEEN THE POSTCONNECTION
class ForgotService : ConnectionDelegate {
    
    
    //# MARK: - Send To PostConnection
    //FETCH DATA FROM CONROLLER IN ORDER TO SEND THE POSTCONNECTION
    func dispatchForgotData(model : ForgotPassSend  ){
        
        // 2 DISPATCH PARAMATERS TO THE CONNECTION
        var params = [String: String]()
        params[GlobalData.email.rawValue] = model.email
        connection.makePostConnection(params,subDomain:HttpLink.FORGOT_LINK)
    }
    
  
     //# MARK: - Send To Controller
    //TAKES DATA FROM CONNECTION IN ORDER TO SEND THE CONTROLLER
     func getJson(subDomain: String, jsonData : NSData) {
        
        if subDomain == HttpLink.FORGOT_LINK {
            //generate model from json data
            let json = JSON(data: jsonData )
            var modelResponse : CommonModelResponse = CommonModelResponse()
            //result
            guard let result = json[GlobalData.result.rawValue].string else{
                debugPrint("Forgot Service Json Data  result Error")
                return
            }
            modelResponse.result = result
            //message
            guard let message = json[GlobalData.message.rawValue].string else{
                debugPrint("Forgot Service Json Data  message Error")
                return
            }
            modelResponse.message = message
            //error
            guard let error = json[GlobalData.error.rawValue].string else{
                debugPrint("Forgot Service Json Data  error Error")
                return
            }
            modelResponse.error = error
            
            //dispatch model to controller
            if  self.forgotDelegate != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.forgotDelegate?.getForgotResponseModel(modelResponse)
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
    
    //# MARK: - constants & variables
    weak  var  forgotDelegate = ForgotDelegate?()
    weak var errorDelegate = ErrorDelegate?()
    let  connection = PostConnection()
    
    
    init(){
        self.connection.delegate = self
        
    }
}