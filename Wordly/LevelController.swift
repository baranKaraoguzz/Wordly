//
//  LevelController.swift
//  Wordly
//
//  Created by eposta developer on 30/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import UIKit

class LevelController : BaseContoller, LevelDelegate, ErrorDelegate {
    
    
    //# MARK: - viewDidLoad()
    override func viewDidLoad() {
        
        debugPrint(logTag + "viewDidLoad()")
        super.viewDidLoad()
        self.levelService.errorDelegate = self
        self.levelService.levelDelegate = self
        
        debugPrint(logTag + "user model \(registeredUser)" )
        //add tapped action to views
        addTappedTo()
        
    }   
    
    
    //# MARK: - Service Delegate Methods
    //--------------------------------------------//
    //  SERVICE DELEGATE METHODS BROUGHT DATA
    //--------------------------------------------//
    
    // TAKES RESPONSE FROM SERVICE
    func getSelectLevelResponseModel(model: SelectLevelResponse) {
        debugPrint(logTag + "select level response data : \(model)")
        stopPogress()
        var registeredUser : RegisteredUser = RegisteredUser()
        registeredUser.id = model.id
        registeredUser.name = model.name
        registeredUser.surname = model.surname
        registeredUser.password = model.password
        registeredUser.registeredMail = model.registeredMail
        registeredUser.notificationMail = model.notificationMail
        registeredUser.isAudioNotificationOpen = ( model.isAudioNotificationOpen.lowercaseString == "false" ) ? false : true
        registeredUser.isEmailNotificationOpen = ( model.isEmailNotificationOpen.lowercaseString == "false" ) ? false : true
        registeredUser.isMobileNotificationOpen = ( model.isMobileNotificationOpen.lowercaseString == "false" ) ? false : true
        registeredUser.notificationFrequency = Frequency(rawValue: model.notificationFrequency)
        registeredUser.userType = UserType(type: model.userType)
        let type : UserType = registeredUser.userType
        registeredUser.userLevel = UserLevel(level: model.userLevel)
       
        //Save User Data According To the UserType
        switch type {
        case .mail:
            UserPrefence.saveMailUserData(registeredUser)
            UserPrefence.writeLastUserType(.mail)
        case .facebook:
            UserPrefence.saveFacebookUserData(registeredUser)
            UserPrefence.writeLastUserType(.facebook)
        case .twitter:
            UserPrefence.saveTwitterUserData(registeredUser)
            UserPrefence.writeLastUserType(.twitter)
        default:
        //# TODO - Handle The problem
        return
        }
       
        self.performSegueWithIdentifier(self.levelToWordControllerSegueIdentifier, sender: nil)
    }
    
    //TAKES ERROR MESSAGE FROM SERVICE
    func onError(errorMessage : String)
    {
       stopPogress()
        debugPrint(logTag + "Select Level Error Message \(errorMessage)")
        dispatch_async(dispatch_get_main_queue()) {
            self.view.makeToast(message : errorMessage)
        }
    }
    
    //# MARK: - Send Data To Service
    //SEND MODEL TO SERVICE
    private  func sendModelToService(user : RegisteredUser) {
        //set sending data for service
        var  model : SelectLevelSend = SelectLevelSend()
        model.id = user.id
        model.name = user.name
        model.surname = user.surname
        model.registeredMail = user.registeredMail
        model.userLevel = user.userLevel.rawValue
        model.userType = user.userType.rawValue
        
        self.levelService.dispatchLevelData(model)
        showProgressConnecting()
        
    }
    
    //# MARK: - Button Actions
    //--------------------------------------------//
    //  BUTTON ACTIONS
    //--------------------------------------------//
    //Beginner View Tapped click
    func beginnerViewTapped(img: AnyObject)
    {
        debugPrint(logTag + "Beginner View is Tapped!")
        registeredUser.userLevel = UserLevel.beginner
        sendModelToService(registeredUser)
        
    }
    
    func intermediateViewTapped(img: AnyObject)
    {
        debugPrint(logTag + "Intermediate View is Tapped!")
        registeredUser.userLevel = UserLevel.intermediate
        sendModelToService(registeredUser)
    }
    
    func advancedViewTapped(img: AnyObject)
    {
        debugPrint(logTag + "Advanced View is Tapped!")
        registeredUser.userLevel = UserLevel.advanced
        sendModelToService(registeredUser)
    }
    
    //----------------------------------------------
    //# MARK: - Set Gesture The Views
    //---------------------------------------------
    private func addTappedTo(){
        //beginner view
        let beginnerViewTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(LevelController.beginnerViewTapped(_:)))
        beginnerView.userInteractionEnabled = true
        beginnerView.addGestureRecognizer(beginnerViewTapGestureRecognizer)
        //signIn label
        let intermediateViewTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(LevelController.intermediateViewTapped(_:)))
        intermediateView.userInteractionEnabled = true
        intermediateView.addGestureRecognizer(intermediateViewTapGestureRecognizer)
        //signIn label
        let advancedViewTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(LevelController.advancedViewTapped(_:)))
        advancedView.userInteractionEnabled = true
        advancedView.addGestureRecognizer(advancedViewTapGestureRecognizer)
    }
    
    
    //# MARK: - Class Variables / Members
    private final let logTag : String = "LevelController "
    private final let levelToWordControllerSegueIdentifier : String = "segueLevelToWord"
    
    @IBOutlet weak var beginnerView: UIView!
    @IBOutlet weak var intermediateView: UIView!
    @IBOutlet weak var advancedView: UIView!
    
    var levelService : LevelService = LevelService()
    var registeredUser : RegisteredUser = RegisteredUser()
    var level : UserLevel!
    var levelStr : String = ""
    
    
    
    //# MARK: - Lifecycle methods
    override func viewWillAppear(animated: Bool) {
        debugPrint(logTag + "viewWillAppear()")
        //GAI
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Level Controller")
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



