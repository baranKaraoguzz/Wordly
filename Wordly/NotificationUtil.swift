//
//  NotificationUtil.swift
//  Wordly
//
//  Created by eposta developer on 21/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import UIKit

/*
 (00:00 / 02:00 / 04:00 / 06:00 / 08:00 / 10:00 / 12:00 / 14:00 / 16:00 / 18:00 / 20:00 / 22:00)
 
 (00:00 / 03:00 /  06:00 / 09:00 / 12 :00 / 15:00 / 18:00 / 21:00)
 
 (00:00 / 04:00 /  08:00 / 12:00 / 16 :00 / 20:00)
 
 (08:00 / 11:00 / 14:00 / 17:00)
 
 (08:00 / 12:00 / 16:00 )
 
 (sabah 08:00 ve 18:00'de) = = (08:00 / 18:00 )
 
 sabah 08:00'de)
 */

class NotificationUtil  {
    
    
     //# MARK: - Send Notifications
    func sendNotifications(frequency : Frequency , isAudioOpen : Bool) {
        let h = DateUtil.getCurrentHourInt()
        debugPrint(mLogTag + "int hour \(h)")
        let availableHourArr : [AvailableHour] = getAvailableHoursWithPostponedInfo(frequency, isAudioOpen: true)
        var startingDate = NSDate()
        var i = 1
        self.notifications = []
        for aHour in availableHourArr {
            let notification = UILocalNotification()
            notification.repeatInterval = NSCalendarUnit.Day
            let space = " "
            var fullSpace = ""
            for _ in 1...i {
              //  debugPrint("\(index) time ")
                fullSpace = fullSpace + space                
            }
            let bodyText = "Wordly Günün Kelimesi!" + fullSpace
            debugPrint("\(bodyText.characters.count) bodytext ")
            notification.alertBody = bodyText
            // notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
            notification.applicationIconBadgeNumber = 1
            startingDate = dateWithDay(aHour.isSentToday, hour: aHour.hour)
            notification.fireDate = startingDate
            if isAudioOpen {
                if aHour.hasSound {
                notification.soundName = UILocalNotificationDefaultSoundName
                }
            }
            DateUtil.showFormattedDate(startingDate)
            debugPrint("notifications's count = \(notifications.count)  i = \(i)")
            self.notifications.insert(notification, atIndex: (i - 1))
            let notify = self.notifications[i - 1]
            debugPrint(mLogTag + "fire date = \(notify.fireDate)")
            i += 1
        }
        debugPrint(mLogTag + "notifications count : \(self.notifications.count)")
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector:  #selector(NotificationUtil.sendNotificationWithTimer), userInfo: nil, repeats: true)
        self.count = availableHourArr.count
    }
    
    /*
    func sendNotifications(frequency : Frequency , hour : Int, isAudioOpen : Bool) {
        let availableHourArr : [AvailableHour] = getAvailableHoursWithPostponedInfo(frequency, isAudioOpen: isAudioOpen)
        var startingDate = NSDate()
        var i = 1
        self.notifications = []
        for aHour in availableHourArr {
            let notification = UILocalNotification()
            notification.repeatInterval = NSCalendarUnit.Day
            notification.alertBody = "Wordly Günün Kelimesi!"
            notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
            startingDate = dateWithDay(aHour.isSentToday, hour: aHour.hour)
            notification.fireDate = startingDate
             DateUtil.showFormattedDate(startingDate)
            debugPrint("notifications's count = \(notifications.count)  i = \(i)")
            self.notifications.insert(notification, atIndex: (i - 1))
            let notify = self.notifications[i - 1]
            debugPrint(mLogTag + "fire date = \(notify.fireDate)")
            i += 1
        }
        debugPrint(mLogTag + "notifications count : \(self.notifications.count)")
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:  #selector(NotificationUtil.sendNotificationWithTimer), userInfo: nil, repeats: true)
        self.count = availableHourArr.count
    }
 */
        
    dynamic private func sendNotificationWithTimer(){
        if start >= count {
            self.timer.invalidate()
            isFinish = true
            
        }
        debugPrint(self.mLogTag + "\(self.start). time  method is called.")
        let index = self.start - 1
        let notify = self.notifications[index]
         DateUtil.showFormattedDate(notify.fireDate!)
        debugPrint(mLogTag + "sending fire date = \(notify.fireDate)")
        UIApplication.sharedApplication().scheduleLocalNotification(notify)
        self.start += 1
        if self.isFinish {
        self.start =  1
        self.isFinish = false
        }
    }
    
