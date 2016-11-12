//
//  MainController.swift
//  Wordly
//
//  Created by eposta developer on 27/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit


class LoginController : BaseContoller, FBSDKLoginButtonDelegate , ErrorDelegate, FaceTweetDelegate, DownloaderDelegate{
    
    
    
    //# MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint(logTag + "viewDidLoad()")
        // Do any additional setup after loading the view, typically from a nib.
        //let modelName = UIDevice.currentDevice().modelName
        //  debugPrint("device \(modelName)")
        //set delegates
        self.buttonFacebook.delegate = self
        self.faceTweetService.errorDelegate = self
        self.faceTweetService.faceTweetDelegate = self
        self.downloader.downloaderDelegate = self
        //set facebook permissions
        setFacebookPermissions()
      
        // set button borders
        // setButtonBorders()
        //set user agreement text
        setUserAgreement()
     
        //set facebook button text
        setFacebookButtonText()
        //check whether the app run first-time or not
        if UserPrefence.isFirstRun()
        {
            debugPrint(logTag + "First Run")
            let beginnerModels : [WordTableModel] = FileUtil.parseCSV(.beginner)!
            let intermediateModels : [WordTableModel] = FileUtil.parseCSV(.intermediate)!
            let advancedModels : [WordTableModel] = FileUtil.parseCSV(.advanced)!
            debugPrint("test parse b = \(beginnerModels.count) i = \(intermediateModels.count) a = \(advancedModels.count)" )
            DatabaseUtil.saveEntityData(.beginner, modelList: beginnerModels  )
            DatabaseUtil.saveEntityData(.intermediate, modelList: intermediateModels)
            DatabaseUtil.saveEntityData(.advanced, modelList: advancedModels)
        }
        else {
            //check for auto login
            let isUserLogIn = UserPrefence.isUserLogIn()
            if isUserLogIn {
                debugPrint(logTag + " log in now.")
                //make auto login the user.
                let user : RegisteredUser =   readLastuserData()
                if user.userType != nil {
                    let type = user.userType!
                    switch type {
                    case .mail:
                        debugPrint(logTag + " mail user auto-login.")
                        dispatch_async(dispatch_get_main_queue()) {
                            self.performSegueWithIdentifier(self.loginToWordSegueIdentifier, sender: nil)
                        }
                    case .facebook:
                        debugPrint(logTag + "AUTO LOGIN FACEBOOK")
                        dispatch_async(dispatch_get_main_queue()) {
                            self.performSegueWithIdentifier(self.loginToWordSegueIdentifier, sender: nil)
                        }
                    case .twitter:
                        debugPrint(logTag + "AUTO LOGIN TWITTER")
                        dispatch_async(dispatch_get_main_queue()) {
                            self.performSegueWithIdentifier(self.loginToWordSegueIdentifier, sender: nil)
                        }
                        /*
                         if let session = Twitter.sharedInstance().sessionStore.session() {
                         let client = TWTRAPIClient()
                         client.loadUserWithID(session.userID) { (user, error) -> Void in
                         if let user = user {
                         debugPrint("@\(user.screenName)")
                         }
                         }
                         }
                         */
                        
                    default:
                        break
                    }
                }
            }
            else {
                debugPrint(logTag + " user has not been logged in.")
                
            }
        }
    }
    
    //# MARK: - Facebook Login Delegate Methods
    //--------------------------------------------
    //  FACEBOOK LOGIN DELEGATE METHODS
    //--------------------------------------------
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if let error = error {
            debugPrint("facebook login error  \(error)")
            return
        }
        debugPrint("facebook login didCompleteWithResult \(result.debugDescription)")
        
        if let token = FBSDKAccessToken.currentAccessToken() {
            debugPrint("token  \(token)")
            fetchFacebookProfile()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        debugPrint("facebook loginButtonDidLogOut")
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        debugPrint("facebook loginButtonWillLogin")
        let isNetAvailable =  hasConnectivity()
        if isNetAvailable {
            debugPrint(logTag + "Net Is Available.")
            return true
        }
        else {
            debugPrint(logTag + "Net Is Not Available.")
            dispatch_async(dispatch_get_main_queue()) {
                self.view.makeToast(message : WarningUtil.connectInternet)
            }
            return false
        }
    }
    
    //# MARK: - Facebook Permissions
    private func setFacebookPermissions(){
        self.buttonFacebook.readPermissions = ["public_profile", "email"]
    }
    
    //# MARK: - Facebook Fetch Data
    private func fetchFacebookProfile() {
        debugPrint("Fetch profile.")
        let parameters = ["fields":"id,email,first_name,last_name,name"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler{
            (connection, result, error) -> Void in
            if error != nil
            { debugPrint(error)
                return
            }
           
            if let id = result["id"] as? String {
                debugPrint("facebbok id : \(id)")
                self.userID = id
            }
            else{
                debugPrint("ERROR: taken facebook id.")
                
                return
            }
            if let email = result["email"] as? String {
                debugPrint("facebook email : \(email)")
                self.email = email
            }
            if let name = result["first_name"] as? String {
                debugPrint("facebook first_name : \(name)")
                self.name = name
            }
            if let surname = result["last_name"] as? String {
                debugPrint("facebook last_name : \(surname)")
                self.surname = surname
            }
            self.userType = UserType.facebook
            self.sendUserDataToService(self.userID, userType: GlobalData.facebook.rawValue)
        }
    }
    
    //# MARK: - Send Data Level Controller
    //------------------------------------------
    //  SEND DATA TO LEVEL CONTROLLER
    //------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == self.loginToLevelSegueIdentifier) {
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            let destinationViewController = segue.destinationViewController as! LevelController;
            destinationViewController.registeredUser = self.user
        }
    }
    //set user data in order to save.
    private func setRegisteredUserModelData(model :FaceTweetResponse) {
        user = RegisteredUser()
        user.id = self.userID
        user.password = FinalString.PASSWORD_STARS
        user.userLevel = UserLevel(level: model.userLevel)
        let type : UserType =  UserType(type: model.userType)
        user.userType = type
        user.registeredMail = model.registeredMail
        user.notificationMail = model.notificationMail
        user.surname = self.surname
        user.notificationFrequency = Frequency(rawValue: model.notificationFrequency)
        user.isAudioNotificationOpen = (FinalString.FALSE == model.isAudioNotificationOpen.lowercaseString) ? false : true
        user.isEmailNotificationOpen = (FinalString.FALSE == model.isEmailNotificationOpen.lowercaseString) ? false : true
        user.isMobileNotificationOpen = (FinalString.FALSE == model.isMobileNotificationOpen.lowercaseString) ? false : true
        //Save user data according to the user type
        switch type {
        case .mail:
            UserPrefence.saveMailUserData(user)
            UserPrefence.writeLastUserType(.mail)
        case .facebook:
            debugPrint("FACEBOOK FACEBOOK FACEBOOK !")
            //facebook sometimes needs extra time
            self.isFacebookSequeReady = true
            UserPrefence.saveFacebookUserData(user)
            UserPrefence.writeLastUserType(.facebook)
        case .twitter:
            debugPrint("TWITTER TWITTER TWITTER !")
            self.isTwitterSegueReady = true
            UserPrefence.saveTwitterUserData(user)
            UserPrefence.writeLastUserType(.twitter)
        default:
            //# TODO - Handle The problem
            debugPrint(logTag + " undefined user type.")
        }
    }
    
    //set new user data in order to save
    private func setUnRegisteredUserModelDataDispatchToController(model : FaceTweetResponse) {
        // user with social platform id
        user = RegisteredUser()
        user.id = self.userID
        user.password = FinalString.PASSWORD_STARS
        user.userLevel = UserLevel.unSelected
        //DEFAULT Frequency
        user.notificationFrequency = Frequency.getDefault()
        user.isAudioNotificationOpen = true
        user.isEmailNotificationOpen = true
        user.isMobileNotificationOpen = true
        switch self.userType {
        case .facebook:
            user.userType = UserType.facebook
            user.registeredMail = self.email
            user.notificationMail = self.email
            user.name = self.name
            user.surname = self.surname
              //facebook may require 1 sec interval
          let triggerTime = (Int64(NSEC_PER_SEC) * 1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.performSegueWithIdentifier(self.loginToLevelSegueIdentifier, sender: nil)
            })
        case .twitter:
            user.userType = UserType.twitter
            user.registeredMail = ""
            user.notificationMail = ""
            user.name = self.name
            user.surname = ""
            //twitter requires 1 sec interval
            let triggerTime = (Int64(NSEC_PER_SEC) * 1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.performSegueWithIdentifier(self.loginToLevelSegueIdentifier, sender: nil)
            })
        default:
            user.userType = UserType.undefined
            user.registeredMail = ""
            user.notificationMail = ""
            
        }
        
    }
    
    //# MARK: - Service Delegate Methods
    //--------------------------------------------//
    //  SERVICE DELEGATE METHODS BROUGHT DATA
    //--------------------------------------------//
    
    // TAKES RESPONSE FROM SERVICE
    func getFaceTweetResponseModel(model: FaceTweetResponse) {
        
        debugPrint(logTag + " get FaceTweetResponse")
        stopPogress()
        //  The User who has been registered before must go register controller secreen.
        
        let isVersionChecked = UserPrefence.isVersionChecked()
        //version has been checked before
        if isVersionChecked {
            //wordlist is not updated. download new list
            if model.isUpdated == FinalString.FALSE {
                debugPrint(logTag + "database version is not updated.")
              
                //show alert view
                let action = {(action: UIAlertAction) in
                    //download list
                    self.showProgressUpdating()
                    self.modelDbVersion = model.databaseVersion
                    self.downloader.downloadAllWordList()
                }
                showBasicAlertWithAction(WarningUtil.updateWordList, action: action)
            }
                //wordlist is up-to-date.
            else {
                debugPrint(logTag + "database version is up-to-date.")
                // registered user
                if model.isRegisteredUser.lowercaseString == FinalString.TRUE {
                    debugPrint(logTag + "registered user response data for registered user: \(model)")
               
                    setRegisteredUserModelData(model)
                    let triggerTime = (Int64(NSEC_PER_SEC) * 1)
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                        self.performSegueWithIdentifier(self.loginToWordSegueIdentifier, sender: nil)
                    })
                   
                }
                    //unregistered (new) user who should select the level on the level controller screen.
                else {
                    debugPrint(logTag + "login response data for new user: \(model)")
                    setUnRegisteredUserModelDataDispatchToController(model)
                }
            }
        }
            //version has not been checked before
        else {
            //wordlist is not updated. download new list
            if model.isUpdated == FinalString.FALSE  {
             debugPrint(logTag + "2 database version is not update.")
                //show alert view
                let action = {(action: UIAlertAction) in
                    //download list
                    self.showProgressUpdating()
                    self.modelDbVersion = model.databaseVersion
                    self.downloader.downloadAllWordList()
                }
                showBasicAlertWithAction(WarningUtil.updateWordList, action: action)
            }
            //wordlist is up-to-date
            else {
              debugPrint(logTag + "2 database version is up-to-date.")
                UserPrefence.setVersionChecked(true)
                UserPrefence.setVersion(model.databaseVersion)
                if model.isRegisteredUser.lowercaseString == FinalString.TRUE {
                    debugPrint(logTag + "2 registered user response data for registered user: \(model)")
                    setRegisteredUserModelData(model)
                    let triggerTime = (Int64(NSEC_PER_SEC) * 1)
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                        self.performSegueWithIdentifier(self.loginToWordSegueIdentifier, sender: nil)
                    })
                }
                    //unregistered (new) user who should select the level on the level controller screen.
                else {
                    debugPrint(logTag + "2 login response data for new user: \(model)")
                    setUnRegisteredUserModelDataDispatchToController(model)
                }
            }
                  }
          }
    
    //TAKES ERROR MESSAGE FROM SERVICE
    func onError(errorMessage : String)
    {
        stopPogress()
        debugPrint(logTag + "FaceTweet Error Message \(errorMessage)")
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
        
        //stop progress
        stopPogress()
        
        //call service from here.
        var model : FaceTweetSend = FaceTweetSend()
        model.id = self.modelID
        model.userType = self.modelUserType
        model.dbVersion = (self.modelDbVersion != "") ? self.modelDbVersion  : "0"
        model.versionCode = "0"
        self.faceTweetService.dispatchFaceTweetModelToConnection(model)
        //show connecting
        showProgressConnecting()
    }
    
    //# MARK: - Send Data To Service
    //-------------------------------------------
    //  SEND SERVICE
    //-------------------------------------------
    
    private func sendUserDataToService(id : String, userType : String ){
        
        var databaseVersion = ""
        // if version is checked, read from user defaults
        //otherwise read from file
        let isChecked = UserPrefence.isVersionChecked()
        if isChecked {
            databaseVersion = UserPrefence.getVersion()
            debugPrint(logTag + "database version is read as \(databaseVersion) from user defaults.")
            debugPrint("TEST ??? " + databaseVersion )
        }
        else {
            databaseVersion = FileUtil.readDBVersion()
            debugPrint(logTag + "database version is read as \(databaseVersion) from file.")
            debugPrint("TEST ??? " + databaseVersion )
        }
        var model : FaceTweetSend = FaceTweetSend()
        model.id = id
        self.modelID = id
        model.userType = userType
        self.modelUserType = userType
        model.dbVersion = (databaseVersion != "") ? databaseVersion : "0"
        self.modelDbVersion = databaseVersion
        model.versionCode = "0"
        self.faceTweetService.dispatchFaceTweetModelToConnection(model)
        
    }
    
    //-------------------------------------------------//
    //  #MARK: - User Preference & Database Processes
    //-------------------------------------------------//
    private func readLastuserData() -> RegisteredUser{
        
        let lastUserType =  UserPrefence.readLastUserType()
        switch lastUserType {
        case .mail:
            return UserPrefence.readMailUserData()
        case .facebook:
            return UserPrefence.readFacebookUserData()
        case .twitter:
            return UserPrefence.readTwitterUserData()
            
        default:
            debugPrint("")
            return RegisteredUser()
        }
    }
    
    //# MARK: - Button Actions
    //--------------------------------------------//
    //  BUTTON ACTIONS
    //--------------------------------------------//
    //user agreement tap
    func tapUserAgreemnet(recognizer: UITapGestureRecognizer) {
        print(logTag + "User Agreement link is tapped.")
        if let userAgreementController = storyboard!.instantiateViewControllerWithIdentifier(self.idUserAgreement) as? UserAgreementController {
            presentViewController(userAgreementController, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnEmailTapped(sender: UIButton) {
        
        debugPrint(logTag + "Button Email is tapped.")
        if let signInController = storyboard!.instantiateViewControllerWithIdentifier(self.idSignIn) as? SignInController {
            presentViewController(signInController, animated: true, completion: nil)
        }
        
    }
        
    
    @IBAction func facebookbuttonTapped(sender: FBSDKLoginButton) {
        debugPrint(logTag + "Facebook button is tapped. ")


    }
    
    @IBAction func tappedTwitterButton(sender: UIButton) {
        debugPrint(logTag + "Twitter button is tapped. ")
        let isNetAvailable =  hasConnectivity()
        if isNetAvailable {
            debugPrint(logTag + "Net Is Available.")
            //# MARK: - Twitter Fetch Data
            Twitter.sharedInstance().logInWithCompletion {
                (session, error) -> Void in
                if (session != nil) {
                    self.showProgressConnecting()
                    debugPrint("user id : " + session!.userID)
                    self.userID = session!.userID
                    debugPrint("username : " + session!.userName)
                    self.name =  session!.userName
                    debugPrint("authToken : " + session!.authToken)
                    debugPrint("authTokenSecret : " + session!.authTokenSecret)
                    self.userType = UserType.twitter
                    self.sendUserDataToService(self.userID, userType: GlobalData.twitter.rawValue)
                }else {
                    //?
                    self.stopPogress()
                    debugPrint("Twitter Not Login")
                    NSLog("Login error: %@", error!.localizedDescription);
                }
            }
        }
        else {
            debugPrint(logTag + "Net Is Not Available.")
            debugPrint(WarningUtil.inValidPassword)
            dispatch_async(dispatch_get_main_queue()) {
                self.view.makeToast(message : WarningUtil.connectInternet)
            }
        }
        
        /*
         let modelBeginners = DatabaseUtil.selectAllEntity(.beginner)
         let modelIntermediates = DatabaseUtil.selectAllEntity(.intermediate)
         let modelAdvanceds = DatabaseUtil.selectAllEntity(.advanced)
         debugPrint("test select b = \(modelBeginners.count) i = \(modelIntermediates.count) a = \(modelAdvanceds.count)" )
         
         if !modelBeginners.isEmpty {
         debugPrint("test \(modelBeginners[9].enWord) \(modelBeginners[9].date)"   )
         }
         */
        
    }
    
    /*
     private func twitterCallback()
     {
     _ = TWTRLogInButton { (session, error) in
     if let unwrappedSession = session {
     debugPrint("TEST TEST")
     debugPrint("user id : " + unwrappedSession.userID)
     self.userID = unwrappedSession.userID
     debugPrint("username : " + unwrappedSession.userName)
     self.userName =  unwrappedSession.userName
     debugPrint("authToken : " + unwrappedSession.authToken)
     debugPrint("authTokenSecret : " + unwrappedSession.authTokenSecret)
     debugPrint("TEST TEST")
     //user type self ekle
     dispatch_async(dispatch_get_main_queue()) {
     debugPrint("SEND DATA TO SERVICE 1")
     self.userType = UserType.twitter
     self.sendUserDataToService(self.userID, userType: GlobalData.twitter.rawValue)
     debugPrint("SEND DATA TO SERVICE 2")
     }
     }
     else {
     NSLog("Login error: %@", error!.localizedDescription);
     }
     }
     }
     */
    
    
    //# MARK: - Set Styles
    //------------------------------------------//
    //  SET STYLES
    //------------------------------------------//
    
    //set user agreement label
    private func setUserAgreement() ->(){
        let newsString: NSMutableAttributedString = NSMutableAttributedString(string: AppText.userAgreemnet)
        newsString.addAttributes([NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleDouble.rawValue], range: NSMakeRange(11, 23))
        labelUserAgreement.attributedText = newsString.copy() as? NSAttributedString
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginController.tapUserAgreemnet(_:)))
        tapGesture.numberOfTapsRequired = 1
        labelUserAgreement.userInteractionEnabled =  true
        labelUserAgreement.addGestureRecognizer(tapGesture)
    }
    
    
    
    //# MARK: - Set Text
    private func  setFacebookButtonText() {
        let titleText = NSAttributedString(string: "Facebook ile bağlan")
        buttonFacebook.setAttributedTitle(titleText, forState: UIControlState.Normal)
        
    }
    
    //# MARK: - Set Borders
    //set button borders
    private func setButtonBorders(){
        //***     ColorUtil.borderButtonDefaultRadius(buttonFacebook, uiColor: ColorUtil.facebookButtonBorder)
        ColorUtil.borderButtonDefaultRadius(buttonTwitter, uiColor: ColorUtil.twitterButtonBorder)
    }
    
    //# MARK: - Other Methods
    //detect ipad
    private func detectIpadWithSizeClass() -> Bool {
        let horizontalClass = self.traitCollection.horizontalSizeClass;
        let verticalCass = self.traitCollection.verticalSizeClass;
        
        if horizontalClass == UIUserInterfaceSizeClass.Regular && verticalCass == UIUserInterfaceSizeClass.Regular{
            debugPrint(logTag + "ipad")
            return true
        }
        else {
            debugPrint(logTag + "not ipad")
            return false
        }
    }
    
    //# MARK: - Class Variables / Members
    private final let logTag : String = "LoginController "
    
    private final let idUserAgreement = "UserAgreementID"
    private final let idSignIn = "SignInID"
  //  private final let "segueLoginToRegister"
    private final let loginToLevelSegueIdentifier = "segueLoginToLevel"
    private final let loginToWordSegueIdentifier = "segueLoginToWord"
    
    private var isFacebookSequeReady = false
    private var isTwitterSegueReady = false
    var isFacebookLogOut = false
    var willShowProgressFacebook = false
    
    private var userID : String = ""
    private var name : String = ""
    private var surname : String = ""
    private var email : String = ""
    private var userType : UserType = UserType.undefined
    private var modelDbVersion : String = ""
    private var modelID : String = ""
    private var modelUserType : String = ""
    
    @IBOutlet weak var buttonFacebook: FBSDKLoginButton!
    @IBOutlet weak var buttonTwitter: UIButton!
    @IBOutlet weak var labelUserAgreement: UILabel!
    @IBOutlet weak var buttonEmail: UIButton!
   // @IBOutlet weak var labelInputWithMail: InsetLabel!
   // @IBOutlet weak var labelRegisterWithMail: InsetLabel!
    
    var faceTweetService = FaceTweetService()
    var user : RegisteredUser!
    var downloader = Downloader()
    
    //# MARK: - Lifecycle methods
    override func viewWillAppear(animated: Bool) {
        debugPrint(logTag + "viewWillAppear()")
        //GAI
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Login Controller")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        //it is needed for log out
        if self.isFacebookLogOut {
            // log out facebook user
            self.isFacebookLogOut = false
            FBSDKLoginManager().logOut()
        }
           }
    override func viewDidAppear(animated: Bool) {
        debugPrint(logTag + "viewDidAppear()")
        
        
        //use this  , if it needs
        if isFacebookSequeReady {
            /*
            self.isFacebookSequeReady = false
            self.performSegueWithIdentifier(self.loginToWordSegueIdentifier, sender: nil)
 */
        }
        if isTwitterSegueReady {
            /*
            self.isTwitterSegueReady = false
            self.performSegueWithIdentifier(self.loginToWordSegueIdentifier, sender: nil)
 */
        }
        
      
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


