//
//  LoginResponse.swift
//  Wordly
//
//  Created by eposta developer on 30/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

/*
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

struct LoginResponse : CustomDebugStringConvertible {
    
    var result : String = ""
    var message : String = ""
    var error : String = ""
    var idMail : String = ""
    var isNewUser : String = ""
    var password : String = ""
    var userType : String = ""
    var userLevel : String = ""
    var registeredMail : String = ""
    var notificationMail : String = ""
    var notificationFrequency : String = ""
    var isAudioNotificationOpen : String = ""
    var isEmailNotificationOpen : String = ""
    var isMobileNotificationOpen : String = ""
    var databaseVersion : String = ""
    var isUpdated : String = ""
    var forcedToUpdate : String = ""
    
    var debugDescription: String {
        let desc = "result : " + result + " message : " + message + " error : " + error + " idMail : " + idMail +
            " isNewUser : " + isNewUser + " password : " + password + " userType : " + userType  + " userLevel : " + userLevel + " registeredMail : " + registeredMail +
            " notificationMail : " + notificationMail + " notificationFrequency : " + notificationFrequency + " isAudioNotificationOpen : " + isAudioNotificationOpen +
            " isEmailNotificationOpen : " + isEmailNotificationOpen +    " isMobileNotificationOpen : " + isMobileNotificationOpen +
            " databaseVersion : " + databaseVersion + " isUpdated : " + isUpdated + " forcedToUpdate : " + forcedToUpdate
        return desc
    }
    
}
