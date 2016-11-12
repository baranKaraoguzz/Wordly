//
//  ForgotPassResponse.swift
//  Wordly
//
//  Created by eposta developer on 30/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

struct CommonModelResponse : CustomDebugStringConvertible  {
    
    var result : String = ""
    var message : String = ""
    var error : String = ""
  
    
    var debugDescription: String {
        let desc = " result : " + result + " message : " + message + " error : " + error
        return desc
    }

    

}
