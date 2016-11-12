//
//  ForgotPassController.swift
//  Wordly
//
//  Created by eposta developer on 30/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import UIKit


class ForgotPassController : BaseContoller , ForgotDelegate, ErrorDelegate, UITextFieldDelegate{
    
    
    
    //# MARK: - viewDidLoad()
    override func viewDidLoad() {
        debugPrint(logTag + "viewDidLoad()")
        super.viewDidLoad()
        //set delegates
        self.forgotService.errorDelegate = self
        self.forgotService.forgotDelegate = self
        txtFieldEmailFP.delegate = self
        //set style button
        setBorders()
        
        
    }
    
    //# MARK: - Service Delegate Methods
    //--------------------------------------------//
    //  SERVICE DELEGATE METHODS BROUGHT DATA
    //--------------------------------------------//
    
    // TAKES RESPONSE FROM SERVICE
    func getForgotResponseModel(model: CommonModelResponse) {
        
        stopPogress()
        debugPrint(logTag + "Forgot Response data \(model)")
        dispatch_async(dispatch_get_main_queue()) {
            self.txtFieldEmailFP.text = ""
            self.view.makeToast(message : model.message)
        }
    }
    
    //TAKES ERROR MESSAGE FROM SERVICE
    func onError(errorMessage : String)
    {
        stopPogress()
        debugPrint(logTag + "Forgot Error Message \(errorMessage)")
        dispatch_async(dispatch_get_main_queue()) {
            self.view.makeToast(message : errorMessage)
        }
    }
    
    //# MARK: - Button Actions
    //--------------------------------------------//
    //  BUTTON ACTIONS
    //--------------------------------------------//
    
    @IBAction func btnRemindTapped(sender: BlueButton) {
        debugPrint(logTag + "Remind button is tapped.")
       
          let isNetAvailable = hasConnectivity()
          if isNetAvailable {
            debugPrint(logTag + "Net Is Available.")
            // take email and password
            let email : String = self.txtFieldEmailFP.text!
            
            if  email.trimInput() == "" ||  !email.isEmail
            {
                debugPrint(WarningUtil.inValidEmail)
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.makeToast(message : WarningUtil.inValidEmail)
                }
                return
            }
            //call API from here.
            var model : ForgotPassSend = ForgotPassSend()
            model.email = email
            self.forgotService.dispatchForgotData(model)
            showProgressConnecting()
          }
          else {
            debugPrint(logTag + "Net Is Not Available.")
            dispatch_async(dispatch_get_main_queue()) {
                self.view.makeToast(message : WarningUtil.connectInternet)
            }
          }
            }
    
    @IBAction func btnBackToSignTapped(sender: UIButton) {
        debugPrint(logTag + " BackToSign button is tapped.")
        if let forgotControllerToSignIn = storyboard!.instantiateViewControllerWithIdentifier("SignInID") as? SignInController {
            presentViewController(forgotControllerToSignIn, animated: true, completion: nil)}
    }
    
    //# MARK: - Set Styles
    //------------------------------------------//
    //  SET STYLES
    //------------------------------------------//
    
    private func setBorders(){
        ColorUtil.borderButtonDefaultRadius(btnRemind, uiColor: ColorUtil.blueButton)
    }
    
    //# MARK: - Limit TextFiled Input
    //------------------------------------------//
    // LIMIT TEXT FIELD INPUT
    //------------------------------------------//
    
    //Limit Editmail To 50 and Editpassword To 20.
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //An expression works with Swift 2g
        if textField == self.txtFieldEmailFP  {
            return (txtFieldEmailFP.text?.utf16.count ?? 0) + string.utf16.count - range.length <= 50
        }
        return (textField.text?.utf16.count ?? 0) + string.utf16.count - range.length <= 70
    }
    //# MARK: - Hide Keyboard
    //hide keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        txtFieldEmailFP.resignFirstResponder()
        
    }
    
    //# MARK: - Slide Screen Methods
    //--------------------------------------------------------
    //  move up and down textfield
    //--------------------------------------------------------
    
    @IBAction func txtEmailDidBeginEditing(sender: TextField) {
        animateViewMoving(true, moveValue: 100.0)
    }
    
    @IBAction func txtEmailDidEndEditing(sender: TextField) {
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
    private final let logTag : String = "ForgotPassController "
    
    @IBOutlet weak var txtFieldEmailFP: TextField!
    @IBOutlet weak var btnRemind: BlueButton!
    @IBOutlet weak var btnBackToSign: UIButton!
    
    var forgotService : ForgotService = ForgotService()
    
    
    //# MARK: - Lifecycle methods
    override func viewWillAppear(animated: Bool) {
        debugPrint(logTag + "viewWillAppear()")
        //GAI
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "ForgotPass Controller")
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