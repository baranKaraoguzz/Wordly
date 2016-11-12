//
//  DatabaseUtil.swift
//  Wordly
//
//  Created by eposta developer on 14/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation
import CoreData



struct DatabaseUtil {
    
    
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
         let result = try coreDataStack.mainQueueContext!.executeFetchRequest(request)
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
            let result = try coreDataStack.mainQueueContext!.executeFetchRequest(request)
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
            let result = try coreDataStack.mainQueueContext!.executeFetchRequest(request)
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
    
    /*
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
        
    }*/
    
    
    //select all beginner entities
    private static func selectAllBeginnerEntity() -> [BeginnerModel] {
        
        let beginnerFetch = NSFetchRequest(entityName: EntityName.beginner.rawValue)
        var modelList : [BeginnerModel] = []
        do{
            let fetchedBeginners : [Beginner]  = try coreDataStack.mainQueueContext!.executeFetchRequest(beginnerFetch) as! [Beginner]
            var count  = 0
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
                count = modelList.count
                debugPrint(logTag + "\(count) beginner items are fetched." )
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
            let fetchedIntermediates : [Intermediate]  = try coreDataStack.mainQueueContext!.executeFetchRequest(intermediateFetch) as! [Intermediate]
            var count  = 0
            if fetchedIntermediates.count > 0 {
                for entity in fetchedIntermediates {
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
                count = modelList.count
                debugPrint(logTag + "\(count) intermediate items are fetched." )
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
    /*
    //select all advanced entities
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
 */
    
    //select all advanced entities
    private static func selectAllAdvancedEntity() -> [AdvancedModel] {
        
        let advancedFetch = NSFetchRequest(entityName: EntityName.advanced.rawValue)
        var modelList : [AdvancedModel] = []
        do{
            let fetchedAdvanceds : [Advanced]  = try coreDataStack.mainQueueContext!.executeFetchRequest(advancedFetch) as! [Advanced]
            var count  = 0
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
                count = modelList.count
                debugPrint(logTag + "\(count) advanced items are fetched." )
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
    static func saveEntityData(entityType: EntityName , modelList : [WordTableModel]){
        
        switch entityType {
        case .beginner:
            saveAllBeginnerEntity(modelList)
            break
        case .intermediate:
          saveAllIntermediateEntity(modelList)
            break
        case .advanced:
            saveAllAdvancedEntity(modelList)
            break
        }
    }

    
    //save all beginner entities
    private static func saveAllBeginnerEntity(modelList : [WordTableModel]){
        
        if let newPrivateQeueuContext = coreDataStack.newPrivateQueueContext(){
            newPrivateQeueuContext.performBlock {
                var counter = 0
                let entity = NSEntityDescription.entityForName(EntityName.beginner.rawValue, inManagedObjectContext: newPrivateQeueuContext)
                for model in modelList {
                    let beginner = Intermediate(entity: entity!, insertIntoManagedObjectContext: newPrivateQeueuContext)
                    beginner.date = model.date
                    beginner.level = model.level
                    beginner.en_word = model.enWord
                    beginner.tr_word = model.trWord
                    beginner.en_definition = model.enDefinition
                    beginner.tr_definition = model.trDefinition
                    beginner.en_sentence = model.enSentence
                    beginner.tr_sentence = model.trSentence
                    counter += 1
                }
                newPrivateQeueuContext.saveRecursively()
                debugPrint(logTag + "\(counter) beginner items are added.")
            }
        }
    }
    
    
    //save all intermediate entities
    private static func saveAllIntermediateEntity(modelList : [WordTableModel]){
        
        if let newPrivateQeueuContext = coreDataStack.newPrivateQueueContext(){
            newPrivateQeueuContext.performBlock {
                var counter = 0
                let entity = NSEntityDescription.entityForName(EntityName.intermediate.rawValue, inManagedObjectContext: newPrivateQeueuContext)
                for model in modelList {
                    let intermediate = Intermediate(entity: entity!, insertIntoManagedObjectContext: newPrivateQeueuContext)
                    intermediate.date = model.date
                    intermediate.level = model.level
                    intermediate.en_word = model.enWord
                    intermediate.tr_word = model.trWord
                    intermediate.en_definition = model.enDefinition
                    intermediate.tr_definition = model.trDefinition
                    intermediate.en_sentence = model.enSentence
                    intermediate.tr_sentence = model.trSentence
                    counter += 1
                }
                newPrivateQeueuContext.saveRecursively()
                debugPrint(logTag + "\(counter) intermediate items are added.")
            }
        }
    }
    
    //save all advanced entities
    private static func saveAllAdvancedEntity(modelList : [WordTableModel]){
    
        if let newPrivateQeueuContext = coreDataStack.newPrivateQueueContext(){
            newPrivateQeueuContext.performBlock {
            var counter = 0
            let entity = NSEntityDescription.entityForName(EntityName.advanced.rawValue, inManagedObjectContext: newPrivateQeueuContext)
                for model in modelList {
                let advanced = Advanced(entity: entity!, insertIntoManagedObjectContext: newPrivateQeueuContext)
                advanced.date = model.date
                advanced.level = model.level
                advanced.en_word = model.enWord
                advanced.tr_word = model.trWord
                advanced.en_definition = model.enDefinition
                advanced.tr_definition = model.trDefinition
                advanced.en_sentence = model.enSentence
                advanced.tr_sentence = model.trSentence
                counter += 1
                }
            newPrivateQeueuContext.saveRecursively()
            debugPrint(logTag + "\(counter) advanced items are added.")
            }
        }
    }
    
    
    //# MARK: - Delete Methods
    static func deleteAllEntityData(entityType : EntityName){
        
        switch entityType {
        case .beginner:
            deleteAllBeginnerEntity()
            break
        case .intermediate:
            deleteAllIntermediateEntity()
            break
        case .advanced:
            deleteAllAdvancedEntity() 
            break
        }
    }
  
    //delete all beginner entities
    private static func deleteAllBeginnerEntity(){
        
        if let newPrivateQueueContext = coreDataStack.newPrivateQueueContext() {
            
            newPrivateQueueContext.performBlock {
                debugPrint( logTag + "delete all beginner entities in performBlock.")
                var counter = 0
                let fetchRequest = NSFetchRequest(entityName: EntityName.beginner.rawValue)
                do{
                    let rows = try newPrivateQueueContext.executeFetchRequest(fetchRequest) as! [Beginner]
                    for row in rows {
                        counter += 1
                        newPrivateQueueContext.deleteObject(row)
                    }
                    newPrivateQueueContext.saveRecursively()
                    debugPrint(logTag + "\(counter) beginner items are deleted." )
                }catch let e as NSError {
                    debugPrint(logTag + "beginner failed to retrieve record: \(e.description)")
                }
                          }
        }
    }
    
    //delete all intermediate entities
    private static func deleteAllIntermediateEntity(){
        
        if let newPrivateQueueContext = coreDataStack.newPrivateQueueContext() {
            
            newPrivateQueueContext.performBlock {
                debugPrint( logTag + "delete all intermediate entities in performBlock.")
                var counter = 0
                let fetchRequest = NSFetchRequest(entityName: EntityName.intermediate.rawValue)
                do{
                    let rows = try newPrivateQueueContext.executeFetchRequest(fetchRequest) as! [Intermediate]
                    for row in rows {
                        counter += 1
                        newPrivateQueueContext.deleteObject(row)
                    }
                    newPrivateQueueContext.saveRecursively()
                    debugPrint(logTag + "\(counter) intermediate items are deleted." )
                }catch let e as NSError {
                    debugPrint(logTag + "intermediate failed to retrieve record: \(e.description)")
                }
                
            }
            
        }
        
    }
    
    //delete all advanced entities
    private static func deleteAllAdvancedEntity(){
        
        if let newPrivateQueueContext = coreDataStack.newPrivateQueueContext() {
            
            newPrivateQueueContext.performBlock {
                debugPrint( logTag + "delete all advanced entities in performBlock.")
                var counter = 0
                let fetchRequest = NSFetchRequest(entityName: EntityName.advanced.rawValue)
                do{
                    let rows = try newPrivateQueueContext.executeFetchRequest(fetchRequest) as! [Advanced]
                    for row in rows {
                        counter += 1
                        newPrivateQueueContext.deleteObject(row)
                    }
                    newPrivateQueueContext.saveRecursively()
                    debugPrint(logTag + "\(counter) advanced items are deleted." )
                }catch let e as NSError {
                    debugPrint(logTag + "advanced failed to retrieve record: \(e.description)")
               }
                
            }
           
        }
        
    }
    
    
    //# MARK: - Class Variables / Members
    private static let logTag : String = "DatabaseUtil "
    private static  let managedObjectContext = DataController().managedObjectContext
    private static let coreDataStack = CoreDataStack()

}