//
//  FileUtil.swift
//  Wordly
//
//  Created by eposta developer on 11/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

enum FileURL : String {

case beginnerList = "wordList_beginner_12_08_2016"
case intermediateList = "wordList_intermediate_12_08_2016"
case advancedList = "wordList_advanced_12_08_2016"
}


struct FileUtil {
    
    private static let logTag : String = "FileUtil "
    
  //read database version from txt file.
    static func readDBVersion () -> String {
        var code : String = ""

        let myFileURL = NSBundle.mainBundle().URLForResource("wordsdbversion", withExtension: "txt")!
        do{
        let myText = try String(contentsOfURL: myFileURL, encoding: NSUTF8StringEncoding)
            debugPrint(String(myText))
            code = myText
        }
        catch let error as NSError {
            debugPrint("Failed reading from URL: \(myFileURL), Error: " + error.localizedDescription)
        }
        return code
            }
    
    //date#level#eng-word#tr-word#eng-definition#tr-definition#eng-sentence#tr-sentence
    //parse csv file  with entity name
    static func parseCSV (entityName : EntityName) -> [WordTableModel]? {
        
        var contentUrl : NSURL
        switch entityName {
        case .beginner:
              contentUrl = NSBundle.mainBundle().URLForResource(FileURL.beginnerList.rawValue, withExtension: "csv")!
            break
        case .intermediate:
            contentUrl = NSBundle.mainBundle().URLForResource(FileURL.intermediateList.rawValue, withExtension: "csv")!
            break
        case .advanced:
            contentUrl = NSBundle.mainBundle().URLForResource(FileURL.advancedList.rawValue, withExtension: "csv")!
            break        
        }
        
        // Load the CSV file and parse it
        let delimiter = "#"
        //var stations:[(stationName:String, stationType:String, stationLineType: String, stationLatitude: String, stationLongitude: String)]?
        var wordTableModels : [WordTableModel] = []
        
        if let data = NSData(contentsOfURL: contentUrl) {
            if let content = NSString(data: data, encoding: NSUTF8StringEncoding) {
                
                let lines:[String] = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
                
                for line in lines {
                    var values:[String] = []
                    if line != "" {
                        // For a line with double quotes
                        // we use NSScanner to perform the parsing
                        if line.rangeOfString("\"") != nil {
                            var textToScan:String = line
                            var value:NSString?
                            var textScanner:NSScanner = NSScanner(string: textToScan)
                            while textScanner.string != "" {
                                
                                if (textScanner.string as NSString).substringToIndex(1) == "\"" {
                                    textScanner.scanLocation += 1
                                    textScanner.scanUpToString("\"", intoString: &value)
                                    textScanner.scanLocation += 1
                                } else {
                                    textScanner.scanUpToString(delimiter, intoString: &value)
                                }
                                
                                // Store the value into the values array
                                values.append(value as! String)
                                
                                // Retrieve the unscanned remainder of the string
                                if textScanner.scanLocation < textScanner.string.characters.count {
                                    textToScan = (textScanner.string as NSString).substringFromIndex(textScanner.scanLocation + 1)
                                } else {
                                    textToScan = ""
                                }
                                textScanner = NSScanner(string: textToScan)
                            }
                            
                            // For a line without double quotes, we can simply separate the string
                            // by using the delimiter (e.g. comma)
                        } else  {
                            values = line.componentsSeparatedByString(delimiter)
                        }
                      
                       let word : WordTableModel = WordTableModel()
                       word.date = values[0]
                       word.level = values[1]
                       word.enWord = values[2]
                       word.trWord = values[3]
                       word.enDefinition = values[4]
                       word.trDefinition = values[5]
                       word.enSentence = values[6]
                       word.trSentence = values[7]
                    //    debugPrint(logTag + "Parse = \(word)")
                       wordTableModels.append(word)
                    }
                }
                
                
                return wordTableModels
            }
        }
  return wordTableModels
    }
    
    
    static func parseByteModelList(contentUrl : NSURL) -> [EntityName: [WordTableModel] ]{
      //  let delimiter = "$"
        var wordListByLevelDict = [EntityName: [WordTableModel] ]()
        
        if let data = NSData( contentsOfURL: contentUrl ) {
            if let content = NSString(data: data, encoding: NSUTF8StringEncoding) {
                let stringContent : String = String(content)
                let values = stringContent.characters.split{$0 == "$"}.map(String.init)
                debugPrint("count \(values.count)")
                let beginnerModel = createModelsFromString(values[0])
                let intermediateModel = createModelsFromString(values[1])
                let advancedModel = createModelsFromString(values[2])
               wordListByLevelDict[.beginner] = beginnerModel
               wordListByLevelDict[.intermediate] = intermediateModel
               wordListByLevelDict[.advanced] = advancedModel
                
            }
        }
        return wordListByLevelDict
    }
    
