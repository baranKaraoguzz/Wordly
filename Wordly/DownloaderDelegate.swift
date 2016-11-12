//
//  DownloaderDelegate.swift
//  Wordly
//
//  Created by eposta developer on 18/08/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//


import Foundation


//TAKE DATA FROM SERVICE , SENDS DATA TO CONTROLLER
protocol DownloaderDelegate : class {
    
    func getDownloadedWordsDict(modelDict: [EntityName:[WordTableModel]] )
    
}