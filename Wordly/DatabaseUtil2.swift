//
//  DatabaseUtil.swift
//  Wordly
//
//  Created by eposta developer on 14/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation
import CoreData



struct DatabaseUtil2 {
    
    
    //# MARK: - Select Methods
    //select entity with date
    static func selectEntityByDate(entityType : EntityName, date : String) ->
        
        
        WordTableModel {
            switch entityType {
            case .beginner:
                return selectBeginnerByDate(date)
            case .intermediate:
                return selectIntermediateByDate(date)
            case .advanced:
                return selectAdvancedByDate(date)
            }
            
    }
    
    
    //select all entity with name
    static func selectAllEntity(entityType : EntityName) -> [WordTableModel] {
        
        
        switch entityType {
        case .beginner:
            return    selectAllBeginnerEntity()
            
        case .intermediate:
            return   selectAllIntermediateEntity()
            
        case .advanced:
            return    selectAllAdvancedEntity()
            
        }
        
    }
    
    
    //date#level#eng-word#tr-word#eng-definition#tr-definition#eng-sentence#tr-sentence
    
    //select beginner entity with date
    private static func selectBeginnerByDate (date: String) -> BeginnerModel {
        
        let request = NSFetchRequest(entityName: EntityName.beginner.rawValue)
        let condition = NSPredicate(format: "date = %@", date)
        request.predicate = condition
        let model : BeginnerModel = BeginnerModel()
        do {
            let result = try managedObjectContext.executeFetchRequest(request)
            if result.count > 0 {
                let beginner = result[0] as! Beginner
                model.date = beginner.date!
                model.level = beginner.level!
                model.enWord = beginner.en_word!
                model.trWord = beginner.tr_word!
                model.enDefinition = beginner.en_definition!
                model.trDefinition = beginner.tr_definition!
                model.enSentence = beginner.en_sentence!
                model.trSentence = beginner.tr_sentence!
            }
            else {
                debugPrint(logTag + "No beginner word is found by the date.")
            }
        }
        catch let ed as NSError {
            debugPrint(logTag + "select beginner by date : \(ed.localizedDescription)")
            
        }
        return model
        
    }
    
    //select intermediate entity with date
    private static func selectIntermediateByDate (date: String) -> IntermediateModel {
        
        let request = NSFetchRequest(entityName: EntityName.intermediate.rawValue)
        let condition = NSPredicate(format: "date = %@", date)
        request.predicate = condition
        let model : IntermediateModel = IntermediateModel()
        do {
            let result = try managedObjectContext.executeFetchRequest(request)
            if result.count > 0 {
                let inetermediate = result[0] as! Intermediate
                model.date = inetermediate.date!
                model.level = inetermediate.level!
                model.enWord = inetermediate.en_word!
                model.trWord = inetermediate.tr_word!
                model.enDefinition = inetermediate.en_definition!
                model.trDefinition = inetermediate.tr_definition!
                model.enSentence = inetermediate.en_sentence!
                model.trSentence = inetermediate.tr_sentence!
            }
            else {
                debugPrint(logTag + "No intermediate word is found by the date.")
            }
        }
        catch let ed as NSError {
            debugPrint(logTag + "select intermediate by date : \(ed.localizedDescription)")
            
        }
        return model
        
    }
    //select advanced entity with date
    private static func selectAdvancedByDate (date: String) -> AdvancedModel {
        
        let request = NSFetchRequest(entityName: EntityName.advanced.rawValue)
        let condition = NSPredicate(format: "date = %@", date)
        request.predicate = condition
        let model : AdvancedModel = AdvancedModel()
        do {
            let result = try managedObjectContext.executeFetchRequest(request)
            if result.count > 0 {
                let advanced = result[0] as! Advanced
                model.date = advanced.date!
                model.level = advanced.level!
                model.enWord = advanced.en_word!
                model.trWord = advanced.tr_word!
                model.enDefinition = advanced.en_definition!
                model.trDefinition = advanced.tr_definition!
                model.enSentence = advanced.en_sentence!
                model.trSentence = advanced.tr_sentence!
            }
            else {
                debugPrint(logTag + "No advanced word is found by the date.")
            }
        }
        catch let ed as NSError {
            debugPrint(logTag + "select advanced by date : \(ed.localizedDescription)")
            
        }
        return model
        
    }
    
    
    
