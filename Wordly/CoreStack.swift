import Foundation
import CoreData

class CoreDataStack {
    func newPrivateQueueContext() -> NSManagedObjectContext? {
        let parentContext = self.mainQueueContext
        
        if parentContext == nil {
            return nil
        }
        
        let privateQueueContext =
            NSManagedObjectContext(concurrencyType:
                .PrivateQueueConcurrencyType)
        privateQueueContext.parentContext = parentContext
        privateQueueContext.mergePolicy =
        NSMergeByPropertyObjectTrumpMergePolicy
        return privateQueueContext
    }
    
    lazy var mainQueueContext: NSManagedObjectContext? = {
        let parentContext = self.masterContext
        
        if parentContext == nil {
            return nil
        }
        
        var mainQueueContext =
            NSManagedObjectContext(concurrencyType:
                .MainQueueConcurrencyType)
        mainQueueContext.parentContext = parentContext
        mainQueueContext.mergePolicy =
        NSMergeByPropertyObjectTrumpMergePolicy
        return mainQueueContext
    }()
    
    private lazy var masterContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        
        if coordinator == nil {
            return nil
        }
        
        var masterContext =
            NSManagedObjectContext(concurrencyType:
                .PrivateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = coordinator
        masterContext.mergePolicy =
        NSMergeByPropertyObjectTrumpMergePolicy
        return masterContext
    }()
    
    // MARK: - Setting up Core Data stack
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // This resource is the same name as your xcdatamodeld contained in your project.
         guard let modelURL = NSBundle.mainBundle().URLForResource(SQLDataHelper.wordListDataModel.rawValue, withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
        fatalError("Error initializing mom from: \(modelURL)")
        }
        return mom
    }()
 
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let docURL = urls[urls.endIndex-1]
        /* The directory the application uses to store the Core Data store file.
         This code uses a file named "DataModel.sqlite" in the application's documents directory.
         */
      
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(SQLDataHelper.wordListDataModel.rawValue + ".sqlite")
 
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        
        do {
            try coordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
            
        } catch {
        fatalError("Error migrating store: \(error)")
        }
        
        return coordinator
    }()
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
    }()
    
    private func saveContext () {
        if let moc = self.mainQueueContext {
          //  var error: NSError? = nil
            if moc.hasChanges  {
                print("Unresolved error \("hasChanges")")
                exit(1)
            }

            do {
            try moc.save()
            } catch {
             print("Unresolved error \(error)")
            }
            
            /*
            if moc.hasChanges && !moc.save(&error) {
                print("Unresolved error \(error), \(error!.userInfo)")
                exit(1)
            }
 */
        }
    }
}