     //# MARK: - Set Daily Hours
    // set notification starting date
    private func dateWithDay (isToday : Bool, hour: Int) -> NSDate {
        
        let calendar = NSCalendar.currentCalendar()
        var dateSend = NSDate()
        if  isToday
        {
            let calComps = calendar.componentsInTimeZone(NSTimeZone.defaultTimeZone(), fromDate: dateSend)
            calComps.hour = hour
            calComps.minute = 1
            calComps.second = 0
            dateSend = calendar.dateFromComponents(calComps)!
        }
        else {
            dateSend = dateSend.dateByAddingTimeInterval(86400)
            let calComps = calendar.componentsInTimeZone(NSTimeZone.defaultTimeZone(), fromDate: dateSend)
            calComps.hour = hour
            calComps.minute = 1
            calComps.second = 0
            dateSend =  calendar.dateFromComponents(calComps)!
        }
        return dateSend
    }
    
    
    // if isRun == true notification will be pushed today otherwise the notificaiton will be pushed the next day.
    private func getAvailableHoursWithPostponedInfo(frequency : Frequency , isAudioOpen : Bool) -> [AvailableHour] {
        var aHourArr: [AvailableHour]  = []
       
        let calendar = NSCalendar.currentCalendar()
        let comps = calendar.componentsInTimeZone(NSTimeZone.defaultTimeZone(), fromDate: NSDate())
        let currentHour = comps.hour
        let availableHours : [AvailableHour] = getAvailableHours(frequency, isAudioOpen: isAudioOpen)
        
        for availableHour in availableHours {
            var aHour = AvailableHour()
            aHour.hour = availableHour.hour
            aHour.hasSound = availableHour.hasSound
            if currentHour < availableHour.hour
            {
                aHour.isSentToday = true
            }
            else {
                aHour.isSentToday = false
            }
            aHourArr.append(aHour)
        }
        
        return aHourArr
    }
    
