//
//  SideFrequencyController.swift
//  Wordly
//
//  Created by eposta developer on 02/08/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import UIKit

class SideFrequencyController : BaseContoller, UITableViewDelegate, UITableViewDataSource {


    //# MARK: - viewDidLoad()
    override func viewDidLoad() {
        debugPrint(logTag + "viewDidLoad()")
        super.viewDidLoad()
       //register custom cell
        registerCustomCell()
       
    }
    
    //# MARK: - TableView Delegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableFrequencyData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : TblViewCellFrequency = self.tableFrequency.dequeueReusableCellWithIdentifier("frequencyCell") as! TblViewCellFrequency
        cell.lblFreq.text = tableFrequencyData[indexPath.row]
       // cell.imgTick.hidden = true
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        debugPrint("Row \(indexPath.row) selected.")
        self.notifyFrequency = self.listOfNotificationFrequency[indexPath.row]
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TblViewCellFrequency
        cell.imgTick.hidden = false
        dispatch_async(dispatch_get_main_queue()) {
         self.view.layoutIfNeeded()
         UIView.animateWithDuration(1, animations: {
              self.performSegueWithIdentifier(self.sideFrequencyToSettingControllerIdentifier, sender: nil)
         self.view.layoutIfNeeded()
         })
         }
                 
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    
    //# MARK: - Register Custom Cell
    private func registerCustomCell () {
    
    let nib = UINib(nibName: "tblCellFrequency", bundle: nil)
     self.tableFrequency.registerNib(nib, forCellReuseIdentifier: "frequencyCell")
    
    }
    
    
    //# MARK: - Send Data Setting Controller
    //------------------------------------------
    //  SEND DATA TO CONTROLLER
    //------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == self.sideFrequencyToSettingControllerIdentifier) {
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            let destinationSettingCont = segue.destinationViewController as! SettingController;
            destinationSettingCont.notificationFrequency = self.notifyFrequency
        }
    }
    
    
    //# MARK: - Class Variables / Members
    private final let logTag : String = "SideFrequencyController "
    private final let sideFrequencyToSettingControllerIdentifier = "segueSideFrequencyToSetting"
    private let tableFrequencyData : [String] = ["Günde 1 Kez","Günde 2 Kez","Günde 3 Kez","Günde 4 Kez","Günde 6 Kez","Günde 8 Kez","Günde 12 Kez"]
    private let listOfNotificationFrequency : [String] = ["1","2","3","4","6","8","12"]
      private var notifyFrequency : String = ""
    
    
    @IBOutlet weak var tableFrequency : UITableView!
    
       
    
    //# MARK: - Lifecycle methods
    override func viewWillAppear(animated: Bool) {
        debugPrint(logTag + "viewWillAppear()")
        //GAI
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "SideFrequency Controller")
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
