//
//  UserAgreementController.swift
//  Wordly
//
//  Created by eposta developer on 11/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import UIKit

class UserAgreementController : BaseContoller {
    
    
    //# MARK: - viewDidLoad()
    override func viewDidLoad() {
        debugPrint(logTag + "viewDidLoad()")
        let uaTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(UserAgreementController.uaBackTextTapped(_:)))
        self.viewImgBackUserAgreement.userInteractionEnabled = true
        self.viewImgBackUserAgreement.addGestureRecognizer(uaTapGestureRecognizer)
        //load html file
        loadHtmlToWebView()
    }
    

    //# MARK: - Button Actions
    //tapped back text
    //User Agreement Back Image Tapped Click
    func uaBackTextTapped(img: AnyObject)
    {
        debugPrint("UserAgreemnet back is tapped.")
        if let userAgreementControllerToLogin = storyboard!.instantiateViewControllerWithIdentifier("LoginID") as? LoginController {
            presentViewController(userAgreementControllerToLogin, animated: true, completion: nil)

    }
   
}
 
    //# MARK: -Load Html File
    //load html file from resources to web view
    private func loadHtmlToWebView()->(){
        // load HTML String with Encoding
        let path = NSBundle.mainBundle().pathForResource("index", ofType: "html")
        do {
            let fileHtml = try NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
            webViewUserAgreement.loadHTMLString(fileHtml as String, baseURL: nil)
        }
        catch {
            debugPrint("index.html reading problem")
        }
    }

    //# MARK: - Class Variables / Members
    private final let logTag : String = "UserAgreementController "
    
    @IBOutlet weak var webViewUserAgreement: UIWebView!
    @IBOutlet weak var viewImgBackUserAgreement: UIView!
    
    
    //# MARK: - Lifecycle methods
    override func viewWillAppear(animated: Bool) {
        debugPrint(logTag + "viewWillAppear()")
        //GAI
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "UserAgreement Controller")
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

