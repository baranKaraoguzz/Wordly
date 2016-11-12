//
//  CharUtil.swift
//  Wordly
//
//  Created by eposta developer on 28/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

struct CharUtil {
    
    private static let passwordRegex =  "^[a-zA-Z0-9]+$"
    
    internal static func unicodeToChar (unicodeStr : String) -> Character {
        
        let charAsInt = Int(unicodeStr, radix: 16)!
        let uScalar = UnicodeScalar(charAsInt)
        debugPrint("char : \(uScalar)")
        return Character(uScalar)
    }
    
    internal static func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(myString.characters)     // gets an array of characters
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
    
    
    internal static func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matchesInString(text,
                                                options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substringWithRange($0.range)}
        } catch let error as NSError {
            debugPrint("invalid regex: \(error.description)")
            return []
        }
    }
    
    internal static func isMatchedRegexInText(regex: String!, text: String!)  -> Bool {
        
        var matches : [String] = []
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matchesInString(text,
                                                options: [], range: NSMakeRange(0, nsString.length))
            matches = results.map { nsString.substringWithRange($0.range)}
        } catch let error as NSError {
            debugPrint("invalid regex: \(error.description)")
            matches = []
        }
        if matches.count == 0  {
            return false }
        else {return true}
        
    }
    
    internal static func isValidPasswordInText(text: String!)  -> Bool {
        
        var matches : [String] = []
        do {
            let regex = try NSRegularExpression(pattern: passwordRegex, options: [])
            let nsString = text as NSString
            let results = regex.matchesInString(text,
                                                options: [], range: NSMakeRange(0, nsString.length))
            matches = results.map { nsString.substringWithRange($0.range)}
        } catch let error as NSError {
            debugPrint("invalid regex: \(error.description)")
            matches = []
        }
        if matches.count == 0  {
            return false }
        else {return true}
        
    }
    
}
