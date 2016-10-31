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
    var filteredTasks : [Task]?
    var tasksToPopulate : [Task]?
    var AllCategories : [Category]?
    var AllTimeCategories : [TimeCategory]?
    var nextTaskID : Int?
    
    class var globalManager : TaskDTO {
        return allTasks
    }
    
    func loadTasks() {
        if(AllTasks != nil) {
            return
        }
        loadCategories()
        loadTimeCategories()
        // logic to load tasks from file and/or server
        
        // Until persistence is finished, load fake tasks
        nextTaskID = 0
        AllTasks = loadFakeTasks()
        populateRepeatables()
        tasksToPopulate = AllTasks!
        // Inform delegate that tasks are loaded
        if let _ = delegate {
            delegate!.handleModelUpdate()
        }
    }
    
    func loadFakeTasks() -> [Task] {
        let task1 = Task(_name: "Task 1", _description: "Fake task", _start: NSDate().addingTimeInterval(5400), _finish: nil, _category: nil, _timeCategory: nil, _repeatable: nil)
        task1.ID = nextTaskID!
        nextTaskID! += 1
        let task2 = Task(_name: "Task 2", _description: "Fake task with a fake category", _start: NSDate().addingTimeInterval(720000), _finish: nil, _category: [AllCategories![0]], _timeCategory: nil, _repeatable: nil)
        task2.ID = nextTaskID!
        nextTaskID! += 1
        let task3 = Task(_name: "Task 3", _description: "Fake task with multiple fake categories", _start: NSDate().addingTimeInterval(3600), _finish: nil, _category: AllCategories!, _timeCategory: nil, _repeatable: nil)
        task3.ID = nextTaskID!
        nextTaskID! += 1
        let task4 = Task(_name: "Task 4", _description: "Fake task with a fake time category", _start: NSDate().addingTimeInterval(14400), _finish: nil, _category: [AllCategories![1]], _timeCategory: AllTimeCategories![3], _repeatable: nil)
        task4.ID = nextTaskID!
        nextTaskID! += 1
        let repeatable1 = RepeatableTaskOccurrence(_unit: RepetitionTimeCategory.Daily, _unitCount: 2, _time: 13.5, _firstOccurrence: NSDate(), _dayOfWeek: nil)
        let task5 = Task(_name: "Task 5", _description: "Fake task with daily repetition", _start: NSDate().addingTimeInterval(4000), _finish: nil, _category: [AllCategories![2]], _timeCategory: AllTimeCategories![2], _repeatable: repeatable1)
        task5.ID = nextTaskID!
        task5.inProgress = true
        nextTaskID! += 1
        let repeatble2 = RepeatableTaskOccurrence(_unit: RepetitionTimeCategory.Weekly, _unitCount: 1, _time: 12.0, _firstOccurrence: nil, _dayOfWeek: DayOfWeek.Monday)
        let task6 = Task(_name: "Task 6", _description: "Fake task with weekly repetition", _start: NSDate().addingTimeInterval(400000), _finish: nil, _category: [AllCategories![2], AllCategories![0]], _timeCategory: AllTimeCategories![1], _repeatable: repeatble2)
        task6.ID = nextTaskID!
        nextTaskID! += 1
        let taskToDelete = Task(_name: "Task to delete", _description: "Shouldn't show", _start: NSDate().addingTimeInterval(4000), _finish: nil, _category: nil, _timeCategory: nil, _repeatable: nil)
        taskToDelete.ID = nextTaskID!
        nextTaskID! += 1
        return [task1, task2, task3, task4, task5, task6, taskToDelete]
    }
    
    func loadCategories() {
        // logic to load categories from file and/or server
        
        // Until persistence is finished, load fake categories
        
        
        AllCategories = loadFakeCategories()
    }
    
    func loadFakeCategories() -> [Category] {
        let category1 = Category(_name: "Category 1", _description: "Fake Category")
        let category2 = Category(_name: "Category 2", _description: "Another fake Category")
        let category3 = Category(_name: "Category 3", _description: "The worst fake category")
        return [category1, category2, category3]
    }
    
    func loadTimeCategories() {
        // logic to load categories from file and/or server
        
        // Until persistence is finished, load fake categories
        
        
        AllTimeCategories = loadFakeTimeCategories()
    }
    
    func loadFakeTimeCategories() -> [TimeCategory] {
        let category1 = TimeCategory(_name: "Time Cat 1", _description: "Fake Morning", _start: 8.5, _end: 11.0)
        let category2 = TimeCategory(_name: "Time Cat 2", _description: "Fake Lunch Hours", _start: 12.25, _end: 13.25)
        let category3 = TimeCategory(_name: "Time Cat 3", _description: "Fake Afternoon", _start: 14.0, _end: 17.0)
        let category4 = TimeCategory(_name: "Time Cat 4", _description: "Fake evening", _start: 18.5, _end: 21.75)
        return [category1, category2, category3, category4]
    }
    
    // Task CRUD
    
    func createNewTask(_task : Task) -> Bool {
        if _task.isValid() {
            AllTasks!.append(_task)
            tasksToPopulate!.append(_task)
            return true
        }
        return false
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
    
    func deleteTask(_task : Task) {
        if let checkIndex = AllTasks?.index(of: _task) {
            AllTasks!.remove(at: checkIndex)
        }
        if let checkIndex = tasksToPopulate?.index(of: _task) {
            filteredTasks?.remove(at: checkIndex)
            tasksToPopulate?.remove(at: checkIndex)
            delegate?.handleModelUpdate()
        }
    }
    
    // Category CRUD
    
    func createNewCategory(_category : Category) -> Bool {
        if _category.isValid() {
            var isUnique = true
            for _cat in AllCategories! {
                if _cat == _category {
                    isUnique = false
                    break
                }
            }
            if isUnique {
                AllCategories!.append(_category)
                return true
            } else {
                return false
            }
            
        }
        return false
    }
    
    // Time Category CRUD
    
    func createNewTimeCategory(_category : TimeCategory) -> Bool {
        if _category.isValid() {
            var isUnique = true
            for _cat in AllTimeCategories! {
                if _cat == _category {
                    isUnique = false
                    break
                }
            }
            if isUnique {
                AllTimeCategories!.append(_category)
                return true
            } else {
                return false
            }
            
        }
        return false
    }
    
    // ID generation
    
    func getNextID() -> Int {
        nextTaskID! += 1
        return nextTaskID!
    }
    
    // Filter displayed tasks
    
    func applyFilter(categories : [Category]?, timeCategories : [TimeCategory]?) {
        if(CollectionHelper.IsNilOrEmpty(_coll: categories) && CollectionHelper.IsNilOrEmpty(_coll: timeCategories)) {
            //print("No filter")
            loadTasks()
            return
        }
        populateRepeatables()
        filteredTasks = []
        for _task in AllTasks! {
            
            var addToFilter : Bool = false
            
            if _task.Categories != nil && !CollectionHelper.IsNilOrEmpty(_coll: categories) {
                for _category in _task.Categories! {
                    for _checkCategory in categories! {
                        if(_category.Name! == _checkCategory.Name!) {
                            addToFilter = true
                            break
                        }
                    }
                }
            }
            
            if _task.TimeCategory != nil && !CollectionHelper.IsNilOrEmpty(_coll: timeCategories) {
                for _checkCategory in timeCategories! {
                    if(_task.TimeCategory!.Name! == _checkCategory.Name!) {
                        addToFilter = true
                        break
                    }
                }
            }
        
            if(addToFilter) {
                filteredTasks!.append(_task)
                addToFilter = false
            }
        }
        tasksToPopulate = filteredTasks
        if let _ = delegate {
            delegate?.handleModelUpdate()
        }
    }
    
    func populateRepeatables() {
        if AllTasks == nil {
            return
        }
        let tempTasks = AllTasks!
        for _task in tempTasks {
            if _task.isRepeatable() {
                let indexOf = AllTasks!.index(of: _task)
                AllTasks!.remove(at: indexOf!)
                for i in 0...Constants.repeatablesToGenerate {
                    var units = i
                    let component : Calendar.Component
                    if _task.RepeatableTask!.UnitOfTime! == .Daily {
                        component = .day
                    } else if _task.RepeatableTask!.UnitOfTime! == .Hourly {
                        component = .hour
                    } else {
                        component = .day
                        units *= 7
                    }
                    let taskToAdd = Task(_name: "\(_task.Name!)\(i)", _description: _task.Description!, _start: (NSCalendar.current.date(byAdding: component, value: units, to: _task.StartTime! as Date)! as NSDate), _finish: nil, _category: _task.Categories, _timeCategory: _task.TimeCategory, _repeatable: nil)
                    taskToAdd.ID = Int(NSDate().timeIntervalSince1970) + Int(taskToAdd.StartTime!.timeIntervalSince1970)
                    AllTasks!.append(taskToAdd)
                }
            }
        }
    }
    
    func sortDisplayedTasks(forWindow : Calendar.Component, units: Int) {
        let upperLimit = Calendar.current.date(byAdding: forWindow, value: units, to: Date())
        let tempTasks = tasksToPopulate!
        for _task in tempTasks {
            if (_task.StartTime! as Date) > upperLimit! {
                let indexOf = tasksToPopulate!.index(of: _task)
                tasksToPopulate!.remove(at: indexOf!)
            }
        }
        tasksToPopulate!.sort(by: {
            return ($0.StartTime! as Date) < ($1.StartTime! as Date)
        })
        delegate?.handleModelUpdate()
    }
}

protocol TaskDTODelegate {
    func handleModelUpdate()
    func taskDidUpdate(_task : Task)
}
