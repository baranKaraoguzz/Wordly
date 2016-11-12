//
//  EmailDelegate.swift
//  Wordly
//
//  Created by eposta developer on 02/09/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation


//TAKE DATA FROM SERVICE , SENDS DATA TO CONTROLLER
protocol EmailDelegate : class {
    
    func getEmailControlResponseModel (model : EmailControlResponse)
    func getEmailLoginResponseModel(model : EmailLoginResponse)
    
}
