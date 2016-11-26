//
//  TaskDisplayViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/3/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

// Shared parent for MainTaskVC and AllTasksVC

class TaskDisplayViewController : UITableViewController, TaskDisplayProtocol {
    
    
    // View Model
    
    
    
    override func viewDidLoad() {
        /*if CollectionHelper.IsNilOrEmpty(_coll: taskDTO.AllTasks?.value) {
            taskDTO.delegate = self
            categoryDTO.delegate = self
            timecatDTO.delegate = self
            loaded = true
            categoryDTO.loadCategories()
            timecatDTO.loadTimeCategories()
            taskDTO.loadTasks()
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    

}
