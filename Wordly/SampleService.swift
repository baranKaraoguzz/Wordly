//
//  SampleService.swift
//  Wordly
//
//  Created by eposta developer on 30/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

//ESTABLISHES RELATIONSHIP  THE CONTROLLER BETWEEN THE POSTCONNECTION
class SampleService : ConnectionDelegate {
    
   // weak  var  loginDelegate = LoginDelegate?()
  weak   var errorDelegate = ErrorDelegate?()
    let  connection = PostConnection()
    
    
    init(){
        self.connection.delegate = self
        
    }
    
    
    //FETCH DATA FROM CONROLLER IN ORDER TO SEND THE POSTCONNECTION
    func getEmailAndToken(email: String, token  : String ){
        
        
        
    }
    
    
    
    
    //TAKES DATA FROM CONNECTION IN ORDER TO SEND THE CONTROLLER
    
    func getJson(subDomain: String, jsonData : NSData) {
        
        if subDomain == HttpLink.FORGOT_LINK {
            
        }
        
    }
    
    func getError(errMessage : String) {
       
        if  errorDelegate != nil {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.errorDelegate?.onError(errMessage)
            })
        }

}

    
}