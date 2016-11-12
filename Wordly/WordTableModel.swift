//
//  WordTableModel.swift
//  Wordly
//
//  Created by eposta developer on 14/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

class WordTableModel : CustomDebugStringConvertible  {

    var date : String = ""
    var level : String = ""
    var enWord : String = ""
    var trWord : String = ""
    var enDefinition : String = ""
    var trDefinition : String = ""
    var enSentence : String = ""
    var trSentence : String = ""
    
    
    var debugDescription: String {
        let desc = "date : " + date + " level : " + level + " enWord : " + enWord + " trWord : " + trWord + " enDefinition : " + enDefinition + " trDefinition : " + trDefinition + " enSentence : "  + enSentence + " trSentence : "  + trSentence
        return desc
    }
}