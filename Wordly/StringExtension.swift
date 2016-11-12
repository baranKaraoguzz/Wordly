//
//  StringExtension.swift
//  Wordly
//
//  Created by eposta developer on 11/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

extension String {
    
    //Checks blank inputs
    func trimInput() ->String{
       let trimmed =  self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        return trimmed
        
       
    }
    /*
    var hasWhiteSpace : Bool {
    
        let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
        if self.stringByTrimmingCharactersInSet(whitespaceSet) != "" {
            // string contains non-whitespace characters
            debugPrint("String has whitespace characters.")
            return true
        }
        else {
            debugPrint("String has not whitespace characters.")
        return false
        }
    }
    */
    //validate email address
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .CaseInsensitive)
            return regex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    var hasSpecialCharacter : Bool {
        do {
        let regex = try NSRegularExpression(pattern: "[^A-Za-z0-9]" , options: .CaseInsensitive)
            return regex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        }catch {
        return false
        }
    }
    
    var hasWhiteSpace : Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[\\s]", options: .CaseInsensitive)
            return regex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        }
        catch {
        return false
        }
    
    }
    
}