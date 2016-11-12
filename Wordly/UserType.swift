//
//  UserType.swift
//  Wordly
//
//  Created by eposta developer on 12/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

enum UserType : String {

    case undefined = "undefined"
    case  mail = "mail"
    case facebook = "facebook"
    case twitter = "twitter"
    
    init(type: String) {
        if type.lowercaseString == "mail" {
            self = .mail
            return
        } else if type.lowercaseString == "facebook" {
            self = .facebook
            return
        }
        else if type.lowercaseString == "twitter"  {
            self = .twitter
        return
        }
        else {
        self = .undefined
            return
        }
    }
}