    private static func createModelsFromString(wordList:String) -> [WordTableModel] {
        let delimiter = "#"
        var wordTableModels : [WordTableModel] = []
      
        let content = NSString(string: wordList)
        let lines : [String] = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
        for line in lines  {
            var values:[String] = []
            if line != "" {
                // For a line with double quotes
                // we use NSScanner to perform the parsing
                if line.rangeOfString("\"") != nil {
                    var textToScan:String = line
                    var value:NSString?
                    var textScanner:NSScanner = NSScanner(string: textToScan)
                    while textScanner.string != "" {
                        
                        if (textScanner.string as NSString).substringToIndex(1) == "\"" {
                            textScanner.scanLocation += 1
                            textScanner.scanUpToString("\"", intoString: &value)
                            textScanner.scanLocation += 1
                        } else {
                            textScanner.scanUpToString(delimiter, intoString: &value)
                        }
                        
                        // Store the value into the values array
                        values.append(value as! String)
                        
                        // Retrieve the unscanned remainder of the string
                        if textScanner.scanLocation < textScanner.string.characters.count {
                            textToScan = (textScanner.string as NSString).substringFromIndex(textScanner.scanLocation + 1)
                        } else {
                            textToScan = ""
                        }
                        textScanner = NSScanner(string: textToScan)
                    }
                    
                    // For a line without double quotes, we can simply separate the string
                    // by using the delimiter (e.g. comma)
                } else  {
                    values = line.componentsSeparatedByString(delimiter)
                }
                
                let word : WordTableModel = WordTableModel()
                word.date = values[0]
                word.level = values[1]
                word.enWord = values[2]
                word.trWord = values[3]
                word.enDefinition = values[4]
                word.trDefinition = values[5]
                word.enSentence = values[6]
                word.trSentence = values[7]
                //    debugPrint(logTag + "Parse = \(word)")
                wordTableModels.append(word)
            }
        }
        return wordTableModels
        
    }
    
    //parse string bytes file  with entity name
    static func parseByteString (contentUrl : NSURL) -> [WordTableModel]? {
        
        
        // Load the CSV file and parse it
        let delimiter = "#"
        //var stations:[(stationName:String, stationType:String, stationLineType: String, stationLatitude: String, stationLongitude: String)]?
        var wordTableModels : [WordTableModel] = []
        
        if let data = NSData(contentsOfURL: contentUrl) {
            if let content = NSString(data: data, encoding: NSUTF8StringEncoding) {
               
                let lines:[String] = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
                
                for line in lines {
                    var values:[String] = []
                    if line != "" {
                        // For a line with double quotes
                        // we use NSScanner to perform the parsing
                        if line.rangeOfString("\"") != nil {
                            var textToScan:String = line
                            var value:NSString?
                            var textScanner:NSScanner = NSScanner(string: textToScan)
                            while textScanner.string != "" {
                                
                                if (textScanner.string as NSString).substringToIndex(1) == "\"" {
                                    textScanner.scanLocation += 1
                                    textScanner.scanUpToString("\"", intoString: &value)
                                    textScanner.scanLocation += 1
                                } else {
                                    textScanner.scanUpToString(delimiter, intoString: &value)
                                }
                                
                                // Store the value into the values array
                                values.append(value as! String)
                                
                                // Retrieve the unscanned remainder of the string
                                if textScanner.scanLocation < textScanner.string.characters.count {
                                    textToScan = (textScanner.string as NSString).substringFromIndex(textScanner.scanLocation + 1)
                                } else {
                                    textToScan = ""
                                }
                                textScanner = NSScanner(string: textToScan)
                            }
                            
                            // For a line without double quotes, we can simply separate the string
                            // by using the delimiter (e.g. comma)
                        } else  {
                            values = line.componentsSeparatedByString(delimiter)
                        }
                        
                        let word : WordTableModel = WordTableModel()
                        word.date = values[0]
                        word.level = values[1]
                        word.enWord = values[2]
                        word.trWord = values[3]
                        word.enDefinition = values[4]
                        word.trDefinition = values[5]
                        word.enSentence = values[6]
                        word.trSentence = values[7]
                        //    debugPrint(logTag + "Parse = \(word)")
                        wordTableModels.append(word)
                    }
                }
                
                
                return wordTableModels
            }
        }
        return wordTableModels
    }

    
    
    
    
    
}