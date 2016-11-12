//
//  ConnectionDelegate.swift
//  Wordly
//
//  Created by eposta developer on 30/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

//TAKES DATA FROM CONNECTION , SENDS DATA TO ALL SERVICES
protocol  ConnectionDelegate : class {
    
    func getError(errMessage : String)
    func getJson(subDomain: String, jsonData : NSData)
}
