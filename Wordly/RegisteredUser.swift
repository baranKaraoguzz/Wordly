//
//  RegisteredUser.swift
//  Wordly
//
//  Created by eposta developer on 12/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

struct RegisteredUser : CustomDebugStringConvertible {

    var id : String = ""
    var name : String = ""
    var surname : String = ""
    var registeredMail : String = ""
    var notificationMail : String = ""
    var password : String = ""
    
    var userLevel : UserLevel!
    var userType : UserType!
    var notificationFrequency : Frequency!
    var isAudioNotificationOpen : Bool!
    var isEmailNotificationOpen : Bool!
    var isMobileNotificationOpen : Bool!
    
    
    
      var debugDescription: String {
        let _id : String = "id : " + id
        let _name : String = " name : " + name
        let _surname : String = " surname " + surname
        let _registeredMail : String = " registeredMail " + registeredMail
        let _notificationMail : String = " notificationMail : " + notificationMail
        let _userType : String = " userType : " + userType.rawValue
        let _userLevel : String = " userLevel : " + userLevel.rawValue
        //Nil Coalescing
        let _notificationFrequency : String =  (notificationFrequency != nil) ? " notificationFrequency " + notificationFrequency.rawValue : ""
        let _isAudioNotificationOpen : String = " isAudioNotificationOpen " + String(isAudioNotificationOpen)
        let _isEmailNotificationOpen : String = " isEmailNotificationOpen " + String(isEmailNotificationOpen)
        let _isMobileNotificationOpen : String = " isMobileNotificationOpen : " + String(isMobileNotificationOpen)
        let desc : String = _id.stringByAppendingString(_name) + _surname + _registeredMail + _notificationMail + _userType + _userLevel + _notificationFrequency + _isAudioNotificationOpen + _isEmailNotificationOpen + _isMobileNotificationOpen
        
        return desc
    }
    
    
   
    

}