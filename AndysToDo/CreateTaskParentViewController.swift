//
//  CreateTaskParentViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/4/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

// Shared parent for CreateTaskVC and AllTasksIndividualTaskVC

class CreateTaskParentViewController : UIViewController, TaskDTODelegate {
    
    // UI
    
    var textFieldSelected = 0
    
    // Model values
    
    var repeatableDetails : RepeatableTaskOccurrence?
    var multipleRepeatables : [RepeatableTaskOccurrence]?
    var startTime : NSDate?
    var allCategories : [Category]?
    let taskDTO = TaskDTO.globalManager
    let categoryDTO = CategoryDTO.shared
    let timecatDTO = TimeCategoryDTO.shared
    var allTimeCategories : [TimeCategory]?
    var chosenTimeCategory: TimeCategory? = nil
    var startHours : String?
    var repeatable : Bool = false
    var loaded = false
    
    // Picker views
    
    let pickerView = UIPickerView()
    let timeCatPickerView = UIPickerView()
    var datePickerView = UIPickerView()
    var timePickerDelegate : TimePickerViewDelegate?
    let timePickerDataSource : TimePickerViewDataSource = TimePickerViewDataSource()
    var timeCatPickerDataSource : TimecatPickerDataSource?
    var timeCatDelegate : TimecatPickerDelegate?
    var datePickerDelegate : DatePickerViewDelegate?
    let datePickerDataSource = DatePickerDataSource()
    
    override func viewDidLoad() {
        allTimeCategories = timecatDTO.AllTimeCategories
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taskDTO.delegate = self
        categoryDTO.delegate = self
        timecatDTO.delegate = self
        if !loaded {
            self.timeCatPickerDataSource!.reloadTimecats(_categories: timecatDTO.AllTimeCategories!)
            self.timeCatDelegate?.allTimeCategories = timecatDTO.AllTimeCategories!
            DispatchQueue.main.async {
                self.timeCatPickerView.reloadAllComponents()
            }
            loaded = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        taskDTO.delegate = nil
        categoryDTO.delegate = nil
        timecatDTO.delegate = nil
        loaded = false
    }
    
    // Categories
    
    func addCategory(_category : Category) {
        if let _ = self.allCategories {
            self.allCategories!.append(_category)
        } else {
            self.allCategories = [_category]
        }
    }
    
    func removeCategory(_category : Category) {
        let indexOf = self.allCategories?.index(of: _category)
        self.allCategories?.remove(at: indexOf!)
    }
    
    // TaskDTODelegate
    
    func handleModelUpdate() {
        if let check = timeCatPickerView.dataSource! as? TimecatPickerDataSource {
            check.reloadTimecats(_categories: allTimeCategories!)
        }
        DispatchQueue.main.async {
            self.timeCatPickerView.reloadAllComponents()
        }
    }
    
    func taskDidUpdate(_task: Task) {
        
    }
}
