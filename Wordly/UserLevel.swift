//
//  UserLevel.swift
//  Wordly
//
//  Created by eposta developer on 12/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

enum UserLevel : String {
    
  

case unSelected = "unSelected"
    
    case  beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"
    
    
    init(level: String) {
        if level.lowercaseString == "beginner" {
            self = .beginner
        } else if level.lowercaseString == "intermediate"  {
            self = .intermediate
        }
        else if level.lowercaseString == "advanced" {
            self = .advanced
        }
        else {
            self = .unSelected
        }
    }
    
   static func getLevelTR(trLevel: String) -> String{
        if trLevel.lowercaseString == "beginner" {
            return FinalString.BEGINNER_TR
        } else if trLevel.lowercaseString == "intermediate"  {
           return FinalString.INTERMEDIATE_TR
        }
        else if trLevel.lowercaseString == "advanced" {
          return FinalString.ADVANCED_TR
        }
        else {
           return ""
        }
    }

    
}
