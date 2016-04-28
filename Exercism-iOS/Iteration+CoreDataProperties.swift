//
//  Iteration+CoreDataProperties.swift
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

extension Iteration {

    @NSManaged var code: String?
    @NSManaged var version: NSNumber?
    @NSManaged var comments: NSSet?
    @NSManaged var exercise: Exercise?

}
