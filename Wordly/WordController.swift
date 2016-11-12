//
//  WordController.swift
//  Wordly
//
//  Created by eposta developer on 30/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import UIKit
import AVFoundation
import Social


class WordController : BaseContoller {
    
    //# MARK: - viewDidLoad()
    override func viewDidLoad() {
        debugPrint(logTag + "viewDidLoad()")
        super.viewDidLoad()
       // debugPrint(logTag + "WordController User \(UserPrefence.readMailUserData())")
        //set backgroundColor of some views
        setViewsBackground()
        //set text
        setLabelTextWithWordModel()
        //add tapped to views
        addTappedTo()
        //set borders
        setBorders()
        // set text colors
        setTextFieldColors()
        //badge number reset to zero
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        //Github Deneme
        
        //#TODO: - TEET CLEAR TEST CLEAR
        let willlSHOW = UserPrefence.willShowProgress()
        if willlSHOW {
        debugPrint(logTag + "WILL SHOW SHOW")
        }
        else {
        debugPrint(logTag + "WONT SHOW SHOW")
        }
        
        DateUtil.getDayOfTheWeek()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(UIApplicationDelegate.applicationWillEnterForeground(_:)),
            name: UIApplicationWillEnterForegroundNotification,
            object: nil)
            //#TODO : - prepared değişmeli kullanıcı değiştiğinde???
            if UserPrefence.isNotificationPrepared() == false {
            debugPrint(logTag + "isNotificationPrepared FALSE")
            UserPrefence.setUserLogInStatus(true)
            let  user : RegisteredUser =  getNotificationUser()!
            //notification is off
            if    user.isMobileNotificationOpen == false
            {
                debugPrint(logTag + " notification is off")
            }
            //notification is on
            else {
                debugPrint(logTag + " notification is on")
                let freq = user.notificationFrequency
                let isAudio = user.isAudioNotificationOpen
                //#TODO: INVESTIGATE
                let   nu   = NotificationUtil.sharedInstance
                UserPrefence.setNotificationPrepared(true)
                nu.sendNotifications(freq , isAudioOpen: isAudio)
                     }
        }
        else {
        debugPrint(logTag + "isNotificationPrepared TRUE")
        }
    }
    
    //# MARK: - Update Screen
    func applicationWillEnterForeground(notification: NSNotification) {
        debugPrint(logTag + "I\'m in of focus again!")
        let actualColor =   self.shotView.backgroundColor
        let dayColor = ColorUtil.getColorOfTheDay()
        var willChange = false
        if actualColor?.description != dayColor.description
        {
            debugPrint(logTag + "colors are different.")
            willChange = true
        }
        debugPrint("colors  actual :\(actualColor?.description) dayColor : \( dayColor.description)")
        dispatch_async(dispatch_get_main_queue()) {
            self.view.layoutIfNeeded()
            UIView.animateWithDuration(0.1, animations: {
                if willChange {
                    debugPrint(self.logTag + " will change.")
                    self.shotView.backgroundColor = dayColor
                    self.screenView.backgroundColor = dayColor
                    self.setLabelTextWithWordModel()
                    self.setTextFieldColors()
                }
                //self.labelUnderlinedWord.text = "selam"
                self.view.layoutIfNeeded()
            })
        }
    }
    deinit {
        // code here...
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //# MARK: - Button Actions
    //--------------------------------------------//
    //  BUTTON ACTIONS
    //--------------------------------------------//
    
    // image audio tapped
    func imgAudioTapped(img: AnyObject){
        debugPrint(logTag + "image audio is tapped." )
        setTextToSpeech(wordTableModel.enWord)
    }
    
    // image settings tapped
    func imgSettingsBoxTapped(img: AnyObject){
        debugPrint(logTag + "image settings is tapped." )
       // self.performSegueWithIdentifier(self.wordToSettingControllerSegueIdentifier, sender: nil)
        redirectToSetting()

    }
    
    // view meaning tapped
    func viewMeaningTapped(img: AnyObject){
        debugPrint(logTag + "view meaning is tapped." )
        if isEnDefinition {
            dispatch_async(dispatch_get_main_queue()) {
                self.view.layoutIfNeeded()
                UIView.animateWithDuration(0.1, animations: {
                   self.textMeaning.text = self.wordTableModel.trDefinition
                    if self.deviceType == UIUserInterfaceIdiom.Pad {
                        self.textMeaning.font = UIFont(name: "Zapf Dingbats", size: 24)
                    }
                    else {
                        self.textMeaning.font = UIFont(name: "Zapf Dingbats", size: 14)
                    }
                    self.view.layoutIfNeeded()
                    self.isEnDefinition = false
                    self.setTextFieldColors()
                })
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue()) {
                self.view.layoutIfNeeded()
                UIView.animateWithDuration(0.1, animations: {
                    self.textMeaning.text = self.wordTableModel.enDefinition
                  //  let name = self.textMeaning.font?.fontName
                    if self.deviceType == UIUserInterfaceIdiom.Pad {
                        self.textMeaning.font = UIFont(name: "Zapf Dingbats", size: 24)
                    }
                    else {
                        self.textMeaning.font = UIFont(name: "Zapf Dingbats", size: 14)
                    }
                    self.view.layoutIfNeeded()
                    self.isEnDefinition = true
                    self.setTextFieldColors()
                })
            }
            
        }
    }
    // view sentence tapped
    func viewSentenceTapped(img: AnyObject){
        debugPrint(logTag + "view sentence is tapped." )
        if isEnSentence {
            dispatch_async(dispatch_get_main_queue()) {
                self.view.layoutIfNeeded()
                UIView.animateWithDuration(0.1, animations: {
                    self.textSentence.text = self.wordTableModel.trSentence
                 //   let name = self.textSentence.font?.fontName
                    if self.deviceType == UIUserInterfaceIdiom.Pad {
                     self.textSentence.font = UIFont(name: "Zapf Dingbats", size: 24)
                    }
                    else {
                     self.textSentence.font = UIFont(name: "Zapf Dingbats", size: 14)
                    }
                    self.view.layoutIfNeeded()
                    self.isEnSentence = false
                    self.setTextFieldColors()
                })
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue()) {
                self.view.layoutIfNeeded()
                UIView.animateWithDuration(0.1, animations: {
                    self.textSentence.text = self.wordTableModel.enSentence
                    //let name = self.textSentence.font?.fontName
                    if self.deviceType == UIUserInterfaceIdiom.Pad {
                        self.textSentence.font = UIFont(name: "Zapf Dingbats", size: 24)
                    }
                    else {
                        self.textSentence.font = UIFont(name: "Zapf Dingbats", size: 14)
                    }
                    self.view.layoutIfNeeded()
                    self.isEnSentence = true
                    self.setTextFieldColors()
                })
            }
        }
    }
    
    //# MARK: - Share Buttons
    //button facebook share
    @IBAction func btnFacebookShareTapped(sender: FacebookButton) {
        debugPrint(logTag + "Button facebook is tapped." )
        //check network connection
        let isNetAvailable =  hasConnectivity()
        //net is available
        if isNetAvailable {
            debugPrint(logTag + "Net Is Available.")
            let facebookShare : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            let word = self.labelUnderlinedWord.text
            let initialText : String = "Bugünün kelimesi \(word) via @wordly_app"
            facebookShare.setInitialText(initialText)
            //take screenshot
            let image = self.shotView.takeScreenShot()
            facebookShare.addImage(image)
            self.presentViewController(facebookShare, animated: true, completion: nil)
        }
        //net is not available.
        else {
            debugPrint(logTag + "Net Is Not Available.")
            dispatch_async(dispatch_get_main_queue()) {
                self.view.makeToast(message : WarningUtil.connectInternet)
            }
        }
    }
    
    //button twitter share
    @IBAction func btnTwitterShareTapped(sender: TwitterButton) {
        debugPrint(logTag + "Button twitter is tapped." )
        //check network connection
        let isNetAvailable =  hasConnectivity()
        //net is available
        if isNetAvailable {
            debugPrint(logTag + "Net Is Available.")
            let twitterShare : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            let word = self.labelUnderlinedWord.text
            let initialText : String = "Bugünün kelimesi \(word) via @wordly_app"
            twitterShare.setInitialText(initialText)
            //take screenshot
            let image = self.shotView.takeScreenShot()
            twitterShare.addImage(image)
            self.presentViewController(twitterShare, animated: true, completion: nil)
        }
            //net is not available.
        else {
            debugPrint(logTag + "Net Is Not Available.")
            dispatch_async(dispatch_get_main_queue()) {
                self.view.makeToast(message : WarningUtil.connectInternet)
            }
        }
        
    }
    
    //# MARK: - Set Speech
    //--------------------------------------------------------
    //  SET TEXT TO SPEECH
    //--------------------------------------------------------
    private func setTextToSpeech(word : String) {
        dispatch_async(dispatch_get_main_queue()) {
            let utterance = AVSpeechUtterance(string: word)
            utterance.voice = AVSpeechSynthesisVoice(language: "en")
            // utterance.rate = 1
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speakUtterance(utterance)
        }
    }
    
    
    //# MARK: - Read User Data
    //-----------------------------------
    // READ LAST USER
    //-----------------------------------
    
    private func getNotificationUser() -> RegisteredUser?{
        
        let type = UserPrefence.readLastUserType()
        
        switch type {
            
        case .mail:
            debugPrint(logTag + " Mail user is read for frequency." )
            return   UserPrefence.readMailUserData()
        case .facebook:
            debugPrint(logTag + " Facebook user is read for frequency." )
            return UserPrefence.readFacebookUserData()
        case .twitter :
             debugPrint(logTag + " Twitter user is read for frequency." )
            return  UserPrefence.readTwitterUserData()
        // #TODO - if undefined user is read....
        case .undefined :
            return nil
        }
            }
    
    
    private func getUserLevel() -> UserLevel{
        let type = UserPrefence.readLastUserType()
        
        switch type {
            
        case .mail:
            debugPrint(logTag + " Mail user level is reading." )
            return   UserPrefence.readMailUserData().userLevel
            
        case .facebook:
            debugPrint(logTag + " Facebook user level is reading." )
            return   UserPrefence.readFacebookUserData().userLevel
            
        case .twitter :
            debugPrint(logTag + " Twitter user level is reading." )
            return   UserPrefence.readTwitterUserData().userLevel
         
        case .undefined :
             debugPrint(logTag + " unSelected user level is reading." )
            return UserLevel.unSelected
        }
    }
    
    //# MARK: - Database
    //-------------------------------------------
    // DATABASE
    //-------------------------------------------
    
    private func getSystemDateFormatted() -> String{
        let systemDate = NSDate()
        debugPrint("date test \(systemDate)")
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateStr = formatter.stringFromDate(systemDate)
        return dateStr
    }
    
    private func getWordModel(level:UserLevel, formattedDate:String)->WordTableModel{
        
        switch level {
        case .beginner:
            let model1 =  DatabaseUtil.selectEntityByDate(.beginner, date: formattedDate)
            debugPrint("date formatted \(formattedDate)")
            debugPrint("Test with date = beginner :  \(model1)")
            return model1
        case .intermediate:
            let model2 = DatabaseUtil.selectEntityByDate(.intermediate, date: formattedDate)
            debugPrint("date formatted \(formattedDate)")
            debugPrint("Test with date = beginner :  \(model2)")
            return model2
        case .advanced :
            let model3 =  DatabaseUtil.selectEntityByDate(.advanced, date: formattedDate)
            debugPrint("date formatted \(formattedDate)")
            debugPrint("Test with date = beginner :  \(model3)")
            return model3
            //# TODO: Handle
        case .unSelected :
            let model4 =  DatabaseUtil.selectEntityByDate(.beginner, date: formattedDate)
            debugPrint("date formatted \(formattedDate)")
            debugPrint("Test with date = beginner :  \(model4)")
            return model4        }
    }
    
    //# MARK: - Set Gesture The Views
    //----------------------------------------------
    // TAPPED
    //---------------------------------------------
    private func addTappedTo(){
        //image audio
        let imgAudioTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(WordController.imgAudioTapped(_:)))
        imgAudio.userInteractionEnabled = true
        imgAudio.addGestureRecognizer(imgAudioTapGestureRecognizer)
        
        //view meaning
        let viewMeaningTapGestureRecognizer =  UITapGestureRecognizer(target:self, action:#selector(WordController.viewMeaningTapped(_:)))
        viewMeaning.userInteractionEnabled = true
        viewMeaning.addGestureRecognizer(viewMeaningTapGestureRecognizer)
        
        //view sentence
        let viewSentenceTapGestureRecognizer =  UITapGestureRecognizer(target:self, action:#selector(WordController.viewSentenceTapped(_:)))
        viewSentence.userInteractionEnabled = true
        viewSentence.addGestureRecognizer(viewSentenceTapGestureRecognizer)
        
        //image settings
        let imgSettingsBoxTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(WordController.imgSettingsBoxTapped(_:)))
        viewImgSettingBox.userInteractionEnabled = true
        viewImgSettingBox.addGestureRecognizer(imgSettingsBoxTapGestureRecognizer)
        
    }
    
    //------------------------------------------//
    //  SET STYLES
    //------------------------------------------//
    
    //# MARK: - Set Styles
    //-----------------------------------------
    //  SET BACKGROUDN VIEWS
    //------------------------------------------
    private func setViewsBackground() {
        self.screenView.backgroundColor = ColorUtil.getColorOfTheDay()
        self.shotView.backgroundColor = ColorUtil.getColorOfTheDay()
        
        
    }
    //set color of text fields
    private func setTextFieldColors(){
        self.textSentence.textColor = UIColor.whiteColor()
        self.textMeaning.textColor = UIColor.whiteColor()
    }
    //set sentence text fontsize
    private func setSentenceTextFontSize() {
        if self.deviceType == UIUserInterfaceIdiom.Pad {
            self.textSentence.font = UIFont(name: "Zapf Dingbats", size: 24)
        }
        else {
            self.textSentence.font = UIFont(name: "Zapf Dingbats", size: 14)
        }
    
    }
    
    //# MARK: - Set Text
    //----------------------------------------
    // SET TEXT
    //---------------------------------------
    private func setLabelTextWithWordModel() {
        let level =  getUserLevel()
        
        self.wordTableModel = getWordModel(level, formattedDate: getSystemDateFormatted())
        self.labelTrWord.text = wordTableModel.trWord
        self.textSentence.text = wordTableModel.enSentence
        self.textMeaning.text = wordTableModel.enDefinition
        self.labelUnderlinedWord.text = wordTableModel.enWord
        debugPrint("WORD MODEL TEST \(wordTableModel.trWord) \(wordTableModel.enWord)")
    }
    
    //# MARK: - Set Borders
    //set button border
    private func setBorders(){
        ColorUtil.borderButtonDefaultRadius(self.btnFacebook, uiColor: ColorUtil.facebookButtonBorder)
        ColorUtil.borderButtonDefaultRadius(self.btnTwitter, uiColor: ColorUtil.twitterButtonBorder)
    }
    
    //# MARK: - Class Variables / Members
    private final let logTag : String = "WordController "
    private final let wordToSettingControllerSegueIdentifier : String = "segueWordToSetting"
    let deviceType : UIUserInterfaceIdiom = UIDevice.currentDevice().userInterfaceIdiom
    
    @IBOutlet weak var shotView: UIView!
    @IBOutlet weak var screenView: UIView!
    
    @IBOutlet weak var labelUnderlinedWord: UnderlinedLabel!
    @IBOutlet weak var labelTrWord: UILabel!
    @IBOutlet weak var textSentence: VerticallyCenteredTextView!
    @IBOutlet weak var textMeaning: VerticallyCenteredTextView!
    
    @IBOutlet weak var imgAudio: UIImageView!
    @IBOutlet weak var viewImgSettingBox: UIView!
    
    @IBOutlet weak var viewMeaning: UIView!
    @IBOutlet weak var viewSentence: UIView!
    
    @IBOutlet weak var btnTwitter: TwitterButton!
    @IBOutlet weak var btnFacebook: FacebookButton!
    
    // VerticallyCenteredTextView
    
    var wordTableModel = WordTableModel()
    var isEnSentence = true
    var isEnDefinition = true
    
    //# MARK: - Lifecycle methods
    override func viewWillAppear(animated: Bool) {
        debugPrint(logTag + "viewWillAppear()")
        //GAI
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Word Controller")
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
    
    private func redirectToSetting() {
       
        let topController = self.topMostController()
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("SettingControllerID") as! SettingController
        topController.presentViewController(vc, animated: true, completion: nil)
    }
    
        
}