    //select all beginner entities
    private static func selectAllBeginnerEntity() -> [BeginnerModel] {
        
        let beginnerFetch = NSFetchRequest(entityName: EntityName.beginner.rawValue)
        var modelList : [BeginnerModel] = []
        do{
            let fetchedBeginners : [Beginner]  = try managedObjectContext.executeFetchRequest(beginnerFetch) as! [Beginner]
            
            if fetchedBeginners.count > 0 {
                for entity in fetchedBeginners {
                    let model : BeginnerModel = BeginnerModel()
                    model.date = entity.date!
                    model.level = entity.level!
                    model.enWord = entity.en_word!
                    model.trWord = entity.tr_word!
                    model.enDefinition = entity.en_definition!
                    model.trDefinition = entity.tr_definition!
                    model.enSentence = entity.en_sentence!
                    model.trSentence = entity.tr_sentence!
                    modelList.append(model)
                }
                
                // debugPrint("fetched beginner \(word) word = " + word )
            }
            else {
                debugPrint("data is not found for fetching.")
            }
        }
        catch {
            fatalError("sqlite beginner reading problem \(error)")
        }
        
        return modelList
        
    }
    
    //select all intermediate entities
    private static func selectAllIntermediateEntity() -> [IntermediateModel] {
        
        let intermediateFetch = NSFetchRequest(entityName: EntityName.intermediate.rawValue)
        var modelList : [IntermediateModel] = []
        do{
            let fetchedInters : [Intermediate]  = try managedObjectContext.executeFetchRequest(intermediateFetch) as! [Intermediate]
            
            if fetchedInters.count > 0 {
                for entity in fetchedInters {
                    let model : IntermediateModel = IntermediateModel()
                    model.date = entity.date!
                    model.level = entity.level!
                    model.enWord = entity.en_word!
                    model.trWord = entity.tr_word!
                    model.enDefinition = entity.en_definition!
                    model.trDefinition = entity.tr_definition!
                    model.enSentence = entity.en_sentence!
                    model.trSentence = entity.tr_sentence!
                    modelList.append(model)
                }
                
                // debugPrint("fetched beginner \(word) word = " + word )
            }
            else {
                debugPrint("data is not found for fetching.")
            }
        }
        catch {
            fatalError("sqlite intermediate reading problem \(error)")
        }
        
        return modelList
        
    }
    
    //select all intermediate entities
    private static func selectAllAdvancedEntity() -> [AdvancedModel] {
        
        let advancedFetch = NSFetchRequest(entityName: EntityName.advanced.rawValue)
        var modelList : [AdvancedModel] = []
        do{
            let fetchedAdvanceds : [Advanced]  = try managedObjectContext.executeFetchRequest(advancedFetch) as! [Advanced]
            
            if fetchedAdvanceds.count > 0 {
                for entity in fetchedAdvanceds {
                    let model : AdvancedModel = AdvancedModel()
                    model.date = entity.date!
                    model.level = entity.level!
                    model.enWord = entity.en_word!
                    model.trWord = entity.tr_word!
                    model.enDefinition = entity.en_definition!
                    model.trDefinition = entity.tr_definition!
                    model.enSentence = entity.en_sentence!
                    model.trSentence = entity.tr_sentence!
                    modelList.append(model)
                }
                
                // debugPrint("fetched beginner \(word) word = " + word )
            }
            else {
                debugPrint("data is not found for fetching.")
            }
        }
        catch {
            fatalError("sqlite advanced reading problem \(error)")
        }
        
        return modelList
        
    }
    
