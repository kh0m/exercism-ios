//
//  Exercise.swift
//  Exercism-iOS
//
//  Created by Hom, Kenneth on 4/8/16.
//  Copyright © 2016 Hom, Kenneth. All rights reserved.
//

import UIKit

class Exercise: NSObject {
    var name: String = ""
    lazy var language = Language()
    var isActive: Bool = true
    lazy var iterations = [Iteration]()
}
