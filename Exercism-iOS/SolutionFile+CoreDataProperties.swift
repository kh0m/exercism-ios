//
//  SolutionFile+CoreDataProperties.swift
//  Exercism-iOS
//
//  Created by Hom, Kenneth on 7/8/16.
//  Copyright © 2016 Hom, Kenneth. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SolutionFile {

    @NSManaged var code: String?
    @NSManaged var fileName: String?
    @NSManaged var submission: Submission?

}
