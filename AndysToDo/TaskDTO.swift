//
//  TaskDTO.swift
//  AndysToDo
//
//  Created by dillion on 10/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private let allTasks = TaskDTO()

class TaskDTO {
    
    var delegate : TaskDTODelegate?
    var AllTasks : [Task]?
    var filteredTasks : [Task]?
    var tasksToPopulate : [Task]?
    var nextTaskID : Int?
    var archivedTasks : [Task]?
    
    class var globalManager : TaskDTO {
        return allTasks
    }
    
    func loadTasks() {
        if(AllTasks != nil) {
            populateNonRepeatables()
            populateRepeatables()
            // Inform delegate that tasks are loaded
            if let _ = delegate {
                delegate!.handleModelUpdate()
            }
            return
        }
        // logic to load tasks from file and/or server
        
        // Until persistence is finished, load fake tasks
        nextTaskID = 0
        AllTasks = loadFakeTasks()
        loadFakeArchivedTasks()
        populateNonRepeatables()
        populateRepeatables()
        // Inform delegate that tasks are loaded
        sortAllTasks()
        if let _ = delegate {
            delegate!.handleModelUpdate()
        } else {
            print("Delegate is nil")
        }
    }
    
    func loadFakeTasks() -> [Task] {
        let task1 = Task(_name: "Task 1", _description: "Fake task", _start: Date().addingTimeInterval(5400) as NSDate?, _finish: nil, _category: nil, _timeCategory: nil, _repeatable: nil)
        task1.ID = nextTaskID!
        nextTaskID! += 1
        let task2 = Task(_name: "Task 2", _description: "Fake task with a fake category", _start: Date().addingTimeInterval(720000) as NSDate?, _finish: nil, _category: [CategoryDTO.shared.AllCategories![0]], _timeCategory: nil, _repeatable: nil)
        task2.ID = nextTaskID!
        nextTaskID! += 1
        let task3 = Task(_name: "Task 3", _description: "Fake task with multiple fake categories", _start: Date().addingTimeInterval(3600) as NSDate?, _finish: nil, _category: CategoryDTO.shared.AllCategories!, _timeCategory: nil, _repeatable: nil)
        task3.ID = nextTaskID!
        nextTaskID! += 1
        let task4 = Task(_name: "Task 4", _description: "Fake task with a fake time category", _start: Date().addingTimeInterval(14400) as NSDate?, _finish: nil, _category: [CategoryDTO.shared.AllCategories![1]], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories![3], _repeatable: nil)
        task4.ID = nextTaskID!
        nextTaskID! += 1
        let repeatable1 = RepeatableTaskOccurrence(_unit: RepetitionTimeCategory.Daily, _unitCount: 2, _time: 13.5, _firstOccurrence: Date().addingTimeInterval(4000) as NSDate?, _dayOfWeek: nil)
        let task5 = Task(_name: "Task 5", _description: "Fake task with daily repetition", _start: Date().addingTimeInterval(4000) as NSDate?, _finish: nil, _category: [CategoryDTO.shared.AllCategories![2]], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories![2], _repeatable: repeatable1)
        task5.ID = nextTaskID!
        task5.inProgress = true
        nextTaskID! += 1
        let repeatble2 = RepeatableTaskOccurrence(_unit: RepetitionTimeCategory.Weekly, _unitCount: 1, _time: 12.0, _firstOccurrence: Date().addingTimeInterval(400000) as NSDate?, _dayOfWeek: DayOfWeek.Monday)
        let task6 = Task(_name: "Task 6", _description: "Fake task with weekly repetition", _start: Date().addingTimeInterval(400000) as NSDate?, _finish: nil, _category: [CategoryDTO.shared.AllCategories![2], CategoryDTO.shared.AllCategories![0]], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories![1], _repeatable: repeatble2)
        task6.ID = nextTaskID!
        nextTaskID! += 1
        let taskToDelete = Task(_name: "Task to delete", _description: "Shouldn't show", _start: Date()
            .addingTimeInterval(4000) as NSDate?, _finish: nil, _category: nil, _timeCategory: nil, _repeatable: nil)
        taskToDelete.ID = nextTaskID!
        nextTaskID! += 1
        return [task1, task2, task3, task4, task5, task6, taskToDelete]
    }
    
