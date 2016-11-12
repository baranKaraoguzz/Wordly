//
//  UserPrefence.swift
//  Wordly
//
//  Created by eposta developer on 12/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

class UserPrefence {
    
    //# MARK: - Diagnose Application First-Run
    // diagnose whether does app run first-time or not.
    static func isFirstRun() -> Bool{
        
        let isLaunchBefore = NSUserDefaults.standardUserDefaults().boolForKey(firstRun)
        if isLaunchBefore {
        debugPrint(logTag + "The app has run before.")
            return false
        }
        else {
        debugPrint(logTag + "The app is running first-time.")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: firstRun)
            return true
        }

    }
    
    //#MARK: - Show Facebook Progress
    static func willShowProgress() -> Bool{
        
    let willShow = NSUserDefaults.standardUserDefaults().boolForKey(progresShow)
        if willShow {
        debugPrint(logTag + "progress will be showed.")
         return true
        }
        else {
            debugPrint(logTag + "progress won\'t be showed.")
        return false
        }
        
    }
    
    static func setShowProgress(willShow :Bool) {
    NSUserDefaults.standardUserDefaults().setBool(willShow, forKey: progresShow)
    }
    
    
    //#MARK: - Diagnose whether wordlist version is checked or not. 
    static func isVersionChecked() -> Bool {
    
        let isChecked = NSUserDefaults.standardUserDefaults().boolForKey(versionChecked)
        if isChecked {
        debugPrint(logTag + " version has been checked before.")
            return true
        }
        else {
           debugPrint(logTag + " version has not been checked before.")
            return false
        }
    }
    
    static func setVersionChecked(isChecked : Bool) {
    NSUserDefaults.standardUserDefaults().setBool(isChecked, forKey: versionChecked)
    }
    
    static func setVersion(version: String) {
    NSUserDefaults.standardUserDefaults().setValue(version, forKey: versionNumber)
    }
    
    static func getVersion() -> String {
    let verNo = String(NSUserDefaults.standardUserDefaults().valueForKey(versionNumber)!)
    return verNo
    }
    
     //# MARK: - Diagnose Notification Setted
    //diagnose whether  the notification setting is set for actual user.
    static func isNotificationPrepared() -> Bool {
    
        let isPrepared = NSUserDefaults.standardUserDefaults().boolForKey(notificationPrepared)
        if isPrepared {
        debugPrint(logTag + " notification was arranged before.")
        return true
        }
        else {
            debugPrint(logTag + " notification did not aranged before.")
        return false
        }
            }
    
    static func setNotificationPrepared(isPrepared : Bool) {
    NSUserDefaults.standardUserDefaults().setBool(isPrepared, forKey: notificationPrepared)
    
    }
    
     //# MARK: - Write Last User Type
    static func writeLastUserType (type : UserType) {
        
       let prefs = NSUserDefaults.standardUserDefaults()
       switch type {
       case .mail:
            debugPrint(logTag + "mail user has been written.")
            prefs.setValue(lastUserKey, forKey: lastUserKey)
            prefs.setValue(type.rawValue, forKey: lastUSer)
            prefs.synchronize()
            break
       case .facebook:
             debugPrint(logTag + "facebook user has been written.")
             prefs.setValue(lastUserKey, forKey: lastUserKey)
             prefs.setValue(type.rawValue, forKey: lastUSer)
             prefs.synchronize()
             break
       case .twitter:
            debugPrint(logTag + "twitter user has been written.")
            prefs.setValue(lastUserKey, forKey: lastUserKey)
            prefs.setValue(type.rawValue, forKey: lastUSer)
            prefs.synchronize()
            break
       default :
        debugPrint(logTag + "no user has been written. ")
            break
               }
        
    }
    //# MARK: - Read Last User Type
    static func readLastUserType() -> UserType {
    
        let prefs = NSUserDefaults.standardUserDefaults()
        if let userKey = prefs.valueForKey(lastUserKey){
            let user = prefs.valueForKey(lastUSer)
            debugPrint(logTag + "The user \(user) is read with key \(userKey)")
          
            return UserType(type: String(user!))
        }
        else {
        return .undefined
             }
    }
    
     //# MARK: - Save User Data
    //Password has been not saved yet.
    static func saveMailUserData(mailUser : RegisteredUser){
        let prefs = NSUserDefaults.standardUserDefaults()
         prefs.setValue(mMailUserKey , forKey: mMailUserKey )
         prefs.setValue(mailUser.id, forKey: mIdKey)
         prefs.setValue(mailUser.name, forKey: mNameKey)
         prefs.setValue(mailUser.surname, forKey: mSurnameKey)
         prefs.setValue(mailUser.registeredMail, forKey: mRegMailKey)
         prefs.setValue(mailUser.notificationMail, forKey: mNotifyMailKey)
         prefs.setValue(mailUser.userLevel.rawValue, forKey: mUserLevelKey)
         prefs.setValue(mailUser.userType.rawValue, forKey: mUserTypeKey)
         prefs.setValue(mailUser.notificationFrequency.rawValue, forKey: mNotifyFreqKey)
         prefs.setBool(mailUser.isAudioNotificationOpen, forKey: mAudioOpenKey)
         prefs.setBool(mailUser.isEmailNotificationOpen, forKey: mEmailOpenKey)
         prefs.setBool(mailUser.isMobileNotificationOpen, forKey: mMobileOpenKey)
         prefs.synchronize()
    
    }
    
    static func saveFacebookUserData(facebookUser : RegisteredUser){
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setValue( fFacebookUserKey , forKey: fFacebookUserKey )
        prefs.setValue(facebookUser.id, forKey: fIdKey)
        prefs.setValue(facebookUser.name, forKey: fNameKey)
        prefs.setValue(facebookUser.surname, forKey: fSurnameKey)
        prefs.setValue(facebookUser.registeredMail, forKey: fRegMailKey)
        prefs.setValue(facebookUser.notificationMail, forKey: fNotifyMailKey)
        prefs.setValue(facebookUser.userLevel.rawValue, forKey: fUserLevelKey)
        prefs.setValue(facebookUser.userType.rawValue, forKey: fUserTypeKey)
        prefs.setValue(facebookUser.notificationFrequency.rawValue, forKey: fNotifyFreqKey)
        prefs.setBool(facebookUser.isAudioNotificationOpen, forKey: fAudioOpenKey)
        prefs.setBool(facebookUser.isEmailNotificationOpen, forKey: fEmailOpenKey)
        prefs.setBool(facebookUser.isMobileNotificationOpen, forKey: fMobileOpenKey)
        prefs.synchronize()
        
    }
    
    static func saveTwitterUserData(twitterUser : RegisteredUser){
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setValue( tTwitterUserKey , forKey: tTwitterUserKey )
        prefs.setValue(twitterUser.id, forKey: tIdKey)
        prefs.setValue(twitterUser.name, forKey: tNameKey)
        prefs.setValue(twitterUser.surname, forKey: tSurnameKey)
        prefs.setValue(twitterUser.registeredMail, forKey: tRegMailKey)
        prefs.setValue(twitterUser.notificationMail, forKey: tNotifyMailKey)
        prefs.setValue(twitterUser.userLevel.rawValue, forKey: tUserLevelKey)
        prefs.setValue(twitterUser.userType.rawValue, forKey: tUserTypeKey)
        prefs.setValue(twitterUser.notificationFrequency.rawValue, forKey: tNotifyFreqKey)
        prefs.setBool(twitterUser.isAudioNotificationOpen, forKey: tAudioOpenKey)
        prefs.setBool(twitterUser.isEmailNotificationOpen, forKey: tEmailOpenKey)
        prefs.setBool(twitterUser.isMobileNotificationOpen, forKey: tMobileOpenKey)
        prefs.synchronize()
    }

     //# MARK: - Read User Data
    static func readMailUserData() -> RegisteredUser{
        let prefs = NSUserDefaults.standardUserDefaults()
        if let mailKey = prefs.objectForKey(mMailUserKey){
            // exist
            debugPrint(logTag + "Mail user data is read with key \(mailKey)." )
            let id = prefs.valueForKey(mIdKey)
            let name = prefs.valueForKey(mNameKey)
            let surname = prefs.valueForKey(mSurnameKey)
            let regMail = prefs.valueForKey(mRegMailKey)
            let notifyMail = prefs.valueForKey(mNotifyMailKey)
            let userLevel = prefs.valueForKey(mUserLevelKey)
            let userType = prefs.valueForKey(mUserTypeKey)
            let freq = prefs.valueForKey(mNotifyFreqKey)
            let isAudio = prefs.boolForKey(mAudioOpenKey)
            let isEmail = prefs.boolForKey(mEmailOpenKey)
            let isMobile = prefs.boolForKey(mMobileOpenKey)
            
            debugPrint(logTag + "Read data = id : \(id!) name : \(name!)  surname : \(surname!) regMail : \(regMail!) notifyMail : \(notifyMail!) userLevel : \(userLevel!) userType : \(userType!) freq : \(freq!) isAudio : \(isAudio) isEmail : \(isEmail) isMobile : \(isMobile)" )
            var mailUserReg : RegisteredUser = RegisteredUser()
            mailUserReg.id = String(id!)
            mailUserReg.name = String(name!)
            mailUserReg.surname = String(surname!)
            mailUserReg.registeredMail = String(regMail!)
            mailUserReg.notificationMail = String(notifyMail!)
            mailUserReg.isMobileNotificationOpen = isMobile
            mailUserReg.isEmailNotificationOpen = isEmail
            mailUserReg.isAudioNotificationOpen = isAudio
            debugPrint("not freg \(freq) ---  ?= \(Frequency(rawValue: String(freq!))?.rawValue) ")
            debugPrint("user level \(userLevel) --- ?=  \(UserLevel(level: String(userLevel!) ).rawValue)")
            debugPrint("user type \(userType) --- ?=  \(UserType(type: String(userType!) ).rawValue)")
            mailUserReg.notificationFrequency = Frequency(rawValue: freq as! String)
            mailUserReg.userLevel = UserLevel(level: String(userLevel!) )
            mailUserReg.userType = UserType(type: String(userType!))
            return mailUserReg
        }
        else {
            debugPrint(logTag + "Mail user data does not found.")
            // not exist
                return RegisteredUser()
        }
        
    }
    
    static func readFacebookUserData() -> RegisteredUser{
        let prefs = NSUserDefaults.standardUserDefaults()
        if let facebookKey = prefs.objectForKey(fFacebookUserKey){
            // exist
            debugPrint(logTag + "Facebook user data is read with key \(facebookKey)." )
            let id = prefs.valueForKey(fIdKey)
            let name = prefs.valueForKey(fNameKey)
            let surname = prefs.valueForKey(fSurnameKey)
            let regMail = prefs.valueForKey(fRegMailKey)
            let notifyMail = prefs.valueForKey(fNotifyMailKey)
            let userLevel = prefs.valueForKey(fUserLevelKey)
            let userType = prefs.valueForKey(fUserTypeKey)
            let freq = prefs.valueForKey(fNotifyFreqKey)
            let isAudio = prefs.boolForKey(fAudioOpenKey)
            let isEmail = prefs.boolForKey(fEmailOpenKey)
            let isMobile = prefs.boolForKey(fMobileOpenKey)
            
            debugPrint(logTag + "Read data = id : \(id) name : \(name)  surname : \(surname) regMail : \(regMail) notifyMail : \(notifyMail) userLevel : \(userLevel) userType : \(userType) freq : \(freq) isAudio : \(isAudio) isEmail : \(isEmail) isMobile : \(isMobile)" )
            var facebookUserReg : RegisteredUser = RegisteredUser()
            facebookUserReg.id = String(id!)
            facebookUserReg.name = String(name!)
            facebookUserReg.surname = String(surname!)
            facebookUserReg.registeredMail = String(regMail!)
            facebookUserReg.notificationMail = String(notifyMail!)
            facebookUserReg.isMobileNotificationOpen = isMobile
            facebookUserReg.isEmailNotificationOpen = isEmail
            facebookUserReg.isAudioNotificationOpen = isAudio
            debugPrint("not freg \(freq) ---  ?= \(Frequency(rawValue: String(freq!))?.rawValue) ")
            debugPrint("user level \(userLevel) --- ?=  \(UserLevel(level: String(userLevel!) ).rawValue)")
            debugPrint("user type \(userType) --- ?=  \(UserType(type: String(userType!) ).rawValue)")
            facebookUserReg.notificationFrequency = Frequency(rawValue: freq as! String)
            facebookUserReg.userLevel = UserLevel(level: String(userLevel!) )
            facebookUserReg.userType = UserType(type: String(userType!))
            
            return facebookUserReg
        }
        else {
            debugPrint(logTag + "Facebook user data does not found.")
            // not exist
            return RegisteredUser()
        }
        
    }
   static func readTwitterUserData() -> RegisteredUser{
        let prefs = NSUserDefaults.standardUserDefaults()
        if let facebookKey = prefs.objectForKey(tTwitterUserKey){
            // exist
            debugPrint(logTag + "Twitter user data is read with key \(facebookKey)." )
            let id = prefs.valueForKey(tIdKey)
            let name = prefs.valueForKey(tNameKey)
            let surname = prefs.valueForKey(tSurnameKey)
            let regMail = prefs.valueForKey(tRegMailKey)
            let notifyMail = prefs.valueForKey(tNotifyMailKey)
            let userLevel = prefs.valueForKey(tUserLevelKey)
            let userType = prefs.valueForKey(tUserTypeKey)
            let freq = prefs.valueForKey(tNotifyFreqKey)
            let isAudio = prefs.boolForKey(tAudioOpenKey)
            let isEmail = prefs.boolForKey(tEmailOpenKey)
            let isMobile = prefs.boolForKey(tMobileOpenKey)
            debugPrint(logTag + "Read data = id : \(id) name : \(name)  surname : \(surname) regMail : \(regMail) notifyMail : \(notifyMail) userLevel : \(userLevel) userType : \(userType) freq : \(freq) isAudio : \(isAudio) isEmail : \(isEmail) isMobile : \(isMobile)" )
            var twitterUserReg : RegisteredUser = RegisteredUser()
            twitterUserReg.id = String(id!)
            twitterUserReg.name = String(name!)
            twitterUserReg.surname = String(surname!)
            twitterUserReg.registeredMail = String(regMail!)
            twitterUserReg.notificationMail = String(notifyMail!)
            twitterUserReg.isMobileNotificationOpen = isMobile
            twitterUserReg.isEmailNotificationOpen = isEmail
            twitterUserReg.isAudioNotificationOpen = isAudio
            debugPrint("not freg \(freq) ---  ?= \(Frequency(rawValue: String(freq!))?.rawValue) ")
            debugPrint("user level \(userLevel) --- ?=  \(UserLevel(level: String(userLevel!) ).rawValue)")
            debugPrint("user type \(userType) --- ?=  \(UserType(type: String(userType!) ).rawValue)")
            twitterUserReg.notificationFrequency = Frequency(rawValue: freq as! String)
            twitterUserReg.userLevel = UserLevel(level: String(userLevel!) )
            twitterUserReg.userType = UserType(type: String(userType!))
            
            return twitterUserReg
        }
        else {
            debugPrint(logTag + "Twitter user data does not found.")
            // not exist
            return RegisteredUser()
        }
        
    }
    
    //# MARK : Diagnose whether user log out or not 
    static func isUserLogIn() -> Bool {
        
        let isLogIn = NSUserDefaults.standardUserDefaults().boolForKey(userLogInNow)
 
        if isLogIn {
            debugPrint(logTag + "User has logged in.")
            return true
        }
        else {
            debugPrint(logTag + "User has not been logged in.")
            return false
        }       }
    
    static func setUserLogInStatus(isLogIn : Bool) {
        NSUserDefaults.standardUserDefaults().setBool(isLogIn, forKey: userLogInNow)
    }
    
    //# MARK: - Class Variables / Members
    private static let logTag = "User Preferences "
    private static let firstRun = "is_First_Run"
    private static let lastUSer = "last_user"
    private static let lastUserKey = "last_user_key"
    private static let notificationPrepared = "notification_prepared"
    private static let userLogInNow = "userLogInNow"
    private static let versionChecked = "versionChecked"
    private static let versionNumber = "versionNumber"
    
    //mail
    private static let mMailUserKey : String = "mMailUserKey"
    private static let mIdKey : String = "mIdKey"
    private static let mNameKey : String = "mNameKey"
    private  static let mSurnameKey : String = "mSurnameKey"
    private static let mRegMailKey : String = "mRegMailKey"
    private static let mNotifyMailKey : String = "mNotifyMailKey"
    //  static let mPassKey : String = "mPassKey"
    private static let mUserLevelKey : String = "mUserLevelKey"
    private static let mUserTypeKey : String = "mUserTypeKey"
    private  static let mNotifyFreqKey : String = "mNotifyFreqKey"
    private  static let mAudioOpenKey : String = "mAudioOpenKey"
    private  static let mEmailOpenKey : String = "mEmailOpenKey"
    private  static let mMobileOpenKey : String = "mMobileOpenKey"
    //facebook
    private static let fFacebookUserKey : String = "fFacebookUserKey"
    private  static let fIdKey : String = "fIdKey"
    private  static let fNameKey : String = "fNameKey"
    private static let fSurnameKey : String = "fSurnameKey"
    private static let fRegMailKey : String = "fRegMailKey"
    private static let fNotifyMailKey : String = "fNotifyMailKey"
    //  static let fPassKey : String = "fPassKey"
    private static let fUserLevelKey : String = "fUserLevelKey"
    private static let fUserTypeKey : String = "fUserTypeKey"
    private static let fNotifyFreqKey : String = "fNotifyFreqKey"
    private static let fAudioOpenKey : String = "fAudioOpenKey"
    private static let fEmailOpenKey : String = "fEmailOpenKey"
    private static let fMobileOpenKey : String = "fMobileOpenKey"
    //twitter
    private static let tTwitterUserKey : String = "tTwitterUserKey"
    private static let tIdKey : String = "tIdKey"
    private static let tNameKey : String = "tNameKey"
    private static let tSurnameKey : String = "tSurnameKey"
    private static let tRegMailKey : String = "tRegMailKey"
    private static let tNotifyMailKey : String = "tNotifyMailKey"
    //   static let tPassKey : String = "tPassKey"
    private static let tUserLevelKey : String = "tUserLevelKey"
    private static let tUserTypeKey : String = "tUserTypeKey"
    private static let tNotifyFreqKey : String = "tNotifyFreqKey"
    private static let tAudioOpenKey : String = "tAudioOpenKey"
    private static let tEmailOpenKey : String = "tEmailOpenKey"
    private static let tMobileOpenKey : String = "tMobileOpenKey"
    
    // show progress 
    private static let progresShow : String = "showProgress"

}
