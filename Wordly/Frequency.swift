//
//  Frequency.swift
//  Wordly
//
//  Created by eposta developer on 12/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

enum Frequency :  String {

  //  case freq_0 = "0"
case freq_1 = "1"
case freq_2 = "2"
case freq_3 = "3"
case freq_4 = "4"
case freq_6 = "6"
case freq_8 = "8"
case freq_12 = "12"

    
   static  func getDefault () -> Frequency {
        
     return freq_12
    
    }
    /*
    init(freq: String) {
        if freq.lowercaseString == "1" {
            self = .freq_1
            return
        } else if freq.lowercaseString == "2" {
            self = .freq_2
            return
        }
        else if freq.lowercaseString == "3"  {
            self = .freq_3
            return
        }
        
    
    else if freq.lowercaseString == "4" {
    self = .freq_4
    return
    }
    else if freq.lowercaseString == "6"  {
    self = .freq_6
    return
    }
        else if freq.lowercaseString == "8" {
            self = .freq_8
            return
        }
        else if freq.lowercaseString == "12"  {
            self = .freq_12
            return
        }
            

        else {
            self = .freq_0
            return
        }
    }
    */
}
