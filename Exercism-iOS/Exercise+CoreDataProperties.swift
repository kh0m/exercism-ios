//
//  Exercise+CoreDataProperties.swift
//  Exercism-iOS
//
//  Created by Hom, Kenneth on 4/27/16.
//  Copyright © 2016 Hom, Kenneth. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Exercise {

    @NSManaged var isActive: NSNumber?
    @NSManaged var name: String?
    @NSManaged var iterations: NSSet?
    @NSManaged var language: Language?

}
