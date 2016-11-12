//
//  SettingController.swift
//  Wordly
//
//  Created by eposta developer on 30/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import UIKit

class SettingController : BaseContoller, SettingDelegate, ErrorDelegate, DownloaderDelegate {
    
    //# MARK: - viewDidLoad()
    override func viewDidLoad() {
        debugPrint(logTag + "viewDidLoad()")
        super.viewDidLoad()
        //set delegate
        self.settingService.errorDelegate = self
        self.settingService.settingDelegate = self
        self.downloader.downloaderDelegate = self
        //read last login user
        readLastuserData()
     
    }
    
    
    //# MARK: - Service Delegate Methods
    //--------------------------------------------//
    //  SERVICE DELEGATE METHODS BROUGHT DATA
    //--------------------------------------------//
    
    // TAKES RESPONSE FROM SERVICE
   
    /*
     func getChangePasswordModel(model: CommonModelResponse) {
     debugPrint(logTag + "response :  \(model.message)")
     dispatch_async(dispatch_get_main_queue()) {
     self.view.makeToast(message : model.message)
     }
     }
     */
    func getDownloadedWordsDict(modelDict: [EntityName:[WordTableModel]] ){
        debugPrint(logTag + "Downloaed dict is here. \(modelDict.count) levels.")
        let modelBeginner = modelDict[.beginner]
        let modelIntermediate = modelDict[.intermediate]
        let modelAdvanced = modelDict[.advanced]
        debugPrint("TEST 37. = \(modelBeginner![36]) *** 67. =  \(modelBeginner![66])")
        debugPrint("TEST 2. = \(modelIntermediate![1]) *** 11. =  \(modelIntermediate![10])")
        debugPrint("TEST 17. = \(modelAdvanced![16]) *** 41. =  \(modelAdvanced![40])")
        
        
        //save
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            // do some task
            debugPrint(self.logTag + "word lists is being written on database.")
            
            DatabaseUtil.saveEntityData(.beginner, modelList: modelBeginner!)
            DatabaseUtil.saveEntityData(.intermediate, modelList: modelIntermediate!)
            DatabaseUtil.saveEntityData(.advanced, modelList: modelAdvanced!)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                debugPrint("DISPATCH_QUEUE save")
            })
        });
        
        debugPrint(logTag + " model db version \(self.modelDBVersion)" )
        //set new version
        UserPrefence.setVersionChecked(true)
        UserPrefence.setVersion(self.modelDBVersion)
        
        // stop progress
        stopPogress()
        
        
        //call service from here
        var model = ChangeLevelSend()
        model.newLevel = self.selectedLevel
        model.id = self.modelUserId
        model.userType = self.modelUserType
        model.versionCode = "0"
        model.dbVersion =  self.modelDBVersion
        self.settingService.dispatchChangeLevelNotification(model)
        //show connecting
        showProgressConnecting()
    }
    
    func getChangeEmailModel(model: CommonVersionModelResponse) {
        debugPrint(logTag + "response :  \(model.message)")
        self.lastLoginUser.notificationMail = self.emailAdd
        //User data has been just updated in send-data-service methods
        //save user data
        writeUserData()
        UIView.animateWithDuration(0.3, animations: {
            self.lblEmail.text = self.emailAdd
            self.view.layoutIfNeeded()
        })
        //stop progress
        stopPogress()
         }
    
    func getChangeLevelNotifictionModel(model: CommonVersionModelResponse) {
        debugPrint(logTag + "response :  \(model.message)")
    let isVersionChecked = UserPrefence.isVersionChecked()
        
        //the version has been checked before.
        if isVersionChecked {
            //wordlist is not updated. download new file
            if model.isUpdated == FinalString.FALSE {
                debugPrint(logTag + " database version is not updated.")
                //stop progress
                stopPogress()
                //show alert view
                let action = {(action: UIAlertAction!) in
                //download word list
                self.showProgressUpdating()
                self.modelDBVersion = model.databaseVersion
                self.downloader.downloadAllWordList()
                    
                }
                showBasicAlertWithAction( WarningUtil.updateWordList, action: action)
            }
            //wordlist is up-to-date.
            else {
                debugPrint(logTag + " database version is up-to-date.")
                //stop progress
                stopPogress()
                dispatch_async(dispatch_get_main_queue()) {
                 self.view.makeToast(message : model.message)
                 }
                //update last login user and save
                self.lastLoginUser.userLevel = UserLevel.init(level: String(self.selectedLevel))
                writeUserData()
                let trLevel = UserLevel.getLevelTR(String(self.selectedLevel))
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.layoutIfNeeded()
                    UIView.animateWithDuration(0.3, animations: {
                        self.lblLevelTr.text = trLevel
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
        //the version has not been checked before.
        else {
        
             // wordlist is not updated. download new list.
            if model.isUpdated == FinalString.FALSE {
            debugPrint(logTag + "2 database version is not updated.")
             //stop progress
             stopPogress()
             //show alert view
                let action = {(action : UIAlertAction!) in
                //download word list
                self.showProgressUpdating()
                self.modelDBVersion = model.databaseVersion
                self.downloader.downloadAllWordList()
                }
               showBasicAlertWithAction( WarningUtil.updateWordList, action: action)
            }
            // wordlist is up-to-date
            else {
                debugPrint(logTag + "2 database version is up-to-date.")
                stopPogress()
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.makeToast(message : model.message)
                }
                UserPrefence.setVersionChecked(true)
                UserPrefence.setVersion(model.databaseVersion)
                //update last login user and save
                self.lastLoginUser.userLevel = UserLevel.init(level: String(self.selectedLevel))
                writeUserData()
                let trLevel = UserLevel.getLevelTR(String(self.selectedLevel))
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.layoutIfNeeded()
                    UIView.animateWithDuration(0.3, animations: {
                        self.lblLevelTr.text = trLevel
                        self.view.layoutIfNeeded()
                    })
                }
                        }
        }
              }
    
    func  getChangeMailNotificationModel(model: CommonVersionModelResponse) {
        //
        debugPrint(logTag + "response :  \(model.message)")
        dispatch_async(dispatch_get_main_queue()) {
            self.view.makeToast(message : model.message)
        }
        //stop prgress
        stopPogress()
        setSwicthSelectableState(self.switchEmail, state: true)
        //update user database data
        readLastuserData()
        if self.switchEmail.on {
            self.lastLoginUser.isEmailNotificationOpen = true
            //update user on the  database
            writeUserData()
        }
        else {
            self.lastLoginUser.isEmailNotificationOpen = false
            writeUserData()
        }
    }
    
    
    func getChangeNotificationFrequencyModel(model: CommonModelResponse) {
        debugPrint(logTag + "response :  \(model.message)")
        //update user.
        readLastuserData()
        let xTimesADay : String = "Günde \(self.notificationFrequency) Kez"
        self.lastLoginUser.notificationFrequency = Frequency(rawValue: String(self.notificationFrequency))
        writeUserData()
        dispatch_async(dispatch_get_main_queue()) {
            self.view.layoutIfNeeded()
            UIView.animateWithDuration(0.3, animations: {
                self.lblDayTimes.text = xTimesADay
                
                self.view.layoutIfNeeded()
            })
        }
        //# TODO: Check
        // updateNotificationState()
        //---------------------------
        cancelAllNotifications()
        updateNotificationsWithFrequency()
        //delaying time one more second is needed because of pushing notification time may lasts 1.2 seconds
        //progress prevents the user interactivity with the screen.
        let triggerTime = (Int64(NSEC_PER_SEC) * 1)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
           self.stopPogress()
        })
        //   UserPrefence.setNotificationPrepared(true)
        debugPrint("LAST READ LAST LAS LA L")
        //  - #TODO: - FOR TEST PURPOSE
        readLastuserData()
    }
    
    func getChangeMobileNotificationModel(model: CommonModelResponse) {
        //
        debugPrint(logTag + "response :  \(model.message)")
        dispatch_async(dispatch_get_main_queue()) {
        //    self.view.makeToast(message : model.message)
        }
        //if mobile is off make audio is off.
        readLastuserData()
        if  !self.switchMobile.on {
            //stop
            stopPogress()
            cancelAllNotifications()
            self.lastLoginUser.isMobileNotificationOpen = false
            writeUserData()
            self.setSwicthSelectableState(self.switchMobile, state: true)
            self.setSwicthSelectableState(self.switchAudio, state: false)
            dispatch_async(dispatch_get_main_queue()) {
                self.view.layoutIfNeeded()
                UIView.animateWithDuration(0.1, animations: {
                    debugPrint(self.logTag + "mobbile notification is OFF, audio is OFF.")
                    self.switchAudio.setOn(false, animated: false)
                    self.switchAudio.enabled = false
                })
            }
            if self.switchAudio.on {
                sendChangeAudioNotificationModelToService(false)
            }
        }
            // if mobile is on ,audio may be selected again.
        else {
            //update notifications
            updateNotificationsWithFrequency()
            self.lastLoginUser.isMobileNotificationOpen = true
            writeUserData()
            setSwicthSelectableState(self.switchMobile, state: true)
            setSwicthSelectableState(self.switchAudio, state: true)
            
            let triggerTime = (Int64(NSEC_PER_SEC) * 1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.stopPogress()
                
            })
        }
        
        //update appdelagate notification state
    //    updateNotificationState()
        
    }
    
    func getChangeAudioNotificationModel(model: CommonModelResponse) {
        //
        debugPrint(logTag + "response :  \(model.message)")
        dispatch_async(dispatch_get_main_queue()) {
         //   self.view.makeToast(message : model.message)
        }
        setSwicthSelectableState(self.switchAudio, state: true)
        //User is Updated
        readLastuserData()
        if self.switchAudio.on {
            self.lastLoginUser.isAudioNotificationOpen = true
            writeUserData()
            cancelAllNotifications()
            updateNotificationsWithFrequency()
            let triggerTime = (Int64(NSEC_PER_SEC) * 1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.stopPogress()
                
            })
        }
        else {
            self.lastLoginUser.isAudioNotificationOpen = false
            writeUserData()
            cancelAllNotifications()
            updateNotificationsWithFrequency()
            let triggerTime = (Int64(NSEC_PER_SEC) * 1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.stopPogress()
                
            })
        }
        //update appdelagate notification state
        //updateNotificationState()
        //switch
        if !self.switchMobile.on {
            self.switchAudio.enabled = false
        }
    }
    
    func onError(errorMessage: String) {
         //stop progress
        stopPogress()
        debugPrint(logTag + "Setting Controller Error Message \(errorMessage)")
        dispatch_async(dispatch_get_main_queue()) {
            self.view.makeToast(message : errorMessage)
        }
        // if switch state has been changed as true
        // find switch type and convert it default state
        if isSwitchChanged {
            //back to normal state
            setSwitchStateNormal(self.selectedSwitchType)
        }
    }
    
    //# MARK: - Send Data To Service
    //SEND MODEL TO SERVICE
    
    private func sendEmailModelToService() {
        let isNetAvailable =  hasConnectivity()
        if isNetAvailable {
            debugPrint(logTag + "Net Is Available.")
            //last user is updated.
            readLastuserData()
            var model = ChangeEmailSend()
            // #TODO: - VERSION
            model.dbVersion = "20161212"
            model.versionCode = "0"
            model.id = self.lastLoginUser.id
            model.newMail = self.emailAdd
            model.userType = self.lastLoginUser.userType.rawValue
            self.settingService.dispatchChangeEmail(model)
            //show progress
            showProgressConnecting()
        }
            // net is not available
        else {
            debugPrint(logTag + "Net Is Not Available.")
            dispatch_async(dispatch_get_main_queue()) {
                self.view.makeToast(message : WarningUtil.connectInternet)
            }
        }
    }
    
    private func sendSelectLevelModelToService() {
        
        var model = ChangeLevelSend()
        model.newLevel = self.selectedLevel
        //last user is read.
        readLastuserData()
        model.id = self.lastLoginUser.id
        self.modelUserId = self.lastLoginUser.id
        model.userType = self.lastLoginUser.userType.rawValue
        self.modelUserType = self.lastLoginUser.userType.rawValue
        var databaseVersion = ""
        // if version is checked, read from user defaults
        // otherwise read from file.
        let isChecked =  UserPrefence.isVersionChecked()
        if isChecked {
            databaseVersion =  UserPrefence.getVersion()
            debugPrint(logTag + "database version is read as \(databaseVersion) from user defaults.")
            debugPrint("TEST ??? " + databaseVersion )
        }else {
            databaseVersion = FileUtil.readDBVersion()
            debugPrint(logTag + "database version is read as \(databaseVersion) from file.")
            debugPrint("TEST ??? " + databaseVersion )
        }
        
        //#TODO : CHANGE
        model.dbVersion = (databaseVersion != "") ? databaseVersion : "0"
        //--- --------- --------- version code   -------------- ----------- ------------
        model.versionCode = "0"
        self.settingService.dispatchChangeLevelNotification(model)
        //show progress
        showProgressConnecting()
    }
    
    
    private func sendChangeEmailNotificationModelToServivce(isOpen : Bool){
        // update user data
        readLastuserData()
        var model = ChangeMailNotifySend()
        model.id = self.lastLoginUser.id
        model.dbVersion = "0"
        model.isOpen = (isOpen) ? FinalString.TRUE : FinalString.FALSE
        model.userType = self.lastLoginUser.userType.rawValue
        self.settingService.dispatchChangeMailNotification(model)
        //show progress
        showProgressConnecting()
    }
    
    private func sendChangeMobileNotificationModelToService(isOpen: Bool)
    {
        var model = ChangeMobileNotifySend()
        model.id = self.lastLoginUser.id
        model.isOpen =  (isOpen) ? FinalString.TRUE : FinalString.FALSE
        model.userType = self.lastLoginUser.userType.rawValue
        self.settingService.dispatchChangeMobileNotification(model)
        //start progress
        showProgressConnecting()
    }
    
    private func sendChangeAudioNotificationModelToService(isOpen : Bool){
        var model = ChangeAudioNotifySend()
        model.id = self.lastLoginUser.id
        model.isOpen =  (isOpen) ? FinalString.TRUE : FinalString.FALSE
        model.userType = self.lastLoginUser.userType.rawValue
        self.settingService.dispatchChangeAudioNotification(model)
        //start progress
        showProgressConnecting()
    }
    
    
    private func sendChangeFrequencyModelToService(){
        
        debugPrint(logTag + " frequency model to service.")
        //control side pages
        self.willNotificationStatusComingSidePage = false
        var model = ChangeNotifyFrequencySend()
        model.count = self.notificationFrequency
        readLastuserData()
        model.id = self.lastLoginUser.id
        model.userType = self.lastLoginUser.userType.rawValue
        self.settingService.dispatchChangeNotifyFrequencyData(model)
        showProgressConnecting()
    }
    
    //# MARK: - Send Data ChangePassword Controller
    //------------------------------------------
    //  SEND DATA TO CONTROLLER
    //------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
       if (segue.identifier == self.settingToLoginControllerSegueIdentifier)
        {
            if self.lastLoginUser.userType == UserType.facebook
            {
                debugPrint(logTag + "facebook user is logout.")
                let destinationLoginController = segue.destinationViewController as! LoginController
                destinationLoginController.isFacebookLogOut = true
            }
            if self.lastLoginUser.userType == UserType.undefined {
                debugPrint(logTag + "undefined user is sent to the login controller.")
                let destinationLoginController = segue.destinationViewController as! LoginController
                destinationLoginController.isFacebookLogOut = true
                        }
                }
        /*
       else   if (segue.identifier == self.settingToChangePassControllerSegueIdentifier) {
        //Checking identifier is crucial as there might be multiple
        // segues attached to same view
        let destinationChangePassCont = segue.destinationViewController as! ChangePassController;
        destinationChangePassCont.mailUserID = lastLoginUser.id
        }
 */
        
    }
    
    
    
    //-------------------------------------------------//
    //  #MARK: - User Preference & Database Processes
    //-------------------------------------------------//
    private func readLastuserData() {
        
        let lastUserType =  UserPrefence.readLastUserType()
        switch lastUserType {
        case .mail:
            self.lastLoginUser = UserPrefence.readMailUserData()
        case .facebook:
            self.lastLoginUser = UserPrefence.readFacebookUserData()
        case .twitter:
            self.lastLoginUser = UserPrefence.readTwitterUserData()
            
        default:
            debugPrint(logTag + "User login problem.")
           //send user to login controller, if there may happen reading user type.
            self.lastLoginUser = RegisteredUser()
            self.lastLoginUser.userType = UserType.undefined
            self.performSegueWithIdentifier(self.settingToLoginControllerSegueIdentifier, sender: nil)
                    }
    }
    /*
     private func writeLastUserData() {
     UserPrefence.writeLastUserType(lastLoginUser.userType)
     }
     */
    
    private func writeUserData(){
        let type = UserPrefence.readLastUserType()
        switch type {
        case .mail:
            UserPrefence.saveMailUserData(self.lastLoginUser)
        case .twitter:
            UserPrefence.saveTwitterUserData(self.lastLoginUser)
        case .facebook:
            UserPrefence.saveFacebookUserData(self.lastLoginUser)
        default:
            // #TODO: - HANDLE??
        debugPrint(logTag + "Error Whilw Reading User Type & Writing User Data ")
            return
        }
        
    }
    /* 
     private func updateNotificationState() {
        //update appdelagate notification state
        self.appDelegate.notificationFinalState = NotifyChangedState(isMobilOpen: self.lastLoginUser.isMobileNotificationOpen, isAudioOpen: self.lastLoginUser.isAudioNotificationOpen,frequency:  lastLoginUser.notificationFrequency)
    }
    */
    //# MARK: - Button Actions
    //--------------------------------------------//
    //  BUTTON & VIEW ACTIONS
    //--------------------------------------------//
    
    // image back arrow tapped
    func viewImgBackArrowBoxTapped(img: AnyObject){
        debugPrint(logTag + "image back arrow is tapped." )
        self.performSegueWithIdentifier(self.settingToWordControllerSegueIdentifier, sender: nil)
    }
    /*
    func lblPasswordStarTapped(sender:UILabel){
        debugPrint(logTag + "Label Password Star is Tapped")
        self.performSegueWithIdentifier(self.settingToChangePassControllerSegueIdentifier, sender: nil)
        
    }
 */
    
    @IBAction func switchEmailTapped(sender: UISwitch) {
        debugPrint( logTag + "Switch Email - value changed.")
        let isNetAvailable = hasConnectivity()
        //net is available.
        if isNetAvailable {
            debugPrint(logTag + "Net Is Available.")
            
            if switchEmail.on {
                debugPrint( logTag + "Switch Email - ON.")
                sendChangeEmailNotificationModelToServivce(true)
                setSwicthSelectableState(self.switchEmail, state: false)
                setSwitchStateChanged(SwitchType.email)
            }
            else {
                debugPrint( logTag + "Switch Email - OFF")
                sendChangeEmailNotificationModelToServivce(false)
                setSwicthSelectableState(self.switchEmail, state: false)
                setSwitchStateChanged(SwitchType.email)
            }
        }
            //net is not available.
        else {
            debugPrint(logTag + "Net Is Not Available.")
            dispatch_async(dispatch_get_main_queue()) {
                UIView.animateWithDuration(0.2, animations: {
                    if self.switchEmail.on {
                        self.switchEmail.setOn(false, animated: false)
                    }
                    else {
                        self.switchEmail.setOn(true, animated: false)
                    }
                    
                    self.view.layoutIfNeeded()
                })
                self.view.makeToast(message : WarningUtil.connectInternet)
            }
        }
    }
    
    @IBAction func switchMobileTapped(sender: UISwitch) {
        debugPrint( logTag + "Switch Mobile - value changed.")
        let isNetAvailable = hasConnectivity()
        //net is available.
        if isNetAvailable {
            debugPrint(logTag + "Net Is Available.")
            
            
            if switchMobile.on {
                debugPrint( logTag + "Switch Mobile - ON.")
                sendChangeMobileNotificationModelToService(true)
                setSwicthSelectableState(self.switchMobile,state: false)
                setSwitchStateChanged(SwitchType.mobile)
            }
            else {
                debugPrint( logTag + "Switch Mobile - OFF")
                sendChangeMobileNotificationModelToService(false)
                setSwicthSelectableState(self.switchMobile, state: false)
                setSwitchStateChanged(SwitchType.mobile)
            }
        }
            //net is not available
        else {
            debugPrint(logTag + "Net Is Not Available.")
            dispatch_async(dispatch_get_main_queue()) {
                UIView.animateWithDuration(0.2, animations: {
                    if self.switchMobile.on {
                        self.switchMobile.setOn(false, animated: false)
                    }
                    else {
                        self.switchMobile.setOn(true, animated: false)
                    }
                    
                    self.view.layoutIfNeeded()
                })
                self.view.makeToast(message : WarningUtil.connectInternet)
            }
        }
    }
    
    
    @IBAction func switchAudioTapped(sender: UISwitch) {
        debugPrint( logTag + "Switch Audio - value changed.")
        let isNetAvailable = hasConnectivity()
        //net is available.
        if isNetAvailable {
            debugPrint(logTag + "Net Is Available.")
            if switchAudio.on {
                debugPrint( logTag + "Switch Audio - ON.")
                sendChangeAudioNotificationModelToService(true)
                setSwicthSelectableState(self.switchAudio, state: false)
                setSwitchStateChanged(SwitchType.audio)
            }
            else {
                debugPrint( logTag + "Switch Audio - OFF")
                sendChangeAudioNotificationModelToService(false)
                setSwicthSelectableState(self.switchAudio, state: false)
                setSwitchStateChanged(SwitchType.audio)
            }
        }
        else {
            debugPrint(logTag + "Net Is Not Available.")
            dispatch_async(dispatch_get_main_queue()) {
                UIView.animateWithDuration(0.2, animations: {
                    if self.switchAudio.on {
                        self.switchAudio.setOn(false, animated: false)
                    }
                    else {
                        self.switchAudio.setOn(true, animated: false)
                    }
                    self.view.layoutIfNeeded()
                })
                self.view.makeToast(message : WarningUtil.connectInternet)
            }
        }
    }
    
    @IBAction func viewChangeLevelTapped(sender:AnyObject) {
        debugPrint(logTag + "View Change Level is Tapped.")
        let isNetAvailable = hasConnectivity()
        if isNetAvailable {
            debugPrint(logTag + "Net Is Available.")
            //check notification status for side pages
         
            self.performSegueWithIdentifier(self.settingToSideLevelControllerSegueIdentifier, sender: nil)
        }
        else {
            debugPrint(logTag + "Net Is Not Available.")
            dispatch_async(dispatch_get_main_queue(), {
                self.view.makeToast(message: WarningUtil.connectInternet)
            })
        }    }
    
    @IBAction func viewChangeFrequencyTapped(sender:AnyObject)
    {
        debugPrint(logTag + "View ChangeFrequency is Tapped.")
        //mobile notification is ON
        if switchMobile.on{
            debugPrint(logTag + "ChangeFrequency, mobile is ON.")
            let isNetAvailable = hasConnectivity()
            //net is available.
            if isNetAvailable {
                debugPrint(logTag + "Net Is Available.")
                //check notification status for side pages
                self.willNotificationStatusComingSidePage = true
                self.performSegueWithIdentifier(self.settingToSideFrequencyControllerSegueIdentifier, sender: nil)
            }
            //net is not available.
            else {
             debugPrint(logTag + "Net Is Not Available.")
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.makeToast(message : WarningUtil.connectInternet)
                }
            }
        }
        //mobile notification is OFF
        else {
            debugPrint(logTag + "ChangeFrequency, mobile is OFF.")
            debugPrint(WarningUtil.mobileNotificationOFF)
            dispatch_async(dispatch_get_main_queue()) {
                self.view.makeToast(message : WarningUtil.mobileNotificationOFF)
            }
            return
        }
    }
    
    
    @IBAction func lblEmailTapped(sender :UILabel){
        debugPrint(logTag + "Label Email is Tapped.")
        
        dispatch_async(dispatch_get_main_queue()) {
            self.view.layoutIfNeeded()
            UIView.animateWithDuration(0.1, animations: {
                self.stackEmailArea.removeArrangedSubview(self.lblEmailAddress)
                self.stackEmailArea.removeArrangedSubview(self.lblEmail)
                if self.txtFieldEnterEmail.isDescendantOfView(self.stackEmailArea)
                {
                    debugPrint("isDescendantOfView true")
                    self.stackEmailArea.removeArrangedSubview(self.txtFieldEnterEmail)
                }
                if self.imgTickIcon.isDescendantOfView(self.imgTickIcon){
                    self.stackEmailArea.removeArrangedSubview(self.imgTickIcon)
                }
                self.lblEmailAddress.removeFromSuperview()
                self.lblEmail.removeFromSuperview()
                self.stackEmailArea.addArrangedSubview(self.txtFieldEnterEmail)
                self.stackEmailArea.addArrangedSubview(self.imgTickIcon)
                self.stackEmailArea.distribution = UIStackViewDistribution.FillProportionally
                // self.lblEmail.hidden = true
                // self.lblEmailAddress.hidden = true
                self.txtFieldEnterEmail.hidden = false
                self.imgTickIcon.hidden = false
                self.imgTickIcon.addConstraint(self.constImgTickAspect)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func imgTickTapped(sender: UIImageView){
        debugPrint(logTag + "Image Tick is Tapped.")
        //check valid email address
        emailAdd = self.txtFieldEnterEmail.text!
        // nothing happens
        if emailAdd == "" {
            convertToNormal()
            return
        }
            // invalid email address
        else if !emailAdd.isEmail{
            debugPrint(WarningUtil.inValidEmail)
            dispatch_async(dispatch_get_main_queue()) {
                self.view.makeToast(message : WarningUtil.inValidEmail)
            }
            return
        }
            // valid email address
        else {
            self.convertToNormal()
            self.sendEmailModelToService()
            // self.lastLoginUser.notificationMail = emailAdd
            // writeLastUserData()
        }
    }
    
    func lblExitTapped(sender: AnyObject){
        
     debugPrint(logTag + "Label Exit Is Tapped.")
        let refreshAlert = UIAlertController(title: "Wordly", message: "Oturumu kapatmak istiyor musunuz?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Evet", style: .Default, handler: { (action: UIAlertAction!) in
            debugPrint(self.logTag + " Evet is selected.")
            
            //set notification as unprepeared.
            UserPrefence.setNotificationPrepared(false)
            //set user logOut 
            UserPrefence.setUserLogInStatus(false)
            //cancel all notifications
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            //
             self.performSegueWithIdentifier(self.settingToLoginControllerSegueIdentifier, sender: nil)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Hayır", style: .Cancel, handler: { (action: UIAlertAction!) in
            debugPrint(self.logTag + " Hayır is selected.")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    //convert to first state of the views
    private func convertToNormal() {
        dispatch_async(dispatch_get_main_queue()) {
            self.view.layoutIfNeeded()
            UIView.animateWithDuration(0.1, animations: {
                self.stackEmailArea.distribution = UIStackViewDistribution.FillEqually
                self.stackEmailArea.removeArrangedSubview(self.txtFieldEnterEmail)
                self.stackEmailArea.removeArrangedSubview(self.imgTickIcon)
                //clear text
                self.txtFieldEnterEmail.text = ""
                self.txtFieldEnterEmail.removeFromSuperview()
                self.imgTickIcon.removeFromSuperview()
                self.stackEmailArea.addArrangedSubview(self.lblEmailAddress)
                self.stackEmailArea.addArrangedSubview(self.lblEmail)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // #MARK: - Fill Views Data
    //-----------------------------------------
    // Fill Views Data
    //-----------------------------------------
    private func setNotificationMailText(){
        let mail = lastLoginUser.notificationMail
        self.lblEmail.text = (mail == "" ) ?  FinalString.UPDATE : mail
        
    }
    private func setLevelTrText(){
        let trLevel = UserLevel.getLevelTR(String(self.lastLoginUser.userLevel.rawValue))
       self.lblLevelTr.text = (trLevel != "" ) ? trLevel : ""
      
        
    }
    
    private func setSwitchEmailState(){
        let isOpen = (lastLoginUser.isEmailNotificationOpen == false ) ? false : true
        if isOpen {
            self.switchEmail.setOn(true, animated: false)
        }
        else {
            self.switchEmail.setOn(false, animated: false)
        }
        
    }
    private func setSwitchMobileState(){
        let isOpen = (lastLoginUser.isMobileNotificationOpen == false ) ? false : true
        if isOpen {
            self.switchMobile.setOn(true, animated: false)
        }
        else {
            self.switchMobile.setOn(false, animated: false)
        }
    }
    private func setSwitchAudioState(){
        let isMobileOpen = (lastLoginUser.isMobileNotificationOpen == false ) ? false : true
        if isMobileOpen {
            setSwicthSelectableState(self.switchAudio, state: true)
            let isOpen = (lastLoginUser.isAudioNotificationOpen == false ) ? false : true
            if isOpen {
                debugPrint(logTag + "Audio is on.")
                self.switchAudio.setOn(true, animated: false)
            }
            else {
                debugPrint(logTag + "Audio is off.")
                self.switchAudio.setOn(false, animated: false)
            }
        }
        else {
            debugPrint(logTag + "Mobile is off, so Audio is  off.")
            self.switchAudio.setOn(false, animated: false)
            dispatch_async(dispatch_get_main_queue()) {
                self.setSwicthSelectableState(self.switchAudio, state: false)
            }
        }
    }
    
    //switch view is selectable again.
    private func setSwicthSelectableState(switchView : UISwitch, state : Bool){
        self.isSwitchChanged = false
        switchView.enabled = state
    }
    
    //in case of onErrors ,
    private func setSwitchStateChanged(type: SwitchType) {
        //set default state
        self.isSwitchChanged = true
        switch type {
        case .email:
            setSwicthSelectableState(self.switchEmail, state: false)
            self.selectedSwitchType = SwitchType.email
        case .mobile:
            setSwicthSelectableState(self.switchMobile, state: false)
            self.selectedSwitchType = SwitchType.mobile
        case .audio:
            setSwicthSelectableState(self.switchAudio, state: false)
            self.selectedSwitchType = SwitchType.audio
        }
    }
    
    //in case of onErrors ,
    private func setSwitchStateNormal(type: SwitchType) {
        //set default state
        self.isSwitchChanged = false
        switch type {
        case .email:
            setSwicthSelectableState(self.switchEmail, state: true)
        case .mobile:
            setSwicthSelectableState(self.switchMobile, state: true)
        case .audio:
            setSwicthSelectableState(self.switchAudio, state: true)
        }
            }
    
    //
    private func setFrequencyText(){
        let xTimesADay : String = "Günde \(self.lastLoginUser.notificationFrequency.rawValue) Kez"
        self.lblDayTimes.text = xTimesADay
    }
    
    
    //# MARK: - Set Gesture The Views
    //---------------------------------------------
    // TAPPED
    //---------------------------------------------
    private func addTappedTo(){
        //image back arrow
        let imgBackBoxTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(SettingController.viewImgBackArrowBoxTapped(_:)))
        self.viewImgBackArrowBox.userInteractionEnabled = true
        self.viewImgBackArrowBox.addGestureRecognizer(imgBackBoxTapGestureRecognizer)
        /*
        //label pasword star
        let type = self.lastLoginUser.userType.rawValue
        if type == UserType.mail.rawValue
        {
            let lblPasswordStarTapGestureRecognizer = UITapGestureRecognizer(target:  self, action: #selector(SettingController.lblPasswordStarTapped(_:)))
            self.lblPasswordStar.userInteractionEnabled = true
            self.lblPasswordStar.addGestureRecognizer(lblPasswordStarTapGestureRecognizer)
        }
 */
        //view change level
        let viewChangeLevelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingController.viewChangeLevelTapped(_:)))
        self.viewChangeLevel.userInteractionEnabled = true
        self.viewChangeLevel.addGestureRecognizer(viewChangeLevelTapGestureRecognizer)
        //view change frequency
        let viewChangeFrequencyTapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(SettingController.viewChangeFrequencyTapped(_:)))
        self.viewChangeFrequency.userInteractionEnabled = true
        self.viewChangeFrequency.addGestureRecognizer(viewChangeFrequencyTapGestureRecognizer)
        //label email
        let lblEmailTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingController.lblEmailTapped(_:)))
        self.lblEmail.userInteractionEnabled = true
        self.lblEmail.addGestureRecognizer(lblEmailTapGestureRecognizer)
        //image tick
        let imgTickTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingController.imgTickTapped(_:)))
        self.imgTickIcon.userInteractionEnabled = true
        self.imgTickIcon.addGestureRecognizer(imgTickTapGestureRecognizer)
        let lblExitTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingController.lblExitTapped(_:)))
        self.lblExit.userInteractionEnabled = true
        self.lblExit.addGestureRecognizer(lblExitTapGestureRecognizer)
    }
    
    
    //# MARK: - Class Variables / Members
    private final let logTag : String = "SettingController "
    private final let settingToWordControllerSegueIdentifier : String = "segueSettingToWord"
   // private final let settingToChangePassControllerSegueIdentifier : String = "segueSettingToChangePass"
    private final let settingToSideFrequencyControllerSegueIdentifier: String =   "segueSettingToSideFrequency"
    private final let settingToSideLevelControllerSegueIdentifier: String =   "segueSettingToSideLevel"
    private final let settingToLoginControllerSegueIdentifier : String = "segueSettingToLogin"
    
    var selectedLevel : String = ""
    var selectedSwitchType : SwitchType!
    var isSwitchChanged = false
    //get from side frequency
    var notificationFrequency : String = ""
    var settingService : SettingService = SettingService()
    var lastLoginUser : RegisteredUser = RegisteredUser()
    var downloader = Downloader()
    
    var modelDBVersion = ""
    var modelUserId = ""
    var modelUserType = ""
    var emailAdd = ""
    var willNotificationStatusComingSidePage = false
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    private var isChanged = false
   
    
  
    @IBOutlet weak var viewImgBackArrowBox: UIView!
  //  @IBOutlet weak var lblPasswordStar: UILabel!
    @IBOutlet weak var lblDayTimes : UILabel!
    @IBOutlet weak var switchEmail: UISwitch!
    @IBOutlet weak var switchMobile: UISwitch!
    @IBOutlet weak var switchAudio: UISwitch!
    @IBOutlet weak var stackEmailArea : UIStackView!
    @IBOutlet weak var lblEmail : UILabel!
    @IBOutlet weak var lblEmailAddress: UILabel!
    @IBOutlet weak var lblLevelTr: UILabel!
    @IBOutlet weak var txtFieldEnterEmail: UITextField!
    @IBOutlet weak var imgTickIcon: UIImageView!
    @IBOutlet weak var constImgTickAspect: NSLayoutConstraint!
    @IBOutlet weak var viewChangeLevel: UIView!
    @IBOutlet weak var viewChangeFrequency: UIView!
    @IBOutlet weak var lblExit: InsetLabel!
    
    
    
    //# MARK: - Lifecycle methods
    override func viewWillAppear(animated: Bool) {
        debugPrint(logTag + "viewWillAppear()")
        //GAI
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Setting Controller")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        //set level text
        setLevelTrText()
        //set email notification text
        setNotificationMailText()
        //set notification states
        setSwitchEmailState()
        setSwitchMobileState()
        setSwitchAudioState()
        setFrequencyText()
        
      //  appDelegate.notificationBeginningState = NotifyChangedState(isMobilOpen: self.lastLoginUser.isMobileNotificationOpen, isAudioOpen: self.lastLoginUser.isAudioNotificationOpen,frequency:  lastLoginUser.notificationFrequency)
     //   appDelegate.notificationFinalState = NotifyChangedState(isMobilOpen: self.lastLoginUser.isMobileNotificationOpen, isAudioOpen: self.lastLoginUser.isAudioNotificationOpen,frequency:  lastLoginUser.notificationFrequency)
        //
        /*
        if isChanged {
            self.readLastuserData()
            appDelegate.notificationBeginningState = NotifyChangedState(isMobilOpen: self.lastLoginUser.isMobileNotificationOpen, isAudioOpen: self.lastLoginUser.isAudioNotificationOpen,frequency:  self.lastLoginUser.notificationFrequency)
            self.isChanged = false
        }*/
            }
 
    
    override func viewDidAppear(animated: Bool) {
        debugPrint(logTag + "viewDidAppear()")
        debugPrint("coming frequency : \(notificationFrequency)")
        
        if self.notificationFrequency != "" {
            self.sendChangeFrequencyModelToService()
        }
        
        debugPrint("coming level : \(self.selectedLevel)")
        if self.selectedLevel != "" {
            self.sendSelectLevelModelToService()
        }
        //add tapped to views
        addTappedTo()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        debugPrint(logTag + "viewWillDisappear()")
        
        /*
        // because of side pages
        if willNotificationStatusComingSidePage {
        debugPrint(logTag + "viewWillDisappear() is coming from side page")
        }
        //
        else {
        debugPrint(logTag + "viewWillDisappear() is coming back button ")
        let isNotificationChanged : Bool = appDelegate.notificationFinalState.isChanged(appDelegate.notificationBeginningState)
        if isNotificationChanged {
            debugPrint(logTag + "notification is changed.")
            self.isChanged = true
            let isMobilState = appDelegate.notificationFinalState.getNotificationState()
            switch isMobilState {
            case .mobil_Off:
                debugPrint(logTag + "cancel all notifications.")
                UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                UIApplication.sharedApplication().cancelAllLocalNotifications()
            case .mobilOn_AudioOff:
                self.readLastuserData()
                let frequency = lastLoginUser.notificationFrequency
                //#TODO: INVESTIGATE
                UserPrefence.setNotificationPrepared(true)
                let   nu   = NotificationUtil.sharedInstance
                nu.sendNotifications(frequency  , isAudioOpen: false)
            case .mobilOn_AudioOn :
                self.readLastuserData()
                let frequency = lastLoginUser.notificationFrequency
                //#TODO: INVESTIGATE
                UserPrefence.setNotificationPrepared(true)
                let   nu   = NotificationUtil.sharedInstance
                nu.sendNotifications(frequency  , isAudioOpen: true)
            }
        }
        else {
            debugPrint(logTag + "notification is not changed.")
        }
        }
         */
    }
    
    override func viewDidDisappear(animated: Bool) {
        debugPrint(logTag + "viewDidDisappear()")
    }
    
    override func viewWillLayoutSubviews() {
        debugPrint(logTag + "viewWillLayoutSubviews()")
        
    }
    override func viewDidLayoutSubviews() {
        debugPrint(logTag + "viewDidLayoutSubviews()")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


