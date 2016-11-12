//
//  FaceTweetResponse.swift
//  Wordly
//
//  Created by eposta developer on 30/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

/*
 {
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
 */


struct FaceTweetResponse : CustomDebugStringConvertible {
    
    var result : String = ""
    var message : String = ""
    var error : String = ""
    var isRegisteredUser : String = ""
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
        let desc = "result : " + result + " message : " + message + " error : " + error + " isRegisteredUser : " + isRegisteredUser +
            " userType : " + userType  + " userLevel : " + userLevel + " registeredMail : " + registeredMail +
            " notificationMail : " + notificationMail + " notificationFrequency : " + notificationFrequency + "isAudioNotificationOpen : " + isAudioNotificationOpen +
            " isEmailNotificationOpen : " + isEmailNotificationOpen +    " isMobileNotificationOpen : " + isMobileNotificationOpen +
            " databaseVersion : " + databaseVersion + " isUpdated : " + isUpdated + " forcedToUpdate : " + forcedToUpdate
        return desc
    }
    
    
}
