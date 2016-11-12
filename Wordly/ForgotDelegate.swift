//
//  ForgotDelegate.swift
//  Wordly
//
//  Created by eposta developer on 13/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

//TAKE DATA FROM SERVICE , SENDS DATA TO CONTROLLER
protocol ForgotDelegate : class {
    
    func getForgotResponseModel (model : CommonModelResponse)
    
    
}