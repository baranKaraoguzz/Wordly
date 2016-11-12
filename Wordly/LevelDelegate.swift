//
//  LevelDelegate.swift
//  Wordly
//
//  Created by eposta developer on 12/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation
//TAKE DATA FROM SERVICE , SENDS DATA TO CONTROLLER
protocol LevelDelegate : class {
    
    func getSelectLevelResponseModel (model : SelectLevelResponse)

    
}