//
//  NSManagedObjectContextExtension.swift
//  Wordly
//
//  Created by eposta developer on 16/08/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//
import CoreData

extension NSManagedObjectContext {
    func saveRecursively() {
        performBlockAndWait {
            if self.hasChanges {
                self.saveThisAndParentContexts()
            }
        }
    }
    
    func saveThisAndParentContexts() {
        //let error: NSError? = nil
        do {
        try save()
          
                parentContext?.saveRecursively()
            
        }
        catch{
            debugPrint("NSManagedObjectContext save error. \(error)")
        }
       
    }
}
