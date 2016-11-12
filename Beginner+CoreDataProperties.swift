//
//  Beginner+CoreDataProperties.swift
//  Wordly
//
//  Created by eposta developer on 13/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Beginner {

    @NSManaged var date: String?
    @NSManaged var en_definition: String?
    @NSManaged var en_sentence: String?
    @NSManaged var en_word: String?
    @NSManaged var level: String?
    @NSManaged var tr_definition: String?
    @NSManaged var tr_sentence: String?
    @NSManaged var tr_word: String?

}
