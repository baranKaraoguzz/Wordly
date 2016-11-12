//
//  EmailControlResponse.swift
//  Wordly
//
//  Created by eposta developer on 02/09/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

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

struct EmailControlResponse : CustomDebugStringConvertible {
    
    var result : String = ""
    var message : String = ""
    var error : String = ""
    var isRegisteredUser : String = ""
    var idMail : String = ""
    var databaseVersion : String = ""
    var isUpdated : String = ""
    var forcedToUpdate : String = ""

    
    
    var debugDescription: String {
        let desc = " result : " + result + " message : " + message + " error : " + error + " idMail : " + idMail +
          " isRegisteredUser : " + isRegisteredUser + " databaseVersion : " + databaseVersion + " isUpdated : " + isUpdated + " forcedToUpdate : " + forcedToUpdate
        return desc
    }
    
}