   //# MARK: - Get Notification Times (Frequency)
    // get notification hours which will be fired
    private func getNotificationHours(freq : Frequency)->[Int]{
        switch freq {
        case .freq_12:
            return   [0,2,4,6,8,10,12,14,16,18,20,22]
        case .freq_8:
            return [0,3,6,9,12,15,18,21]
        case .freq_6 :
            return [0,4,8,12,16,20]
        case .freq_4 :
            return [8,11,14,17]
        case .freq_3 :
            return [8,12,16]
        case .freq_2 :
            return [8,18]
        case .freq_1 :
            return [8]
        }
    }
    
    
        //# MARK: - Get Available Notification Hours
        // get available hours consideringly audio option
    private func getAvailableHours(frequency : Frequency, isAudioOpen : Bool) -> [AvailableHour]
    {
        var availableHoursDictArr : [AvailableHour] = []
        
        let notifyHoursArr : [Int] = getNotificationHours(frequency)
        
        switch frequency {
            
        case .freq_12:
            // [0,2,4,6,8,10,12,14,16,18,20,22]
            for index in 0...11{
                let nHour = notifyHoursArr[index]
                
                var availableHour : AvailableHour
                //-------------------------
                // AUDIO IS ON
                //-------------------------
                if isAudioOpen {
                    if nHour >= 8 && nHour <= 20 {
                        availableHour =  AvailableHour(hour: nHour, hasSound: true)
                    }
                        // silence hours 0 , 2 , 4 , 6 , 22
                    else {
                        availableHour =  AvailableHour(hour: nHour, hasSound: false)
                    }
                    availableHoursDictArr.insert(availableHour, atIndex: index)
                }
                    //----------------
                    // AUDIO IS OFF
                    //----------------
                else {
                    availableHour =  AvailableHour(hour: nHour, hasSound: false)
                    availableHoursDictArr.insert(availableHour, atIndex: index)
                }
            }
            return availableHoursDictArr
            
        case .freq_8 :
            //return [0,3,6,9,12,15,18,21]
            for index in 0...7 {
                let nHour = notifyHoursArr[index]
                var availableHour :  AvailableHour
                //-------------------------
                // AUDIO IS ON
                //-------------------------
                if isAudioOpen {
                    if nHour >= 9 && nHour <= 18 {
                        availableHour =  AvailableHour(hour: nHour, hasSound: true)
                    }
                        // silence hours 0 , 3 , 6 , 21
                    else {
                        availableHour =  AvailableHour(hour: nHour, hasSound: false)
                    }
                    availableHoursDictArr.insert(availableHour, atIndex: index)
                }
                    
                    //----------------
                    // AUDIO IS OFF
                    //----------------
                else {
                    availableHour =  AvailableHour(hour: nHour, hasSound: false)
                    availableHoursDictArr.insert(availableHour, atIndex: index)
                }
                
            }
            return availableHoursDictArr
            
        case .freq_6 :
            //[0,4,8,12,16,20]
            for index in 0...5 {
                let nHour = notifyHoursArr[index]
                var availableHour :  AvailableHour
                //-------------------------
                // AUDIO IS ON
                //-------------------------
                if isAudioOpen {
                    if nHour >= 8 && nHour <= 20 {
                        availableHour =  AvailableHour(hour: nHour, hasSound: true)
                    }
                        // silence hours 0 , 4
                    else {
                        availableHour =  AvailableHour(hour: nHour, hasSound: false)
                    }
                    availableHoursDictArr.insert(availableHour, atIndex: index)
                }
                    
                    //----------------
                    // AUDIO IS OFF
                    //----------------
                else {
                    availableHour =  AvailableHour(hour: nHour, hasSound: false)
                    availableHoursDictArr.insert(availableHour, atIndex: index)
                }
                
            }
            return availableHoursDictArr
            
        case .freq_4 :
            // [8,11,14,17]
            for index in 0...3 {
                let nHour = notifyHoursArr[index]
                var availableHour :  AvailableHour
                //-------------------------
                // AUDIO IS ON
                //-------------------------
                if isAudioOpen {
                    availableHour =  AvailableHour(hour: nHour, hasSound: true)
                    availableHoursDictArr.insert(availableHour, atIndex: index)
                }
                    //----------------
                    // AUDIO IS OFF
                    //----------------
                else {
                    availableHour =  AvailableHour(hour: nHour, hasSound: false)
                    availableHoursDictArr.insert(availableHour, atIndex: index)
                }
                
            }
            return availableHoursDictArr
            
        case .freq_3 :
            //[8,12,16]
            for index in 0...2 {
                let nHour = notifyHoursArr[index]
                var availableHour :  AvailableHour
                //-------------------------
                // AUDIO IS ON
                //-------------------------
                if isAudioOpen {
                    availableHour =  AvailableHour(hour: nHour, hasSound: true)
                    availableHoursDictArr.insert(availableHour, atIndex: index)
                }
                    //----------------
                    // AUDIO IS OFF
                    //----------------
                else {
                    availableHour =  AvailableHour(hour: nHour, hasSound: false)
                    availableHoursDictArr.insert(availableHour, atIndex: index)
                }
                
            }
            return availableHoursDictArr
            
        case .freq_2 :
            // [8,18]
            for index in 0...1 {
                let nHour = notifyHoursArr[index]
                var availableHour :  AvailableHour
                //-------------------------
                // AUDIO IS ON
                //-------------------------
                if isAudioOpen {
                    availableHour =  AvailableHour(hour: nHour, hasSound: true)
                    availableHoursDictArr.insert(availableHour, atIndex: index)
                }
                    //----------------
                    // AUDIO IS OFF
                    //----------------
                else {
                    availableHour =  AvailableHour(hour: nHour, hasSound: false)
                    availableHoursDictArr.insert(availableHour, atIndex: index)
                }
                
            }
            return availableHoursDictArr
            
        case .freq_1 :
            let nHour = notifyHoursArr[0]
            //------------------------
            // AUDIO IS ON
            //-------------------------
            if isAudioOpen {
                let  availableHour =  AvailableHour(hour: nHour, hasSound: true)
                availableHoursDictArr.insert(availableHour, atIndex: 0)
            }
                //----------------
                // AUDIO IS OFF
                //----------------
            else {
                let availableHour =  AvailableHour(hour: nHour, hasSound: false)
                availableHoursDictArr.insert(availableHour, atIndex: 0)
            }
            return availableHoursDictArr
            
            
        }
        
            }
    
