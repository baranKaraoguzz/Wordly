//
//  FaceTweetDelegate.swift
//  Wordly
//
//  Created by eposta developer on 29/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

//TAKE DATA FROM SERVICE , SENDS DATA TO CONTROLLER
protocol FaceTweetDelegate : class {
    
    func getFaceTweetResponseModel (model : FaceTweetResponse)
    
}
