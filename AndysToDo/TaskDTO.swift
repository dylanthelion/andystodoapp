//
//  TaskDTO.swift
//  AndysToDo
//
//  Created by dillion on 10/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

private let allTasks = TaskDTO()

class TaskDTO {
    
    var delegate : TaskDTODelegate?
    var AllTasks : [Task]?
    var AllCategories : [Category]?
    var AllTimeCategories : [TimeCategory]?
    var nextTaskID : Int?
    
    class var globalManager : TaskDTO {
        return allTasks
    }
    
    func loadTasks() {
        loadCategories()
        loadTimeCategories()
        // logic to load tasks from file and/or server
        
        // Until persistence is finished, load fake tasks
        nextTaskID = 0
        let task1 = Task(_name: "Task 1", _description: "Fake task", _start: NSDate().addingTimeInterval(3600), _finish: nil, _category: nil, _timeCategory: nil, _repeatable: nil)
        task1.ID = nextTaskID!
        nextTaskID! += 1
        let task2 = Task(_name: "Task 2", _description: "Fake task with a fake category", _start: NSDate().addingTimeInterval(7200), _finish: nil, _category: [AllCategories![0]], _timeCategory: nil, _repeatable: nil)
        task2.ID = nextTaskID!
        nextTaskID! += 1
        let task3 = Task(_name: "Task 3", _description: "Fake task with multiple fake categories", _start: NSDate().addingTimeInterval(5400), _finish: nil, _category: AllCategories!, _timeCategory: nil, _repeatable: nil)
        task3.ID = nextTaskID!
        nextTaskID! += 1
        let task4 = Task(_name: "Task 4", _description: "Fake task with a fake time category", _start: NSDate().addingTimeInterval(14400), _finish: nil, _category: [AllCategories![1]], _timeCategory: AllTimeCategories![3], _repeatable: nil)
        task4.ID = nextTaskID!
        nextTaskID! += 1
        let repeatable1 = RepeatableTaskOccurrence(_unit: RepetitionTimeCategory.Daily, _unitCount: 2, _time: 13.5, _firstOccurrence: NSDate(), _dayOfWeek: nil)
        let task5 = Task(_name: "Task 5", _description: "Fake task with daily repetition", _start: nil, _finish: nil, _category: [AllCategories![2]], _timeCategory: AllTimeCategories![2], _repeatable: repeatable1)
        task5.ID = nextTaskID!
        task5.inProgress = true
        nextTaskID! += 1
        let repeatble2 = RepeatableTaskOccurrence(_unit: RepetitionTimeCategory.Weekly, _unitCount: 1, _time: 12.0, _firstOccurrence: nil, _dayOfWeek: DayOfWeek.Monday)
        let task6 = Task(_name: "Task 6", _description: "Fake task with weekly repetition", _start: nil, _finish: nil, _category: [AllCategories![2], AllCategories![0]], _timeCategory: AllTimeCategories![1], _repeatable: repeatble2)
        task6.ID = nextTaskID!
        nextTaskID! += 1
        AllTasks = [task1, task2, task3, task4, task5, task6]
        
        // Inform delegate that tasks are loaded
        if let _ = delegate {
            delegate!.handleModelUpdate()
        }
    }
    
    func loadCategories() {
        // logic to load categories from file and/or server
        
        // Until persistence is finished, load fake categories
        
        let category1 = Category(_name: "Category 1", _description: "Fake Category")
        let category2 = Category(_name: "Category 2", _description: "Another fake Category")
        let category3 = Category(_name: "Category 3", _description: "The worst fake category")
        AllCategories = [category1, category2, category3]
    }
    
    func loadTimeCategories() {
        // logic to load categories from file and/or server
        
        // Until persistence is finished, load fake categories
        
        let category1 = TimeCategory(_name: "Time Cat 1", _description: "Fake Morning", _start: 8.5, _end: 11.0)
        let category2 = TimeCategory(_name: "Time Cat 2", _description: "Fake Lunch Hours", _start: 12.25, _end: 13.25)
        let category3 = TimeCategory(_name: "Time Cat 3", _description: "Fake Afternoon", _start: 14.0, _end: 17.0)
        let category4 = TimeCategory(_name: "Time Cat 4", _description: "Fake evening", _start: 18.5, _end: 21.75)
        AllTimeCategories = [category1, category2, category3, category4]
    }
    
    func createNewTask(_task : Task) {
        if _task.isValid() {
            _task.ID = nextTaskID!
            nextTaskID! += 1
            AllTasks!.append(_task)
        }
    }
    
    func getTaskByID(_id : Int) -> Task? {
        for task in AllTasks! {
            if task.ID! == _id {
                return task
            }
        }
        
        return nil
    }
    
    func updateTask(_task : Task) -> Bool {
        for task in AllTasks! {
            if task.ID! == _task.ID && _task.isValid() {
                task.Categories = _task.Categories
                task.Description = _task.Description
                task.FinishTime = _task.FinishTime
                task.inProgress = _task.inProgress
                task.Name = _task.Name
                task.RepeatableTask = _task.RepeatableTask
                task.StartTime = _task.StartTime
                task.TimeCategory = _task.TimeCategory
                return true
            }
        }
        
        return false
    }
}

protocol TaskDTODelegate {
    func handleModelUpdate()
    func taskDidUpdate(_task : Task)
}
