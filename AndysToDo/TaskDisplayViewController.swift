//
//  TaskDisplayViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/3/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

// Shared parent for MainTaskVC and AllTasksVC

class TaskDisplayViewController : UITableViewController, TaskDisplayProtocol, TaskDTODelegate {
    
    // UI
    
    var filterApplied = false
    var loaded = false
    
    // Model values
    
    var AllTasks : [Task]?
    var categoryFilters : [Category]?
    var timeCategoryFilters : [TimeCategory]?
    let taskDTO = TaskDTO.globalManager
    let categoryDTO = CategoryDTO.shared
    let timecatDTO = TimeCategoryDTO.shared
    
    override func viewDidLoad() {
        if CollectionHelper.IsNilOrEmpty(_coll: taskDTO.AllTasks) {
            taskDTO.delegate = self
            categoryDTO.delegate = self
            timecatDTO.delegate = self
            loaded = true
            categoryDTO.loadCategories()
            timecatDTO.loadTimeCategories()
            taskDTO.loadTasks()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !loaded {
            taskDTO.delegate = self
            categoryDTO.delegate = self
            timecatDTO.delegate = self
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        taskDTO.delegate = nil
        categoryDTO.delegate = nil
        timecatDTO.delegate = nil
        categoryFilters = [Category]()
        timeCategoryFilters = [TimeCategory]()
        loaded = false
    }
    
    func removeCategoryFilter(_category: Category) {
        let indexOf = self.categoryFilters?.index(of: _category)
        self.categoryFilters?.remove(at: indexOf!)
    }
    
    func removeTimeCategoryFilter(_category: TimeCategory) {
        let indexOf = self.timeCategoryFilters?.index(of: _category)
        self.timeCategoryFilters?.remove(at: indexOf!)
    }
    
    func addCategoryFilter(_category : Category) {
        if let _ = self.categoryFilters {
            self.categoryFilters?.append(_category)
        } else {
            self.categoryFilters = [_category]
        }
    }
    
    func addTimeCategoryFilter(_category: TimeCategory) {
        if let _ = self.timeCategoryFilters {
            self.timeCategoryFilters?.append(_category)
        } else {
            self.timeCategoryFilters = [_category]
        }
    }
    
    // TaskDTODelegate
    
    func handleModelUpdate() {
        
    }
    
    func taskDidUpdate(_task: Task) {
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(true) {
            if let _ = self.categoryFilters {
                self.categoryFilters?.removeAll()
            }
            if let _ = self.timeCategoryFilters {
                self.timeCategoryFilters?.removeAll()
            }
        }
        
        return true
    }

}
