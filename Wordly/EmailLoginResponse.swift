//
//  EmailResponse.swift
//  Wordly
//
//  Created by eposta developer on 02/09/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

/*
 "result": "OK",
 "message": "Giriş başarılı. / {"Bir hata oluştu." Lütfen daha sonra tekrar deneyiniz."} ,
 "error": "null/true",
 "idMail": "12131021051-1",
 "isNewUser": "false/true",
 "userType":"mail",
 "userLevel": "intermediate/null",
 "registeredMail":"enisyavas@yahoo.com",
 "notificationMail":"enisyavas@yahoo.com",
 "notificationFrequency":"12",
 "isAudioNotificationOpen":"true",
 "isEmailNotificationOpen":"true",
 "isMobileNotificationOpen":"true"

 */

struct EmailLoginResponse : CustomDebugStringConvertible {

    var result : String = ""
    var message : String = ""
    var error : String = ""
    var idMail : String = ""
    var isNewUser : String = ""
    var userType : String = ""
    var userLevel : String = ""
    var registeredMail : String = ""
    var notificationMail : String = ""
    var notificationFrequency : String = ""
    var isAudioNotificationOpen : String = ""
    var isEmailNotificationOpen : String = ""
    var isMobileNotificationOpen : String = ""
 
    
    var debugDescription: String {
        let desc = " result : " + result + " message : " + message + " error : " + error + " idMail : " + idMail + " isNewUser : " + isNewUser +
            " userType : " + userType + " userLevel : " + userLevel + " registeredMail : " + registeredMail + " notificationMail : " + notificationMail +  " notificationFrequency : " + notificationFrequency +
              " isAudioNotificationOpen : " + isAudioNotificationOpen + " isEmailNotificationOpen : " + isEmailNotificationOpen + " isMobileNotificationOpen : " + isMobileNotificationOpen
        return desc
    }

}