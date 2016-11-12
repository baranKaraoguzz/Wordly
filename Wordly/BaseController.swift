//
//  BaseController.swift
//  Wordly
//
//  Created by eposta developer on 27/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import UIKit

class BaseContoller : UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //# MARK: - Show Alert
    func showBasicAlert(infoText : String){
        let alert = UIAlertController(title: infoText, message: "", preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    
    }
 
    func showBasicAlertWithAction(infoText : String, action:(UIAlertAction) -> ()){
        let alert = UIAlertController(title: infoText, message: "", preferredStyle: UIAlertControllerStyle.Alert)
       let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: action)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //# MARK: - Progress
    func showProgressConnecting() {
    EZLoadingActivity.show(WarningUtil.connecting, disableUI: false )
        
    }
    func showProgressUpdating() {
   EZLoadingActivity.show(WarningUtil.updating, disableUI: false)
    
    }
    func stopPogress() {
    EZLoadingActivity.hide()
    }
    
    func cancelAllNotifications() {
        debugPrint(mLogTag + "cancelAllNotifications")
     UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    //# MARK: - Update Notifications
    func updateNotificationsWithFrequency(){
        debugPrint(mLogTag + " update frequency notifications")
       
        let user = readLastuserData()
        UserPrefence.setNotificationPrepared(true)
        let frequency = user.notificationFrequency
        let isAudioOpen = user.isAudioNotificationOpen
        let nu = NotificationUtil.sharedInstance
        nu.sendNotifications(frequency, isAudioOpen: isAudioOpen)
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
    
    //# MARK: - Call upmost view
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
        
    }

     //# MARK: - Check Connection
    func hasConnectivity() -> Bool {
        do {
            let reachability: Reachability = try Reachability.reachabilityForInternetConnection()
            let networkStatus: Int = reachability.currentReachabilityStatus.hashValue
            debugPrint(mLogTag + "return hasConnectivity()")
            return (networkStatus != 0)
        }
        catch {
            // Handle error however you please
             debugPrint(mLogTag + "error hasConnectivity()")
            return false
        }
    }
    
    //# MARK: - Class Variables / Members
    private final let mLogTag : String = "BaseContoller "
   
    
}