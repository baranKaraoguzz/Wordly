//
//  ErrorDelegate.swift
//  Wordly
//
//  Created by eposta developer on 30/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation
//TAKE DATA FROM SERVICE , SENDS DATA TO CONTROLLER
protocol ErrorDelegate :class {
    
    func onError(errorMessage : String)
    
}