//
//  Language+CoreDataProperties.swift
//  Exercism-iOS
//
//  Created by Hom, Kenneth on 4/28/16.
//  Copyright © 2016 Hom, Kenneth. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Language {

    @NSManaged var name: String?
    @NSManaged var exercises: NSSet?

}
