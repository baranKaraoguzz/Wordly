//
//  AppDelegate.swift
//  Wordly
//
//  Created by eposta developer on 27/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Fabric
import TwitterKit
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let mLogTag = "AppDelegate "
    let notificationUtil = NotificationUtil.sharedInstance
    let textToSpeech = TextToSpeech.sharedInstance
    var notificationBeginningState : NotifyChangedState!
    var notificationFinalState : NotifyChangedState!
    var isChanged : Bool = false
    
    //# MARK: - Notifications Launch
    //use this mmethod for notifications
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        debugPrint("willFinishLaunchingWithOptions()")
        
    //  let width    = AppManager.sharedInstance.widthOfScreen
      //  debugPrint("width : \(width)")
        
        application.registerUserNotificationSettings(
            UIUserNotificationSettings(
                forTypes:[.Alert, .Badge , .Sound] ,
                categories: nil
            ))
        return true
    }
    
    //# MARK: - Facebook - Twitter Launch
    // use this method facebook , twitter sdks
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //for checking network
        
        Fabric.with([Twitter.self, Crashlytics.self])
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        // Init GAI.
        let tracker = GAI.sharedInstance()
        //Add Publisher Track ID
        tracker.trackerWithTrackingId("UA-75916035-4")
        tracker.trackUncaughtExceptions = true
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        return true
    }
    //# MARK: Others
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        debugPrint(mLogTag + "notification identiefier : \(identifier)")
        completionHandler()
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // Point for handling the local notification when the app is open.
        // Showing reminder details in an alertview
        debugPrint("didReceiveLocalNotification()")
        if ( application.applicationState == UIApplicationState.Active)
        {
            print("Active")
            // App is foreground and notification is recieved,
            // Show a alert.
        }
        else if( application.applicationState == UIApplicationState.Background)
        {
            print("Background")
            // App is in background and notification is received,
            // You can fetch required data here don't do anything with UI.
        }
        else if( application.applicationState == UIApplicationState.Inactive)
        {
            print("Inactive")
            // App came in foreground by used clicking on notification,
            // Use userinfo for redirecting to specific view controller.
            //self.redirectToPage(notification.userInfo)
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            redirectTo()
        }
    }
    
    private func redirectTo() {
    
        let cont = BaseContoller()
        let topController = cont.topMostController()
        //let topController = self.topMostController()
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("WordControllerID") as! WordController
        topController.presentViewController(vc, animated: true, completion: nil)
    }
    
    /*
    func topMostController()-> UIViewController {
        var topController = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        while((topController?.presentedViewController) != nil){
            topController = topController?.presentedViewController
        }
        if(topController != nil){
            return topController!
        }
        else{
            return self
        }
 */
        
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        debugPrint("applicationWillResignActive()")
      /*
        if self.notificationFinalState != nil {
            let isNotificationChanged : Bool = self.notificationFinalState.isChanged(self.notificationBeginningState)
            if isNotificationChanged {
                debugPrint(mLogTag + "notification is changed.")
                self.isChanged = true
                let isMobilState = self.notificationFinalState.getNotificationState()
                switch isMobilState {
                case .mobil_Off:
                    debugPrint(mLogTag + "cancel all notifications")
                    UIApplication.sharedApplication().cancelAllLocalNotifications()
                case .mobilOn_AudioOff:
                    UIApplication.sharedApplication().cancelAllLocalNotifications()
                    let user = readLastuserData()
                    let frequency = user.notificationFrequency
                    //#TODO: INVESTIGATE
                    UserPrefence.setNotificationPrepared(true)
                    let   nu   = NotificationUtil.sharedInstance
                    nu.sendNotifications(frequency  , isAudioOpen: false)
                case .mobilOn_AudioOn :
                     UIApplication.sharedApplication().cancelAllLocalNotifications()
                    let user = readLastuserData()
                    let frequency = user.notificationFrequency
                    //#TODO: INVESTIGATE
                    UserPrefence.setNotificationPrepared(true)
                    let   nu   = NotificationUtil.sharedInstance
                    nu.sendNotifications(frequency  , isAudioOpen: true)
                                    }
            }
            else {
                debugPrint(mLogTag + "notification is not changed.")
                self.isChanged = false
            }
        } */
 }
    
    //# MARK: - Watch / Debug Notifications
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        debugPrint("applicationDidEnterBackground()")
        /*
         let count = application.scheduledLocalNotifications?.count
         let desc =  application.scheduledLocalNotifications?.description
         debugPrint("count : \(count) desc : \(desc)" )
         let first = application.scheduledLocalNotifications?.first
         
         let date =  first?.fireDate
         let dateformatter = NSDateFormatter()
         dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
         dateformatter.timeStyle = NSDateFormatterStyle.ShortStyle
         if date != nil {
         let now = dateformatter.stringFromDate(date!)
         debugPrint("\(first?.alertTitle)  - \(now)")
         
         }*/
            }
    //# MARK:
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        debugPrint("applicationWillEnterForeground()")/*
        if self.notificationBeginningState != nil {
            if isChanged {
                let user = readLastuserData()
                self.notificationBeginningState = NotifyChangedState(isMobilOpen: user.isMobileNotificationOpen, isAudioOpen: user.isAudioNotificationOpen,frequency:  user.notificationFrequency)
                self.isChanged = false
            }
        }*/
            }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        debugPrint("applicationDidBecomeActive()")
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        debugPrint("applicationWillTerminate()")
    }
    
    
    //-------------------------------------------------//
    //  #MARK: - methods
    //-------------------------------------------------//
    private func readLastuserData() -> RegisteredUser {
        var lastLoginUser = RegisteredUser()
        let lastUserType =  UserPrefence.readLastUserType()
        switch lastUserType {
        case .mail:
            lastLoginUser = UserPrefence.readMailUserData()
            return lastLoginUser
        case .facebook:
            lastLoginUser = UserPrefence.readFacebookUserData()
            return lastLoginUser
        case .twitter:
            lastLoginUser = UserPrefence.readTwitterUserData()
            return lastLoginUser
        default:
            //#TODO: - ?? HANDLE
            debugPrint(mLogTag + "empty user")
            return lastLoginUser
        }
    }
    
}

