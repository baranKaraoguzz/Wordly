//
//  ChangePassDelegate.swift
//  Wordly
//
//  Created by eposta developer on 03/08/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

//TAKE DATA FROM SERVICE , SENDS DATA TO CONTROLLER
protocol ChangePassDelegate : class {

 func getChangePasswordModel(model : CommonModelResponse)
    
}