    //# MARK: - Insert Methods
    // input entitiy data with model
    static func inputEntityData(entityType: EntityName , modelList : [WordTableModel]){
        
        switch entityType {
        case .beginner:
            addAllBeginnerEntity(modelList)
            break
        case .intermediate:
            addAllIntermediateEntity(modelList)
            break
        case .advanced:
            addAllAdvancedEntity(modelList)
            break
        }
    }
    
    
    //save all beginner entities
    private static func addAllBeginnerEntity(modelList : [WordTableModel]){
        
        let entity =  NSEntityDescription.entityForName(EntityName.beginner.rawValue , inManagedObjectContext: managedObjectContext)
        for model in modelList{
            let beginner = Beginner(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            beginner.date = model.date
            beginner.level = model.level
            beginner.en_word = model.enWord
            beginner.tr_word = model.trWord
            beginner.en_definition = model.enDefinition
            beginner.tr_definition = model.trDefinition
            beginner.en_sentence = model.enSentence
            beginner.tr_sentence = model.trSentence
        }
        
        do {
            try managedObjectContext.save()
            debugPrint(logTag + " all beginner entity saved successfully.")
        }
        catch let error as NSError{
            debugPrint(logTag + " beginner save \(error)")
        }
        
    }
    
    //save all intermediate entities
    private static func addAllIntermediateEntity(modelList : [WordTableModel]){
        
        let entity =  NSEntityDescription.entityForName(EntityName.intermediate.rawValue , inManagedObjectContext: managedObjectContext)
        for model in modelList{
            let intermediate = Intermediate(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            intermediate.date = model.date
            intermediate.level = model.level
            intermediate.en_word = model.enWord
            intermediate.tr_word =  model.trWord
            intermediate.en_definition = model.enDefinition
            intermediate.tr_definition = model.trDefinition
            intermediate.en_sentence = model.enSentence
            intermediate.tr_sentence = model.trSentence
        }
        do {
            try managedObjectContext.save()
            debugPrint(logTag + " all intermediate entity saved successfully.")
        }
        catch let error as NSError{
            debugPrint(logTag + " intermediate save \(error)")
        }
        
    }
    //save all advanced entities
    private static func addAllAdvancedEntity(modelList : [WordTableModel]){
        
        let entity =  NSEntityDescription.entityForName(EntityName.advanced.rawValue , inManagedObjectContext: managedObjectContext)
        for model in modelList{
            let advanced = Advanced(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            advanced.date = model.date
            advanced.level = model.level
            advanced.en_word = model.enWord
            advanced.tr_word =  model.trWord
            advanced.en_definition = model.enDefinition
            advanced.tr_definition = model.trDefinition
            advanced.en_sentence = model.enSentence
            advanced.tr_sentence = model.trSentence
        }
        do {
            try managedObjectContext.save()
            debugPrint(logTag + " all advanced entity saved successfully.")
        }
        catch let error as NSError{
            debugPrint(logTag + " advanced save \(error)")
        }
        
    }
    
    //# MARK: - Delete Methods
    //remove all beginner entities
    
    static func removeAllEntityData(entityType: EntityName){
        
        switch entityType {
        case .beginner:
            removeBeginnerEntity()
            break
        case .intermediate:
            removeIntermediateEntity()
            break
        case .advanced:
            removeAdvancedEntity()
            break
        }
    }
    
    private static func removeBeginnerEntity(){
        
        let fetchRequest = NSFetchRequest(entityName: EntityName.beginner.rawValue)
        var counter = 0
        do{
            let menuItems = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Beginner]
            for menuItem in menuItems {
             counter += 1
             managedObjectContext.deleteObject(menuItem)
                
            }
            do {
                try managedObjectContext.save()
                   debugPrint( logTag + "beginner \(counter) items are deleted."  )
            }
            catch let ed as NSError{
                debugPrint(logTag + "beginner failed to complete delete process : \(ed.localizedDescription)")
                
            }
        }
        catch let e as NSError{
            debugPrint(logTag + "beginner failed to retrieve record: \(e.localizedDescription)")
        }
    }
    
    //remove all intermediate entities
    private static func removeIntermediateEntity(){
        
        let fetchRequest = NSFetchRequest(entityName: EntityName.intermediate.rawValue)
        do{
            let menuItems = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Intermediate]
            for menuItem in menuItems {
                debugPrint(logTag + "fetched intermediate \(menuItem.en_word) deleted."  )
                managedObjectContext.deleteObject(menuItem)
                
            }
            do {
                try managedObjectContext.save()
                
            }
            catch let ed as NSError{
                debugPrint(logTag + "intermediate failed to complete delete process : \(ed.localizedDescription)")
                
            }
        }
        catch let e as NSError{
            debugPrint(logTag + "intermediate failed to retrieve record: \(e.localizedDescription)")        }
    }
    
    //remove all advanced entities
    private static func removeAdvancedEntity(){
        
        let fetchRequest = NSFetchRequest(entityName: EntityName.advanced.rawValue)
        do{
            let menuItems = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Advanced]
            for menuItem in menuItems {
                debugPrint("fetched advanced \(menuItem.en_word) deleted."  )
                managedObjectContext.deleteObject(menuItem)
                
            }
            do {
                try managedObjectContext.save()
                
            }
            catch let ed as NSError{
                debugPrint(logTag + "advanced failed to complete delete process : \(ed.localizedDescription)")
                
            }
        }
        catch let e as NSError{
            debugPrint(logTag + "advanced failed to retrieve record: \(e.localizedDescription)")
        }
    }
    
    //# MARK: - Class Variables / Members
    private static let logTag : String = "DatabaseUtil "
    private static  let managedObjectContext = DataController().managedObjectContext
    
}