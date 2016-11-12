//
//  SideLevelController.swift
//  Wordly
//
//  Created by eposta developer on 04/08/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import UIKit

class SideLevelController : BaseContoller {



    //# MARK: - viewDidLoad()
    override func viewDidLoad() {
        debugPrint(logTag + "viewDidLoad()")
        super.viewDidLoad()
        //add to view's gestures
        addTappedTo()
        
    }
    
    @IBAction func beginnerLViewTapped(sender : AnyObject) {
    debugPrint(logTag + "beginner selected")
        self.level = UserLevel.beginner.rawValue
        dispatch_async(dispatch_get_main_queue()) {
            self.view.layoutIfNeeded()
            UIView.animateWithDuration(1, animations: {
                self.performSegueWithIdentifier(self.sideLevelToSettingControllerSegueIdentifier, sender: nil)
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
    @IBAction func intermediateLViewTapped(sender : AnyObject)
    {
        self.level = UserLevel.intermediate.rawValue
         debugPrint(logTag + "intermediate selected")
        dispatch_async(dispatch_get_main_queue()) {
            self.view.layoutIfNeeded()
            UIView.animateWithDuration(1, animations: {
                self.performSegueWithIdentifier(self.sideLevelToSettingControllerSegueIdentifier, sender: nil)
                self.view.layoutIfNeeded()
            })
        }
    
    }
    
    @IBAction func advancedLViewTapped(sender : AnyObject){
        self.level = UserLevel.advanced.rawValue
     debugPrint(logTag + "advanced selected")
        dispatch_async(dispatch_get_main_queue()) {
            self.view.layoutIfNeeded()
            UIView.animateWithDuration(1, animations: {
                self.performSegueWithIdentifier(self.sideLevelToSettingControllerSegueIdentifier, sender: nil)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    //----------------------------------------------
    //# MARK: - Set Gesture The Views
    //---------------------------------------------
    private func addTappedTo(){
        //beginner view
        let beginnerLViewTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(SideLevelController.beginnerLViewTapped(_:)))
        beginnerLView.userInteractionEnabled = true
        beginnerLView.addGestureRecognizer(beginnerLViewTapGestureRecognizer)
        //signIn label
        let intermediateLViewTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(SideLevelController.intermediateLViewTapped(_:)))
        intermediateLView.userInteractionEnabled = true
        intermediateLView.addGestureRecognizer(intermediateLViewTapGestureRecognizer)
        //signIn label
        let advancedViewLTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(SideLevelController.advancedLViewTapped(_:)))
        advancedLView.userInteractionEnabled = true
        advancedLView.addGestureRecognizer(advancedViewLTapGestureRecognizer)
    }
    
    
    //# MARK: - Send Data Setting Controller
    //------------------------------------------
    //  SEND DATA TO CONTROLLER
    //------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == self.sideLevelToSettingControllerSegueIdentifier) {
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            let destinationCont = segue.destinationViewController as! SettingController;
            destinationCont.selectedLevel = self.level
        }
    }
    
    //# MARK: - Class Variables / Members
    private final let logTag : String = "SideLevelController "
    private final let sideLevelToSettingControllerSegueIdentifier : String = "segueSideLevelToSetting"
    
    private var level : String = ""
    @IBOutlet weak var beginnerLView: UIView!
    @IBOutlet weak var intermediateLView: UIView!
    @IBOutlet weak var advancedLView: UIView!

    
    //# MARK: - Lifecycle methods
    override func viewWillAppear(animated: Bool) {
        debugPrint(logTag + "viewWillAppear()")
        //GAI
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "SideLevel Controller")
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
