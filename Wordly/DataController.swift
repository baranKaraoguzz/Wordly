//
//  DataController.swift
//  Wordly
//
//  Created by eposta developer on 13/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import UIKit
import CoreData
class DataController: NSObject {
    var managedObjectContext: NSManagedObjectContext
    
    override init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = NSBundle.mainBundle().URLForResource(SQLDataHelper.wordListDataModel.rawValue, withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
    
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let docURL = urls[urls.endIndex-1]
        /* The directory the application uses to store the Core Data store file.
         This code uses a file named "DataModel.sqlite" in the application's documents directory.
         */
        let storeURL = docURL.URLByAppendingPathComponent(SQLDataHelper.wordListDataModel.rawValue + ".sqlite")
        do {
            try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
        
        
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
        //            let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        //            let docURL = urls[urls.endIndex-1]
        //            /* The directory the application uses to store the Core Data store file.
        //            This code uses a file named "DataModel.sqlite" in the application's documents directory.
        //            */
        //            let storeURL = docURL.URLByAppendingPathComponent("DataModel.sqlite")
        //            do {
        //                try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        //            } catch {
        //                fatalError("Error migrating store: \(error)")
        //            }
        //        }
    }
}

/*
 private func createUser() {
 let coreDataStack = CoreDataStack()
 
 if let newPrivateQueueContext =
 coreDataStack.newPrivateQueueContext()
 {
 newPrivateQueueContext.performBlock {
 let newUser =
 NSEntityDescription
 .insertNewObjectForEntityForName("User",
 inManagedObjectContext: newPrivateQueueContext)
 as! User
 
 newUser.name = "The Dude"
 newUser.email = "dude@rubikscube.com"
 
 newPrivateQueueContext.saveRecursively()
 }
 }
 }
 
 
 */


///-----------------

/*
 NSObject {
 var managedObjectContext: NSManagedObjectContext
 override init() {
 // This resource is the same name as your xcdatamodeld contained in your project.
 guard let modelURL = NSBundle.mainBundle().URLForResource("wordListDataModel", withExtension:"momd") else {
 fatalError("Error loading model from bundle")
 }
 // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
 guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
 fatalError("Error initializing mom from: \(modelURL)")
 }
 let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
 managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
 managedObjectContext.persistentStoreCoordinator = psc
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
 let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
 let docURL = urls[urls.endIndex-1]
 /* The directory the application uses to store the Core Data store file.
 This code uses a file named "wordListDataModel.sqlite" in the application's documents directory.
 */
 let storeURL = docURL.URLByAppendingPathComponent("Wordly.sqlite")
 do {
 try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
 } catch {
 fatalError("Error migrating store: \(error)")
 }
 }
 }
 }
 */