//
//  SignInController.swift
//  Wordly
//
//  Created by eposta developer on 30/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import UIKit

//LoginDelegate
class SignInController : BaseContoller,ErrorDelegate, EmailDelegate, UITextFieldDelegate,DownloaderDelegate {
    

     //# MARK: - viewDidLoad()
    override func viewDidLoad() {
         debugPrint(logTag + "viewDidLoad()")
        super.viewDidLoad()
        //set delegates
       // self.loginService.errorDelegate = self
       // self.loginService.loginDelegate = self
        self.emailService.errorDelegate = self
        self.emailService.emailDelegate = self
        self.downloader.downloaderDelegate = self
        txtFieldEmailSI.delegate = self
     
        //set style button
        setBorders()
     
    }
    
    //# MARK: - Send Data Level Controller
     //------------------------------------------
    //  SEND "NEW USER" DATA TO LEVEL CONTROLLER
    //------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == self.signToLevelControllerSegueIdentifier) {
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            let destinationVC = segue.destinationViewController as! LevelController;
            destinationVC.registeredUser = self.user
        }
    }
    /*
    private func setNewUserData (id: String, email: String) -> RegisteredUser{
        var registeredUser : RegisteredUser = RegisteredUser()
        registeredUser.id = id
        registeredUser.name = ""
        registeredUser.surname = ""
        registeredUser.registeredMail = email
        registeredUser.notificationMail = email
        registeredUser.userLevel = UserLevel.unSelected
        registeredUser.isAudioNotificationOpen = true
        registeredUser.isEmailNotificationOpen = true
        registeredUser.isMobileNotificationOpen = true
        return registeredUser
    }
 */
    
    private func sendLevelData() -> RegisteredUser{
        debugPrint(logTag , "user mail id = " + self.userMailID )
        self.txtFieldEmailSI.text = ""
        var registeredUser : RegisteredUser = RegisteredUser()
        registeredUser.id = self.userMailID
        registeredUser.name = ""
        registeredUser.surname = ""
        registeredUser.password = ""
        registeredUser.registeredMail = self.modelEmail
        registeredUser.notificationMail = self.modelEmail
        registeredUser.userLevel = UserLevel.unSelected
        registeredUser.userType = UserType.mail
        registeredUser.notificationFrequency = Frequency.getDefault()
        registeredUser.isAudioNotificationOpen = true
        registeredUser.isEmailNotificationOpen = true
        registeredUser.isMobileNotificationOpen = true
        return registeredUser
    
    }
    
    private func sendWordData(model : EmailLoginResponse) -> RegisteredUser{
        
        var regUser : RegisteredUser = RegisteredUser()
        regUser.id = model.idMail
        regUser.name = ""
        regUser.surname = ""
        regUser.password = ""
        regUser.registeredMail = model.registeredMail
        regUser.notificationMail = model.notificationMail
        regUser.userType = UserType.mail
        regUser.userLevel = UserLevel(level: model.userLevel)
        regUser.isAudioNotificationOpen = ( model.isAudioNotificationOpen.lowercaseString == "false" ) ? false : true
        regUser.isEmailNotificationOpen = ( model.isEmailNotificationOpen.lowercaseString == "false" ) ? false : true
        regUser.isMobileNotificationOpen = ( model.isMobileNotificationOpen.lowercaseString == "false" ) ? false : true
        regUser.notificationFrequency = Frequency(rawValue: model.notificationFrequency)
        return regUser
    
    }

    //# MARK: - Service Delegate Methods
    //--------------------------------------------//
    //  SERVICE DELEGATE METHODS BROUGHT DATA
    //--------------------------------------------//
    
    // TAKES RESPONSE FROM SERVICE
    func getEmailControlResponseModel(model: EmailControlResponse) {
        debugPrint(logTag + "email control response data : \(model)")
        //stop progress
        stopPogress()
        // check whether user has been registered before or not.
        self.userIsRegisteredUser  = ( model.isRegisteredUser.lowercaseString == FinalString.TRUE) ? true : false ;
        self.userMailID = model.idMail
        self.modelDbVersion = model.databaseVersion
        //----------------------------------------------------------------
        //force user to check version from local version file.
        //first control to be done with local file.
        //--------------------------------------------------------------
        //control version
        let isVersionChecked = UserPrefence.isVersionChecked()
        //--------------------------------------------------
        //version has been checked before
        if isVersionChecked {
        
            //wordlist is not updated. download new list
            if model.isUpdated == FinalString.FALSE {
                debugPrint(logTag + "databse version is not updated.")
                let action = {(action : UIAlertAction!) in
                    //download list
                    self.showProgressUpdating()
                    self.downloader.downloadAllWordList()
                }
                showBasicAlertWithAction(WarningUtil.updateWordList, action: action)
            }
                //word list is up-to-date.
            else {
                 debugPrint(logTag + "database version is up-to-date.")
                //registered user goes to email login service
                if self.userIsRegisteredUser {
                    
                    var model :  EmailLoginSend = EmailLoginSend()
                    model.idMail = self.userMailID
                    self.emailService.dispatchLEmailoginModelToConnection(model)
                    showProgressConnecting()
                    
                }
               //unregistered user goes to select level service
                else {
                    let levelUser = sendLevelData()
                    UserPrefence.writeLastUserType(.mail)
                    UserPrefence.saveMailUserData(levelUser)
                    self.user = levelUser
                    self.performSegueWithIdentifier(self.signToLevelControllerSegueIdentifier, sender: nil)
                }
                
            }
        }
       //-----------------------------------------------------
       //version has not been checked before
        else {
            //wordlist is not updated. download new list
            if model.isUpdated == FinalString.FALSE {
                debugPrint(logTag + "2 database version is not update.")
                let action = {(action : UIAlertAction!) in
                    //download list
                    self.showProgressUpdating()
                    self.downloader.downloadAllWordList()
                }
                showBasicAlertWithAction(WarningUtil.updateWordList, action: action)
            }
                // wordlist is up-to-date.
            else {
                                    debugPrint(logTag + "database version is up-to-date.")
                //resgistered user
                if self.userIsRegisteredUser {
                    UserPrefence.setVersionChecked(true)
                    UserPrefence.setVersion(self.modelDbVersion)
                    var model :  EmailLoginSend = EmailLoginSend()
                    model.idMail = self.userMailID
                    self.emailService.dispatchLEmailoginModelToConnection(model)
                    showProgressConnecting()
                    
                }
                   // unregistered user
                else {
                    UserPrefence.setVersionChecked(true)
                    UserPrefence.setVersion(self.modelDbVersion)
                    let levelUser = sendLevelData()
                    UserPrefence.writeLastUserType(.mail)
                    UserPrefence.saveMailUserData(levelUser)
                    self.user = levelUser
                    self.performSegueWithIdentifier(self.signToLevelControllerSegueIdentifier, sender: nil)
                }
                      }
                }
            }
    
    func getEmailLoginResponseModel(model: EmailLoginResponse) {
        //
        stopPogress()
          //if a user has been registered in contrast to he or she does not have a english level , this user  is newUser for our app.
        if model.isNewUser.lowercaseString == FinalString.FALSE {
        let regUser = sendWordData(model)
        dispatch_async(dispatch_get_main_queue()) {
            self.view.makeToast(message : model.message)
        }
        UserPrefence.saveMailUserData(regUser)
        UserPrefence.writeLastUserType(.mail)
        let triggerTime = (Int64(NSEC_PER_SEC) * 2)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            self.performSegueWithIdentifier(self.signToWordControllerSegueIdentifier, sender: nil)
        })
        }
        //this user is not newUser.
        else{
            let levelUser = sendLevelData()
            UserPrefence.writeLastUserType(.mail)
            UserPrefence.saveMailUserData(levelUser)
            self.user = levelUser
            self.performSegueWithIdentifier(self.signToLevelControllerSegueIdentifier, sender: nil)
            
        }
    }
    
    //TAKES ERROR MESSAGE FROM SERVICE
    func onError(errorMessage : String)
    {
        //stop progress
        stopPogress()
        debugPrint(logTag + "SignIn Error Message \(errorMessage)")
        dispatch_async(dispatch_get_main_queue()) {
            self.view.makeToast(message : errorMessage)
        }
    }
    
    
    /*
    //# MARK: ----------- REMOVE
    func getLoginResponseModel(model: LoginResponse) {
        
         debugPrint(logTag + "login response data : \(model)")
        //stop progress
        stopPogress()
        //control version 
        let isVersionChecked = UserPrefence.isVersionChecked()
        //-----------------------------------------version--------------------------------
        //version has been checked before
        if isVersionChecked {
        
            //wordlist is not updated. download new list 
            if model.isUpdated == FinalString.FALSE {
            debugPrint(logTag + "databse version is not updated.")
                
                let action = {(action : UIAlertAction!) in
                //download list
                self.showProgressUpdating()
                self.modelDbVersion = model.databaseVersion        
                self.downloader.downloadAllWordList()
                }
            showBasicAlertWithAction(WarningUtil.updateWordList, action: action)
            
            }
            //word list is up-to-date.
            else {
            debugPrint(logTag + "database version is up-to-date.")
                let newUser : String = model.isNewUser
                //newUser means that he or she did not complete registration
               // -------- a new user ------------
                if newUser != "" && newUser.lowercaseString == FinalString.TRUE {
                debugPrint(logTag + "A new user is accapted.")
                   let regUser = setNewUserData(model.idMail, email: self.modelEmail)
                    UserPrefence.writeLastUserType(.mail)
                    UserPrefence.saveMailUserData(regUser)
                    self.user = regUser
                    self.performSegueWithIdentifier(self.signToLevelControllerSegueIdentifier, sender: nil)
                
                }
                
                // ---------- existing user -------
                else  {
                debugPrint(logTag + "A Existing user is accepted.")
                 
                    var registeredUser : RegisteredUser = RegisteredUser()
                    registeredUser.id = model.idMail
                    registeredUser.name = ""
                    registeredUser.surname = ""
                    registeredUser.registeredMail = model.registeredMail
                    registeredUser.notificationMail = model.notificationMail
                    registeredUser.isAudioNotificationOpen = ( model.isAudioNotificationOpen.lowercaseString == "false" ) ? false : true
                    registeredUser.isEmailNotificationOpen = ( model.isEmailNotificationOpen.lowercaseString == "false" ) ? false : true
                    registeredUser.isMobileNotificationOpen = ( model.isMobileNotificationOpen.lowercaseString == "false" ) ? false : true
                    registeredUser.notificationFrequency = Frequency(rawValue: model.notificationFrequency)
                    registeredUser.userType = UserType.mail
                    registeredUser.userLevel = UserLevel(level: model.userLevel)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.view.makeToast(message : model.message)
                    }
                    
                    UserPrefence.saveMailUserData(registeredUser)
                    UserPrefence.writeLastUserType(.mail)
                    let triggerTime = (Int64(NSEC_PER_SEC) * 2)
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                        self.performSegueWithIdentifier(self.signToWordControllerSegueIdentifier, sender: nil)
                    })
                }
                
            }
        }
       //---------------------------------------version------------------------------
        //version has not been checked before
        else {
            
            //wordlist is not updated. download new list
            if model.isUpdated == FinalString.FALSE {
               debugPrint(logTag + "2 database version is not update.")
                let action = {(action : UIAlertAction!) in
                    //download list
                    self.showProgressUpdating()
                    self.modelDbVersion = model.databaseVersion
                    
                    self.downloader.downloadAllWordList()
                }
                showBasicAlertWithAction(WarningUtil.updateWordList, action: action)
                
            }
            // wordlist is up-to-date.
            else {
                debugPrint(logTag + "database version is up-to-date.")
                let newUser : String = model.isNewUser
                //newUser means that he or she did not complete registration
                // -------- a new user ------------
                if newUser != "" && newUser.lowercaseString == FinalString.TRUE {
                    debugPrint(logTag + "A new user is accapted.")
                    let regUser = setNewUserData(model.idMail, email: self.modelEmail)
                    UserPrefence.writeLastUserType(.mail)
                    UserPrefence.saveMailUserData(regUser)
                    self.user = regUser
                    UserPrefence.setVersionChecked(true)
                    UserPrefence.setVersion(self.modelDbVersion)
                    self.performSegueWithIdentifier(self.signToLevelControllerSegueIdentifier, sender: nil)
                    
                }
                    
                    // ---------- existing user -------
                else  {
                    debugPrint(logTag + "A Existing user is accepted.")
                    
                    var registeredUser : RegisteredUser = RegisteredUser()
                    registeredUser.id = model.idMail
                    registeredUser.name = ""
                    registeredUser.surname = ""
                    registeredUser.registeredMail = model.registeredMail
                    registeredUser.notificationMail = model.notificationMail
                    registeredUser.isAudioNotificationOpen = ( model.isAudioNotificationOpen.lowercaseString == "false" ) ? false : true
                    registeredUser.isEmailNotificationOpen = ( model.isEmailNotificationOpen.lowercaseString == "false" ) ? false : true
                    registeredUser.isMobileNotificationOpen = ( model.isMobileNotificationOpen.lowercaseString == "false" ) ? false : true
                    registeredUser.notificationFrequency = Frequency(rawValue: model.notificationFrequency)
                    registeredUser.userType = UserType.mail
                    registeredUser.userLevel = UserLevel(level: model.userLevel)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.view.makeToast(message : model.message)
                    }
                    UserPrefence.saveMailUserData(registeredUser)
                    UserPrefence.writeLastUserType(.mail)
                    UserPrefence.setVersionChecked(true)
                    UserPrefence.setVersion(self.modelDbVersion)
                    let triggerTime = (Int64(NSEC_PER_SEC) * 2)
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                        self.performSegueWithIdentifier(self.signToWordControllerSegueIdentifier, sender: nil)
                    })
                }
            }
            
        }        
    }
    
    
    //TAKES ERROR MESSAGE FROM SERVICE
    func onError(errorMessage : String)
    {
        //stop progress
         stopPogress()
        debugPrint(logTag + "Register Error Message \(errorMessage)")
        dispatch_async(dispatch_get_main_queue()) {
              self.view.makeToast(message : errorMessage)
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
        
        debugPrint("TEST **** " + self.modelDbVersion)
        //set new version
        UserPrefence.setVersionChecked(true)
        UserPrefence.setVersion(self.modelDbVersion)
        
        //stop progress
        stopPogress()
        
        //call API from here.
         // check whether user has been registered before or not.
        
         //registered user goes to email login service
        if self.userIsRegisteredUser {
          
             var model :  EmailLoginSend = EmailLoginSend()
            model.idMail = self.userMailID
            self.emailService.dispatchLEmailoginModelToConnection(model)
           //  showProgressConnecting()
            
        
        }
         //unregistered user goes to select level service
        else {
            let levelUser = sendLevelData()
            UserPrefence.writeLastUserType(.mail)
            UserPrefence.saveMailUserData(levelUser)
            self.user = levelUser
            self.performSegueWithIdentifier(self.signToLevelControllerSegueIdentifier, sender: nil)
        }
        
        
 
    }
    

    //# MARK: - Button Actions
    //--------------------------------------------//
    //  BUTTON ACTIONS
    //--------------------------------------------//
    
    @IBAction func btnLoginTapped(sender: BlueButton) {
        debugPrint(logTag + "Login button is tapped.")
      
        let isNetAvailable =  hasConnectivity()
        if isNetAvailable {
        debugPrint(logTag + "Net Is Available.")
            // take email and password
            let email : String = self.txtFieldEmailSI.text!
            
            
            if   !email.isEmail
            {
                debugPrint(WarningUtil.inValidEmail)
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.makeToast(message : WarningUtil.inValidEmail)
                }
                return
            }
            
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
 
 
            
            //call API from here.
            var model : EmailControlSend = EmailControlSend()
            model.email = email
            self.modelEmail = email
            model.dbVersion = (databaseVersion != "") ? databaseVersion : "0"
            model.versionCode = "0"
            self.emailService.dispatchLEmailControlModelToConnection(model)
            showProgressConnecting()
            /*
             var model : LoginSend = LoginSend()
             model.email = email
             self.modelEmail = email
             self.modelDbVersion = databaseVersion
             model.dbVersion = (databaseVersion != "") ? databaseVersion : "0"
             //--- --------- --------- version code   -------------- ----------- ------------
             //#TODO : - test
             //  model.dbVersion = "0"
             model.versionCode = "0"
             self.loginService.dispatchLoginModelToConnection(model)
             */

        }
        else {
        debugPrint(logTag + "Net Is Not Available.")
            dispatch_async(dispatch_get_main_queue()) {
                self.view.makeToast(message : WarningUtil.connectInternet)
            }
            return
        }
            }
    
    @IBAction func btnBackToLoginTapped(sender: UIButton) {
          debugPrint(logTag + "BackToLogin button is tapped.")
        if let signInControllerToLogin = storyboard!.instantiateViewControllerWithIdentifier("LoginID") as? LoginController {
            presentViewController(signInControllerToLogin, animated: true, completion: nil)}

    }
    
    
    //# MARK: - Set Borders
    //------------------------------------------//
    //  SET STYLES
    //------------------------------------------//
    
    private func setBorders(){
         ColorUtil.borderButtonDefaultRadius(btnLogin, uiColor: ColorUtil.blueButton)
    }
    
     //# MARK: - Limit TextFiled Input
    //------------------------------------------//
    // LIMIT TEXT FIELD INPUT
    //------------------------------------------//
    
    //Limit Editmail To 50
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //An expression works with Swift 2g
     if textField == self.txtFieldEmailSI {
            return (txtFieldEmailSI.text?.utf16.count ?? 0) + string.utf16.count - range.length <= 50
        }
        
        return (textField.text?.utf16.count ?? 0) + string.utf16.count - range.length <= 70
    }
    
    //# MARK: - Hide Keyboard
    //hide keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        txtFieldEmailSI.resignFirstResponder()
        
    }
    
      //# MARK: - Slide Screen Methods
    //--------------------------------------------------------
    //  move up and down textfield
    //--------------------------------------------------------
    

    @IBAction func txtFieldEmailDidBeginEdit(sender: TextField) {
        animateViewMoving(true, moveValue: 100.0)
    }
    
    @IBAction func txtFieldEmailDidEndEdit(sender: TextField) {
        animateViewMoving(false, moveValue: 100.0)
    }
    
 
    
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    
     //# MARK: - Class Variables / Members
    private final let logTag : String = "SignInController "
    private final let signToLevelControllerSegueIdentifier : String = "segueSignToLevel"
    private final let signToWordControllerSegueIdentifier : String = "segueSignToWord"
    
    @IBOutlet weak var txtFieldEmailSI: TextField!
   // @IBOutlet weak var txtFieldPasswordSI: TextField!
    @IBOutlet weak var btnBackToLogin: UIButton!
    @IBOutlet weak var btnLogin: BlueButton!
  //  @IBOutlet weak var lblForgotPassword: InsetLabel!
    
    var downloader = Downloader()
   // var loginService = LoginService()
    var emailService = EmailService()
    var user : RegisteredUser!
    var modelDbVersion : String = ""
    var modelEmail : String = ""
    var modelPass : String =  ""
    var userMailID : String = ""
    var userIsRegisteredUser : Bool = false
    

    
    //# MARK: - Lifecycle methods
    override func viewWillAppear(animated: Bool) {
        debugPrint(logTag + "viewWillAppear()")
        //GAI
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "SignIn Controller")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    override func viewDidAppear(animated: Bool) {
        debugPrint(logTag + "viewDidAppear()")
    }
    
    override func viewWillDisappear(animated: Bool) {
        debugPrint(logTag + "viewWillDisappear()")
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