    //# MARK: - Class Variables / Members / Constructors
    static let sharedInstance : NotificationUtil = NotificationUtil()
    private let mLogTag = "NotificationUtil "
    var notifications : [UILocalNotification]!
    var  count = 0
    var start = 1
    var timer : NSTimer!
    var isFinish = false
    
    private init() {
    }
    
}

    
    //# MARK: - Enums
    enum NotificationActionIdentifier : String{
        
        case sound
    }
    
    enum NotificationCategoryIdentifier : String{
        
        case wordlyScheduledNotify
        case wordlyInstantNotify
    }
    
    //# MARK: - Structs
    struct AvailableHour {
        var hour : Int = 0
        var isSentToday : Bool = false
        var hasSound : Bool = false
        
        init() {}
        
        init(hour :Int, hasSound : Bool) {
            self.hour = hour
            self.hasSound = hasSound }
        
        init(hour :Int, isSentToday : Bool ,hasSound : Bool) {
            self.hour = hour
            self.isSentToday = isSentToday
            self.hasSound = hasSound }
        
    }
    
    /*
     
     // MARK Notifications :
     //send notification with scheduled time
     private func setNotificationStartingDate(hour : Int, minute : Int) -> (NSDate?, timeZone: NSTimeZone?) {
     
     guard    hour <= 23 && hour >= 0  else {
     debugPrint( mLogTag + "hour parameter is not valid.")
     return ( nil , nil )
     }
     guard    minute <= 59 && minute >= 0  else {
     debugPrint( mLogTag + "minute parameter is not valid.")
     return  ( nil, nil )
     }
     let calendar : NSCalendar = NSCalendar.currentCalendar()
     var dateStartingNotification = NSDate()
     
     var startingComponents = calendar.components([.Month, .Day, .Hour, .Minute], fromDate:dateStartingNotification )
     
     // TEST : test date
     let d = calendar.dateFromComponents(startingComponents)
     let dateformatter = NSDateFormatter()
     dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
     dateformatter.timeStyle = NSDateFormatterStyle.ShortStyle
     let strDate = dateformatter.stringFromDate(d!)
     debugPrint(mLogTag + " current date  \(strDate) ")
     //------------------------------------------------------------------------t
     
     if startingComponents.hour >= hour{
     dateStartingNotification = dateStartingNotification.dateByAddingTimeInterval(86400)
     startingComponents = calendar.components([.Month, .Day, .Hour, .Minute], fromDate:dateStartingNotification)
     }
     startingComponents.hour = hour
     startingComponents.minute = minute
     dateStartingNotification = calendar.dateFromComponents(startingComponents)!
     return (dateStartingNotification, calendar.timeZone)
     
     
     }
     
     //notification
     func pushNotification(hour : Int, minute : Int, isAudio : Bool, notificationBody : String, frequency : Frequency)
     {
     let startingDate = setNotificationStartingDate(hour, minute: minute).0
     if startingDate != nil  {
     let timeZone = setNotificationStartingDate(hour, minute: minute).timeZone
     let localNotification = UILocalNotification()
     localNotification.repeatInterval = .Day
     localNotification.fireDate = startingDate
     localNotification.category = NotificationCategoryIdentifier.wordlyScheduledNotify.rawValue
     localNotification.alertBody =  " Alert c Body " + notificationBody
     if (isAudio) {
     localNotification.soundName = UILocalNotificationDefaultSoundName
     }
     localNotification.timeZone  = timeZone
     UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
     
     }
     }
     
     
     
     */
    
    
    
    /*
     
     // MARK : Actions
     //make sound action
     func makeSoundAction() -> [UIMutableUserNotificationAction] {
     
     let action = UIMutableUserNotificationAction()
     action.title = "🔊 Dinle"
     action.identifier = NotificationActionIdentifier.sound.rawValue
     action.destructive = false
     action.authenticationRequired = false
     action.activationMode = .Background
     
     return [action]
     }
     
     //MARK : Categories
     //set scheduled category
     func makeScheduledCategory() -> UIMutableUserNotificationCategory {
     let category = UIMutableUserNotificationCategory()
     category.identifier = NotificationCategoryIdentifier.wordlyScheduledNotify.rawValue
     category.setActions(makeSoundAction(), forContext: .Default)
     return category
     }
     
     */
