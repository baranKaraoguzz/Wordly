//
//  SelectLevelResponse.swift
//  Wordly
//
//  Created by eposta developer on 30/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

/*
 
 {
 "result": "OK",
 "message": "Seviye belirleme tamamlandı.  / {"Bir hata oluştu. Lütfen daha sonra tekrar deneyiniz."} " ,
 "error": "null/true",
 "id":"5465411186-11",
 "userType":"facebook",
 "userLevel": "intermediate",
 "name":"enis",
 "surname":"yavaş",
 "password":"123546",
 "registeredMail":"enisyavas@yahoo.com",
 "notificationMail":"enisyavas@yahoo.com",
 "notificationFrequency":"5",
 "isAudioNotificationOpen":"true",
 "isEmailNotificationOpen":"true",
 "isMobileNotificationOpen":"true"
 }

 */

struct SelectLevelResponse : CustomDebugStringConvertible {
    
    var result : String = ""
    var message : String = ""
    var error : String = ""
    var id : String = ""
    var userType : String = ""
    var userLevel : String = ""
    var name : String = ""
    var surname : String = ""
    var password : String = ""
    var registeredMail : String = ""
    var notificationMail : String = ""
    var notificationFrequency : String = ""
    var isAudioNotificationOpen : String = ""
    var isEmailNotificationOpen : String = ""
    var isMobileNotificationOpen : String = ""
   
    
    var debugDescription: String {
        let desc = " result : " + result + " message : " + message + " error : " + error + " id : " + id +
       " userType : " + userType  + " userLevel : " + userLevel +  " name : " + name + " surname : " + surname + " password : " + password +
       " registeredMail : " + registeredMail + " notificationMail : " + notificationMail + " notificationFrequency : " + notificationFrequency +
       " isAudioNotificationOpen : " + isAudioNotificationOpen + " isEmailNotificationOpen : " + isEmailNotificationOpen +
        " isMobileNotificationOpen : " + isMobileNotificationOpen
        return desc
    }
    
    
}
