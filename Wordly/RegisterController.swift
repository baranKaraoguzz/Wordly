//
//  RegisterActivity.swift
//  Wordly
//
//  Created by eposta developer on 29/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//


import UIKit

class RegisterController : BaseContoller,RegisterDelegate,ErrorDelegate, UITextFieldDelegate, DownloaderDelegate{
    
    
    
    //# MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint(logTag + "viewDidLoad()")
        //set delegates
        self.registerService.errorDelegate = self
        self.registerService.registerDelegate = self
        self.downloader.downloaderDelegate = self
        txtFieldEmail.delegate = self
        txtFieldPassword.delegate = self
        txtFieldRePassword.delegate = self
        //set button border
        setBeMemberButtonBorder()
    }
  

    //# MARK: - Service Delegate Methods
    //--------------------------------------------//
    //  SERVICE DELEGATE METHODS BROUGHT DATA
    //--------------------------------------------//
    
    // TAKES RESPONSE FROM SERVICE
    func getRegisterResponseModel(model: RegisterResponse) {
        
        debugPrint(logTag + "register response data : \(model)")
    
        let isVersionChecked =  UserPrefence.isVersionChecked()
        
        //version has been checked before
        if isVersionChecked {
        
            // wordlist is not updated. download new list.
            if model.isUpdated == FinalString.FALSE {
            debugPrint(logTag + " database version is not updated.")
               //stop progress
                stopPogress()
                //show alert view
                let action = {(action : UIAlertAction!) in
                    //download list
                    self.showProgressUpdating()
                    self.modelDbVersion = model.databaseVersion
                    self.modelUserId = model.userId
                    self.downloader.downloadAllWordList()
                }
                showBasicAlertWithAction( WarningUtil.updateWordList, action: action)

                        }
            //wordlist is up-to-date.
            else {
            debugPrint(logTag + " database version is up-to-date.")
                self.stopPogress()
                setUserModelData(model.userId)
                self.performSegueWithIdentifier(self.levelControllerSegueIdentifier, sender: nil)
            }
                    }
        //version has not been checked before
        else {
        
            // wordlist is not updated. download new list.
            if model.isUpdated == FinalString.FALSE {
                debugPrint(logTag + "2 database version is not update.")
             //stop progress
                self.stopPogress()
                
                //show alert view
                
                let action = {(action : UIAlertAction!) in
                    //download list
                    
                    self.showProgressUpdating()
                    self.modelDbVersion = model.databaseVersion
                    self.modelUserId = model.userId
                    self.downloader.downloadAllWordList()
                }
                showBasicAlertWithAction( WarningUtil.updateWordList, action: action)

             /*
               let alert = UIAlertController(title: WarningUtil.updateWordList, message: "", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action : UIAlertAction!) in
                    //download list
                
                    self.modelDbVersion = model.databaseVersion
                    self.modelUserId = model.userId
                    self.downloader.downloadAllWordList()
                } ))
                self.presentViewController(alert, animated: true, completion: nil)
               */
            }
            //wordlist is up-to-date.
            else {
                self.stopPogress()
             debugPrint(logTag + "2 database version is up-to-date.")
             UserPrefence.setVersionChecked(true)
             UserPrefence.setVersion(model.databaseVersion)
             setUserModelData(model.userId)
             self.performSegueWithIdentifier(self.levelControllerSegueIdentifier, sender: nil)
            }
                }
            }
    
    //TAKES ERROR MESSAGE FROM SERVICE
    func onError(errorMessage : String)
    {
     stopPogress()
        debugPrint(logTag + "Register Error Message \(errorMessage)")
        dispatch_async(dispatch_get_main_queue()) {
            self.view.makeToast(message : errorMessage)
        }
    }
    
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
      
        // stop progress
        stopPogress()
       
        //call service from here.
        var model : RegisterSend = RegisterSend()
        model.email = self.modelEmail
        self.registirationMail = self.modelEmail
        model.password = self.modelPass
        model.dbVersion = (self.modelDbVersion != "") ? self.modelDbVersion : "0"
        //--- --------- --------- version code   -------------- ----------- ------------
        model.versionCode = "0"
       self.registerService.dispatchRegisterModelToConnection(model)
        //show connecting
        showProgressConnecting()
        }

    
    //# MARK: - Send Data Level Controller
    //------------------------------------------
    //  SEND DATA TO LEVEL CONTROLLER
    //------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == self.levelControllerSegueIdentifier) {
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            let destinationVC = segue.destinationViewController as! LevelController;
            destinationVC.registeredUser = self.user
        }
    }
    
    // set user model data to dispatch to level controller.
    private func setUserModelData(userID : String) {
        user = RegisteredUser()
        user.id = userID
        user.registeredMail = self.registirationMail
        user.notificationMail = self.registirationMail
        user.password = FinalString.PASSWORD_STARS
        user.userLevel = UserLevel.unSelected
        user.userType = UserType.mail
        user.notificationFrequency = Frequency.getDefault()
        user.isAudioNotificationOpen = true
        user.isEmailNotificationOpen = true
        user.isMobileNotificationOpen = true
        
    }
    
    //# MARK: - Button Actions
    //--------------------------------------------//
    //  BUTTON ACTIONS
    //--------------------------------------------//
    
    @IBAction func tappedBeMember(sender: BlueButton) {
        debugPrint(logTag + "Tapped Be Member Button")
    
        //check network connection
        let isNetAvailable =  hasConnectivity()
        //net is available
        if isNetAvailable {
            debugPrint(logTag + "Net Is Available.")
            // take email and password
            let email : String = self.txtFieldEmail.text!
            let pass: String =  self.txtFieldPassword.text!
            let rePass : String = self.txtFieldRePassword.text!
            
            if  email.trimInput() == "" ||  !email.isEmail
            {
                debugPrint(WarningUtil.inValidEmail)
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.makeToast(message : WarningUtil.inValidEmail)
                }
                return
            }
            if pass.hasSpecialCharacter || rePass.hasSpecialCharacter {
            debugPrint(logTag + "password has special character.")
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.makeToast(message : WarningUtil.inValidPasswordRegex)
                }
                return
            }
            else {
            debugPrint(logTag + "password has not any speacial character..")
                
            }
           if pass.characters.count <= 5 {
                debugPrint(WarningUtil.smallPassword)
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.makeToast(message : WarningUtil.smallPassword)
                }
                return
            }
            if pass.characters.count > 12  {
                debugPrint(WarningUtil.longPassword)
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.makeToast(message : WarningUtil.longPassword)
                }
                return
            }
            if pass != rePass {
                debugPrint(WarningUtil.notSamePassword)
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.makeToast(message : WarningUtil.notSamePassword)
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
            
            //call service from here.
            var model : RegisterSend = RegisterSend()
            model.email = email
            self.modelEmail = email
            self.registirationMail = email
            model.password = pass
            self.modelPass = pass
            model.dbVersion = (databaseVersion != "") ? databaseVersion : "0"
            //--- --------- --------- version code   -------------- ----------- ------------
            model.versionCode = "0"
            self.registerService.dispatchRegisterModelToConnection(model)
            showProgressConnecting()
            
        }
            //net is not available
        else {
            debugPrint(logTag + "Net Is Not Available.")
            dispatch_async(dispatch_get_main_queue()) {
                self.view.makeToast(message : WarningUtil.connectInternet)
            }
                    }
              }
    
    @IBAction func tappedBackBtn(sender: UIButton) {
        debugPrint(logTag + "Tapped Back Button")
        self.performSegueWithIdentifier(self.loginControllerSegueIdentifier, sender: nil)
    }
    
    
    //# MARK: - Set Styles
    //------------------------------------------//
    //  SET STYLES
    //------------------------------------------//
    
    //set button border
    private func setBeMemberButtonBorder(){
        ColorUtil.borderButtonDefaultRadius(self.btnBeMember, uiColor: ColorUtil.blueButton)
    }
    
    
    //# MARK: - Limit TextFiled Input
    //------------------------------------------//
    // LIMIT TEXT FIELD INPUT
    //------------------------------------------//
    
    //Limit Editmail To 50 and Editpassword To 20.
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //An expression works with Swift 2g
        if textField == self.txtFieldEmail  {
            return (txtFieldPassword.text?.utf16.count ?? 0) + string.utf16.count - range.length <= 15
        }
            
        else if textField == self.txtFieldRePassword  {
            return (txtFieldRePassword.text?.utf16.count ?? 0) + string.utf16.count - range.length <= 15
        }
        else if textField == self.txtFieldEmail {
            return (txtFieldEmail.text?.utf16.count ?? 0) + string.utf16.count - range.length <= 50
        }
        
        return (textField.text?.utf16.count ?? 0) + string.utf16.count - range.length <= 70
    }
    
    //# MARK: - Hide Keyboard
    //hide keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        txtFieldEmail.resignFirstResponder()
        txtFieldPassword.resignFirstResponder()
        txtFieldRePassword.resignFirstResponder()
    }
    
    //# MARK: - Slide Screen Methods
    //--------------------------------------------------------
    //  move up and down textfield
    //--------------------------------------------------------
    
    @IBAction func txtFieldDidBeginEditing(sender: TextField) {
        animateViewMoving(true, moveValue: 100)
    }
    
    
    @IBAction func txtFieldDidEndEditing(sender: TextField) {
        animateViewMoving(false, moveValue: 100)
    }
    
    
    @IBAction func txtFieldPasswordDidBeginEditing(sender: TextField) {
        animateViewMoving(true, moveValue: 100)
    }
    
    @IBAction func txtFieldPasswordDidEndEditing(sender: TextField) {
        animateViewMoving(false, moveValue: 100)
    }
    
    @IBAction func textFieldRePasswordDidBeginEditing(sender: TextField) {
        animateViewMoving(true, moveValue: 100)
    }
    
    @IBAction func textFieldRePasswordDidEndEditing(sender: TextField) {
        animateViewMoving(false, moveValue: 100)
        
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
    private final let logTag : String = "RegisterController "
    private final let levelControllerSegueIdentifier : String =  "segueRegisterToLevel"
    private final let loginControllerSegueIdentifier : String = "segueRegisterToLogin"
    
    @IBOutlet weak var btnBeMember: BlueButton!
    @IBOutlet weak var txtFieldEmail: TextField!
    @IBOutlet weak var txtFieldPassword: TextField!
    @IBOutlet weak var txtFieldRePassword: TextField!
    
    var registerService = RegisterService()
    var user : RegisteredUser!
    var registirationMail : String = ""
    var downloader = Downloader()
    var modelDbVersion : String = ""
    var modelUserId : String = ""
    var modelEmail : String = ""
    var modelPass : String = ""
   
   
    //# MARK: - Lifecycle methods
    override func viewWillAppear(animated: Bool) {
        debugPrint(logTag + "viewWillAppear()")
        //GAI
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Register Controller")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])

    }
    override func viewDidAppear(animated: Bool) {
        debugPrint(logTag + "viewDidAppear()")
       //  self.alert = UIAlertController(title: WarningUtil.updateWordList, message: "", preferredStyle: UIAlertControllerStyle.Alert)
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
/*
 
 
 import UIKit
 /*
 class RegisterController : BaseContoller,RegisterDelegate,ErrorDelegate, UITextFieldDelegate{
 
 
 
 //   @IBOutlet weak var btnBeMember: BlueButton!
 //   @IBOutlet weak var txtFieldEmail: UITextField!
 //    @IBOutlet weak var txtFieldPassword: UITextField!
 //   @IBOutlet weak var txtFieldRePassword: UITextField!
 
 
 var  registerService = RegisterService()
 
 override func viewDidLoad() {
 super.viewDidLoad()
 self.registerService.errorDelegate = self
 self.registerService.registerDelegate = self
 //     txtFieldEmail.delegate = self
 //    txtFieldPassword.delegate = self
 //    txtFieldRePassword.delegate = self
 
 //set button border
 //     setBeMemberButtonBorder()
 }
 
 override func viewDidLayoutSubviews(){
 super.viewDidLayoutSubviews()
 //set underline border to textfield
 //     self.txtFieldEmail.setBottomBorder(UIColor.whiteColor())
 //     self.txtFieldPassword.setBottomBorder(UIColor.whiteColor())
 //     self.txtFieldRePassword.setBottomBorder(UIColor.whiteColor())
 
 }
 
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 // Dispose of any resources that can be recreated.
 }
 
 
 //--------------------------------------------//
 //  SERVICE DELEGATE METHODS BROUGHT DATA
 //--------------------------------------------//
 
 // TAKES RESPONSE FROM SERVICE
 func getRegisterResponseModel(model: RegisterResponse) {
 //   debugPrint("register response data : \(model.message) , \(model.userId) , \(model.forcedToUpdate) , \(model.isUpdated) , \(model.result) , \(model.databaseVersion)")
 debugPrint("register response data : \(model)")
 }
 
 //TAKES ERROR MESSAGE FROM SERVICE
 func onError(errorMessage : String)
 {
 // progressViewManager?.hide()
 debugPrint("Register Error Message \(errorMessage)")
 dispatch_async(dispatch_get_main_queue()) {
 //   self.view.makeToast(message : errorMessage)
 }
 }
 
 
 //--------------------------------------------//
 //  BUTTON ACTIONS
 //--------------------------------------------//
 
 @IBAction func tappedBeMember(sender: BlueButton) {
 debugPrint("Tapped Be Member Button")
 /*
 var model : RegisterSend = RegisterSend()
 model.email = "s1@m.com"
 model.password = "1234567"
 model.dbVersion = "20160630"
 model.versionCode = "5"
 self.registerService.dispatchRegisterModelToConnection(model)
 
 */
 }
 
 
 
 
 //------------------------------------------//
 //  SET STYLES
 //------------------------------------------//
 
 //set button border
 private func setBeMemberButtonBorder(){
 ColorUtil.borderButtonDefaultRadius(self.btnBeMember, uiColor: ColorUtil.blueButton)
 }
 
 //------------------------------------------//
 // LIMIT TEXT FIELD INPUT
 //------------------------------------------//
 
 //Limit Editmail To 50 and Editpassword To 20.
 func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
 //An expression works with Swift 2g
 if textField == self.txtFieldPassword  {
 return (txtFieldPassword.text?.utf16.count ?? 0) + string.utf16.count - range.length <= 15
 }
 else if textField == self.txtFieldRePassword  {
 return (txtFieldRePassword.text?.utf16.count ?? 0) + string.utf16.count - range.length <= 15
 }
 else if textField == self.txtFieldEmail {
 return (txtFieldEmail.text?.utf16.count ?? 0) + string.utf16.count - range.length <= 50
 }
 return (textField.text?.utf16.count ?? 0) + string.utf16.count - range.length <= 70
 }
 
 }
 */
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 class abc {
 
 }
 
 
 
 
 
 */