    func loadFakeArchivedTasks() {
        let archive1 = Task(_name: "Archive 1", _description: "Fake archived task", _start: Date().addingTimeInterval(-4000) as NSDate?, _finish: Date().addingTimeInterval(-2000) as NSDate?, _category: [CategoryDTO.shared.AllCategories![2], CategoryDTO.shared.AllCategories![0]], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories![1], _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: UnitOfTime.Hour, _expectedTotalUnits: 2)
        let archive2 = Task(_name: "Archive 2", _description: "Fake archived task", _start: Date().addingTimeInterval(-8000) as NSDate?, _finish: Date().addingTimeInterval(-6000) as NSDate?, _category: [CategoryDTO.shared.AllCategories![1], CategoryDTO.shared.AllCategories![0]], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories![0], _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        let archive3 = Task(_name: "Archive 3", _description: "Fake archived task", _start: Date().addingTimeInterval(-400000) as NSDate?, _finish: Date().addingTimeInterval(-320000) as NSDate?, _category: [CategoryDTO.shared.AllCategories![1], CategoryDTO.shared.AllCategories![2]], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories![1], _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: .Day, _expectedTotalUnits: 2)
        let archive4 = Task(_name: "Archive 4", _description: "Fake archived task", _start: Date().addingTimeInterval(-6000000) as NSDate?, _finish: Date().addingTimeInterval(-580000) as NSDate?, _category: [CategoryDTO.shared.AllCategories![2], CategoryDTO.shared.AllCategories![0]], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories![2], _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: .Week, _expectedTotalUnits: 1)
        let repeatable1 = RepeatableTaskOccurrence(_unit: RepetitionTimeCategory.Daily, _unitCount: 2, _time: 13.5, _firstOccurrence: Date().addingTimeInterval(-40000) as NSDate?, _dayOfWeek: nil)
        let archive5 = Task(_name: "Archive 5", _description: "Fake archived task with daily repetition", _start: Date().addingTimeInterval(-40000) as NSDate?, _finish: Date().addingTimeInterval(-4000) as NSDate?, _category: [CategoryDTO.shared.AllCategories![2]], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories![2], _repeatable: repeatable1)
        let archive6 = Task(_name: "Archive 6", _description: "Fake archived task", _start: Date().addingTimeInterval(-30000) as NSDate?, _finish: Date().addingTimeInterval(-28000) as NSDate?, _category: [CategoryDTO.shared.AllCategories![2]], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories![2], _repeatable: nil, _dueDate: nil, _parent: archive5.ID!, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        let archive7 = Task(_name: "Archive 7", _description: "Fake archived task", _start: Date().addingTimeInterval(-20000) as NSDate?, _finish: Date().addingTimeInterval(-18000) as NSDate?, _category: [CategoryDTO.shared.AllCategories![2]], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories![2], _repeatable: nil, _dueDate: nil, _parent: archive5.ID!, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        let archive8 = Task(_name: "Archive 8", _description: "Fake archived task", _start: Date().addingTimeInterval(-10000) as NSDate?, _finish: Date().addingTimeInterval(-8000) as NSDate?, _category: [CategoryDTO.shared.AllCategories![2]], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories![2], _repeatable: nil, _dueDate: nil, _parent: archive5.ID!, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        let archive9 = Task(_name: "Archive 9", _description: "Fake archived task", _start: Date().addingTimeInterval(-8000) as NSDate?, _finish: Date().addingTimeInterval(-6000) as NSDate?, _category: [CategoryDTO.shared.AllCategories![2]], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories![2], _repeatable: nil, _dueDate: nil, _parent: archive5.ID!, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        archive5.unwrappedRepeatables = [archive6, archive7, archive8, archive9]
        let repeatable2 = RepeatableTaskOccurrence(_unit: RepetitionTimeCategory.Daily, _unitCount: 2, _time: 13.5, _firstOccurrence: Date().addingTimeInterval(-400000) as NSDate?, _dayOfWeek: nil)
        let archive10 = Task(_name: "Task 10", _description: "Fake task with daily repetition", _start: Date().addingTimeInterval(-40000) as NSDate?, _finish: nil, _category: [CategoryDTO.shared.AllCategories![1]], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories![1], _repeatable: repeatable2)
        let archive11 = Task(_name: "Archive 11", _description: "Fake archived task", _start: Date().addingTimeInterval(-10000) as NSDate?, _finish: Date().addingTimeInterval(-8000) as NSDate?, _category: [CategoryDTO.shared.AllCategories![1]], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories![1], _repeatable: nil, _dueDate: nil, _parent: archive10.ID!, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        let archive12 = Task(_name: "Archive 12", _description: "Fake archived task", _start: Date().addingTimeInterval(-8000) as NSDate?, _finish: Date().addingTimeInterval(-6000) as NSDate?, _category: [CategoryDTO.shared.AllCategories![1]], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories![1], _repeatable: nil, _dueDate: nil, _parent: archive10.ID!, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        archive10.unwrappedRepeatables = [archive11, archive12]
        AllTasks?.append(archive10)
        archivedTasks = [archive1, archive2, archive3, archive4, archive5, archive6, archive7, archive8, archive9, archive11, archive12]
    }
    
    // CRUD
    
    func createNewTask(_task : Task) -> Bool {
        if _task.isValid()  && !AllTasks!.map({ $0.Name! }).contains(where: { $0 == _task.Name! }) {
            AllTasks!.append(_task)
            sortAllTasks()
            return true
        }
        return false
    }
    
    func createNewTempRepeatableTask(_task : Task) -> Bool {
        if _task.isValid() {
            AllTasks!.append(_task)
            sortAllTasks()
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
                editTask(_task: _task, indexOf: AllTasks!.index(of: task)!, _populated: false)
            } else if !CollectionHelper.IsNilOrEmpty(_coll: task.unwrappedRepeatables) {
                for repeatableTask in tasksToPopulate! {
                    for repeatable in task.unwrappedRepeatables! {
                        if repeatableTask == repeatable {
                            editTask(_task: repeatable, indexOf: tasksToPopulate!.index(of: repeatable)!, _populated: true)
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    func editTask(_task : Task, indexOf: Int, _populated : Bool) {
        var task : Task
        if !_populated {
            task = AllTasks![indexOf]
        } else {
            task = tasksToPopulate![indexOf]
        }
        task.Categories = _task.Categories
        task.Description = _task.Description
        task.FinishTime = _task.FinishTime
        task.inProgress = _task.inProgress
        task.Name = _task.Name
        task.RepeatableTask = _task.RepeatableTask
        task.StartTime = _task.StartTime
        task.TimeCategory = _task.TimeCategory
        task.unwrappedRepeatables = _task.unwrappedRepeatables
        task.siblingRepeatables = _task.siblingRepeatables
        task.timeOnTask = _task.timeOnTask
        if task.FinishTime != nil && !NumberHelper.isNilOrZero(num: task.timeOnTask) && !task.inProgress {
            if archiveTask(_task: task) {
                delegate?.taskDidUpdate(_task: _task)
                return
            } else if task.isRepeatable() {
                populateRepeatables()
                sortAllTasks()
                return
            } else {
                print("Problem archiving")
                return
            }
        } else if !_populated {
            sortAllTasks()
            return
        } else {
            sortDisplayedTasks(forWindow: Constants.mainTaskVC_upper_limit_calendar_unit, units: Constants.mainTaskVC_upper_limit_number_of_units)
            return
        }
    }
    
    func deleteTask(_task : Task) {
        if !CollectionHelper.IsNilOrEmpty(_coll: _task.unwrappedRepeatables) {
            for task in _task.unwrappedRepeatables! {
                deleteTask(_task: task)
            }
        }
        if let checkIndex = AllTasks?.index(of: _task) {
            AllTasks!.remove(at: checkIndex)
        }
        if let checkIndex = filteredTasks?.index(of: _task) {
            filteredTasks?.remove(at: checkIndex)
        }
        if let checkIndex = tasksToPopulate?.index(of: _task) {
            tasksToPopulate?.remove(at: checkIndex)
        }
        sortAllTasks()
        delegate?.handleModelUpdate()
    }
    
    func archiveTask(_task: Task) -> Bool {
        let index = AllTasks!.index(of: _task)
        let populatedIndex = tasksToPopulate?.index(of: _task)
        if let _ = index {
            AllTasks!.remove(at: index!)
            if let _ = populatedIndex {
                tasksToPopulate!.remove(at: populatedIndex!)
            }
            addToArchive(_task: _task)
            return true
        }
        if let _ = populatedIndex {
            tasksToPopulate!.remove(at: populatedIndex!)
            addToArchive(_task: _task)
            return true
        }
        return false
    }
    
    func addToArchive(_task: Task) {
        if let _ = archivedTasks {
            archivedTasks?.append(_task)
        } else {
            archivedTasks = [_task]
        }
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
        if !CollectionHelper.IsNilOrEmpty(_coll: tasksToPopulate!) {
            tasksToPopulate!.removeAll()
        }
        populateNonRepeatables()
        populateRepeatables()
        filteredTasks = []
        for _task in tasksToPopulate! {
            
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
    
    func applyFilterToAllTasks(categories : [Category]?, timeCategories : [TimeCategory]?) -> [Task]? {
        if AllTasks == nil {
            loadTasks()
        }
        if(CollectionHelper.IsNilOrEmpty(_coll: categories) && CollectionHelper.IsNilOrEmpty(_coll: timeCategories)) {
            //print("No filter")
            return AllTasks
        }
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
        
        return filteredTasks
    }
    
    func applyFilterToTasks(_tasks : [Task], categories : [Category]?, timeCategories : [TimeCategory]?) -> [Task] {
        if(CollectionHelper.IsNilOrEmpty(_coll: categories) && CollectionHelper.IsNilOrEmpty(_coll: timeCategories)) {
            //print("No filter")
            return _tasks
        }
        filteredTasks = []
        for _task in _tasks {
            
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
        
        return filteredTasks!
    }
    
    // Populate tasks
    
    func populateNonRepeatables() {
        if AllTasks == nil {
            return
        }
        if tasksToPopulate == nil {
            tasksToPopulate = [Task]()
        }
        for _task in AllTasks! {
            if !_task.isRepeatable() && tasksToPopulate!.index(of: _task) == nil {
                tasksToPopulate!.append(_task)
            }
        }
    }
    
    func populateRepeatables() {
        if AllTasks == nil {
            return
        }
        if tasksToPopulate == nil {
            tasksToPopulate = [Task]()
        }
        let tempTasks = AllTasks!
        for _task in tempTasks {
            if _task.isRepeatable() {
                if !CollectionHelper.IsNilOrEmpty(_coll: _task.unwrappedRepeatables) {
                    clearOldRepeatablesFrom(_task: _task)
                } else {
                    _task.unwrappedRepeatables = [Task]()
                }
                for i in 0..<Constants.repeatablesToGenerate {
                    var units = i
                    let component : TimeInterval
                    if _task.RepeatableTask!.UnitOfTime! == .Daily {
                        component = TimeInterval(Constants.seconds_per_day)
                    } else if _task.RepeatableTask!.UnitOfTime! == .Hourly {
                        component = TimeInterval(Constants.seconds_per_hour)
                    } else {
                        component = TimeInterval(Constants.seconds_per_day)
                        units *= 7
                    }
                    let taskToAdd = Task(_name: "\(_task.Name!)\(i)", _description: _task.Description!, _start: _task.RepeatableTask?.FirstOccurrence!.addingTimeInterval(component * TimeInterval(units)), _finish: nil, _category: _task.Categories, _timeCategory: _task.TimeCategory, _repeatable: nil)
                    taskToAdd.parentID = _task.ID!
                    taskToAdd.ID = Int(NSDate().timeIntervalSince1970) + Int(taskToAdd.StartTime!.timeIntervalSince1970)
                    tasksToPopulate!.append(taskToAdd)
                    _task.unwrappedRepeatables!.append(taskToAdd)
                }
            }
        }
        sortAllTasks()
    }
    
    func clearOldRepeatablesFrom(_task : Task) {
        for repeatable in _task.unwrappedRepeatables! {
            if let index = tasksToPopulate!.index(of: repeatable) {
                tasksToPopulate!.remove(at: index)
            }
        }
        _task.unwrappedRepeatables!.removeAll()
    }
    
    // Sort tasks
    
    func sortDisplayedTasks(forWindow : Calendar.Component, units: Int) {
        var timeInterval : TimeInterval? = TimeInterval(0)
        if forWindow == .day {
            timeInterval = TimeInterval (Constants.seconds_per_day)
        } else if forWindow == .hour {
            timeInterval = TimeInterval(Constants.seconds_per_hour)
        }
        timeInterval! *= Double(units)
        let df = StandardDateFormatter()
        let upperLimit = df.date(from: df.string(from: Date().addingTimeInterval(timeInterval!)))
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
    
    func sortAllTasks() {
        for _task in AllTasks! {
            if _task.isRepeatable() {
                if !CollectionHelper.IsNilOrEmpty(_coll: _task.unwrappedRepeatables) {
                    _task.unwrappedRepeatables!.sort(by: {
                        return ($0.StartTime! as Date) < ($1.StartTime! as Date)
                    })
                    _task.StartTime = _task.unwrappedRepeatables![0].StartTime
                } else {
                    _task.StartTime = Date().addingTimeInterval(500000) as NSDate?
                }
            }
        }
        
        AllTasks!.sort(by: {
            return ($0.StartTime! as Date) < ($1.StartTime! as Date)
        })
    }
    
    func sortArchivedTasks() {
        if let _ = archivedTasks {
            archivedTasks!.sort(by: {
                return ($0.StartTime! as Date) < ($1.StartTime! as Date)
            })
        }
    }
}

protocol TaskDTODelegate {
    func handleModelUpdate()
    func taskDidUpdate(_task : Task)
}
