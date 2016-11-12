//
//  ChangePassController.swift
//  Wordly
//
//  Created by eposta developer on 01/08/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import UIKit

class ChangePassController : BaseContoller, ErrorDelegate, ChangePassDelegate {


    //# MARK: - viewDidLoad()
    override func viewDidLoad() {
        debugPrint(logTag + "viewDidLoad()")
        super.viewDidLoad()
        debugPrint(logTag + "test \(self.mailUserID)")
        //set delegates
        self.changePassService.changePassDelegate = self
        self.changePassService.errorDelegate = self
    }
    
    //# MARK: - Service Delegate Methods
    //--------------------------------------------//
    //  SERVICE DELEGATE METHODS BROUGHT DATA
    //--------------------------------------------//
    
    // TAKES RESPONSE FROM SERVICE
    func getChangePasswordModel(model: CommonModelResponse) {
        stopPogress()
        debugPrint(logTag + "Response Message \(model.message)")
        dispatch_async(dispatch_get_main_queue()) {
            self.view.makeToast(message : model.message)
        }
        self.textFieldPassword.text = ""
        self.textFieldRePassword.text = ""
            }
    
    //TAKES ERROR MESSAGE FROM SERVICE
    func onError(errorMessage : String)
    {
        // stop progress
        stopPogress()
        debugPrint(logTag + "Change Error Message \(errorMessage)")
        dispatch_async(dispatch_get_main_queue()) {
            self.view.makeToast(message : errorMessage)
        }
    }
    
    //# MARK: - Send Data To Service
    //SEND MODEL TO SERVICE
    
    private func sendChangePassModel(newPass : String){
        var model = ChangePasswordSend()
        model.idMail = self.mailUserID
        model.newPassword = newPass
        self.changePassService.dispatchChangePasswordData(model)
        //show progress
        showProgressConnecting()
      
    }
    
    //# MARK: - Button Actions
    //--------------------------------------------//
    //  BUTTON ACTIONS
    //--------------------------------------------//
    @IBAction func btnBackToSettingTapped(sender: UIButton) {
          debugPrint(logTag + "Button back to setting is tapped.")
        self.performSegueWithIdentifier(self.changePassToSettingControllerSegueIdentifier, sender: nil)
       }
    
    @IBAction func btnChangePassTapped(sender: BlueButton) {
         debugPrint(logTag + "Button change pass is tapped.")
        
        let isNetAvailable =  hasConnectivity()
        if isNetAvailable {
            debugPrint(logTag + "Net Is Available.")
            let pass : String = self.textFieldPassword.text!
            let rePass : String = self.textFieldRePassword.text!
            //there is no change
            if pass.trimInput() == "" || rePass.trimInput() == "" {
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.makeToast(message : WarningUtil.inValidPassword)
                }
                return
            }
            if pass.hasSpecialCharacter {
                debugPrint(logTag + "password has special character.")
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.makeToast(message : WarningUtil.inValidPassword)
                }
                return
            }
            else {
                debugPrint(logTag + "password has not any speacial character..")
              
            }
            if pass.trimInput().characters.count <= 5 {
                debugPrint(WarningUtil.smallPassword)
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.makeToast(message : WarningUtil.smallPassword)
                }
                return
            }
            if pass.trimInput().characters.count > 12  {
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
            //send to service
            sendChangePassModel(pass)
        }
        else {
          debugPrint(logTag + "Net Is not Available.")
            dispatch_async(dispatch_get_main_queue()) {
                self.view.makeToast(message : WarningUtil.connectInternet)
            }
        }
        
        
    }
    
    //# MARK: - Set Borders
    //------------------------------------------//
    //  SET STYLES
    //------------------------------------------//
    
    private func setBorders(){
        ColorUtil.borderButtonDefaultRadius(self.btnChangePass, uiColor: ColorUtil.blueButton)
    }
    
    //# MARK: - Limit TextFiled Input
    //------------------------------------------//
    // LIMIT TEXT FIELD INPUT
    //------------------------------------------//
    
    //Limit  Editpassword To 15.
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //An expression works with Swift 2g
        if textField == self.textFieldRePassword  {
            return (textFieldRePassword.text?.utf16.count ?? 0) + string.utf16.count - range.length <= 15
        }
        
        return (textField.text?.utf16.count ?? 0) + string.utf16.count - range.length <= 70
    }
    
    //# MARK: - Hide Keyboard
    //hide keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        textFieldPassword.resignFirstResponder()
        textFieldRePassword.resignFirstResponder()
        
    }
    
    
    //# MARK: - Slide Screen Methods
    //--------------------------------------------------------
    //  move up and down textfield
    //--------------------------------------------------------
    
    @IBAction func txtFieldPassDidBeginEdit(sender: TextField) {
           animateViewMoving(true, moveValue: 100.0)

    }
    
    @IBAction func txtFieldPassDidEndEdit(sender: TextField) {
          animateViewMoving(false, moveValue: 100.0)
    }
    
    @IBAction func txtFieldRePassDidBeginEdit(sender: TextField) {
          animateViewMoving(true, moveValue: 100.0)
    }
    
    @IBAction func txtFieldRePassDidEndEdit(sender: TextField) {
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
    private final let logTag : String = "ChangePassController "
    private final let changePassToSettingControllerSegueIdentifier : String = "segueChangePassToSetting"
    
    var mailUserID : String = String()
    
    var changePassService : ChangePassService = ChangePassService()
    
    @IBOutlet weak var textFieldPassword: TextField!
    @IBOutlet weak var textFieldRePassword: TextField!
    @IBOutlet weak var btnChangePass: BlueButton!

    
    
    //# MARK: - Lifecycle methods
    override func viewWillAppear(animated: Bool) {
        debugPrint(logTag + "viewWillAppear()")
        //GAI
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "ChangePass Controller")
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
