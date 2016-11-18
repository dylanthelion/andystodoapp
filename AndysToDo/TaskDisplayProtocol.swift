//
//  TaskDisplayProtocol.swift
//  AndysToDo
//
//  Created by dillion on 11/3/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

protocol TaskDisplayProtocol {
    
    var AllTasks : [Task]? { get set }
    var categoryFilters : [Category]? { get set }
    var timeCategoryFilters : [TimeCategory]? { get set }
    
    func removeCategoryFilter(_category: Category)
    func removeTimeCategoryFilter(_category: TimeCategory)
    func addCategoryFilter(_category : Category)
    func addTimeCategoryFilter(_category: TimeCategory)
}
