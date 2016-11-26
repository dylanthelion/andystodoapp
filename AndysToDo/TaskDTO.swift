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
    var AllTasks : Dynamic<[Dynamic<Task>]>?
    var filteredTasks : Dynamic<[Dynamic<Task>]>?
    var tasksToPopulate : Dynamic<[Dynamic<Task>]>?
    
    var archivedTasks : Dynamic<[Dynamic<Task>]>?
    
    init() {
        CategoryDTO.shared.loadCategories()
        TimeCategoryDTO.shared.loadTimeCategories()
        loadTasks()
    }
    
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
        AllTasks = loadFakeTasks()
        loadFakeArchivedTasks()
        populateNonRepeatables()
        //populateRepeatables()
        // Inform delegate that tasks are loaded
        sortAllTasks()
        if let _ = delegate {
            delegate!.handleModelUpdate()
        } else {
            //print("Delegate is nil")
        }
    }
    
    func loadFakeTasks() -> Dynamic<[Dynamic<Task>]> {
        let task1 = Task(_name: "Task 1", _description: "Fake task", _start: Date().addingTimeInterval(5400) as NSDate?, _finish: nil, _category: nil, _timeCategory: nil, _repeatable: nil)
        task1.ID = IDGenerator.shared.nextTaskID
        let task2 = Task(_name: "Task 2", _description: "Fake task with a fake category", _start: Date().addingTimeInterval(720000) as NSDate?, _finish: nil, _category: [CategoryDTO.shared.AllCategories!.value[0].value], _timeCategory: nil, _repeatable: nil)
        task2.ID = IDGenerator.shared.nextTaskID
        let task3 = Task(_name: "Task 3", _description: "Fake task with multiple fake categories", _start: Date().addingTimeInterval(3600) as NSDate?, _finish: nil, _category: [CategoryDTO.shared.AllCategories!.value[1].value, CategoryDTO.shared.AllCategories!.value[0].value, CategoryDTO.shared.AllCategories!.value[2].value], _timeCategory: nil, _repeatable: nil)
        task3.ID = IDGenerator.shared.nextTaskID
        let task4 = Task(_name: "Task 4", _description: "Fake task with a fake time category", _start: Date().addingTimeInterval(14400) as NSDate?, _finish: nil, _category: [CategoryDTO.shared.AllCategories!.value[1].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[2].value, _repeatable: nil)
        task4.ID = IDGenerator.shared.nextTaskID
        let repeatable1 = RepeatableTaskOccurrence(_unit: RepetitionTimeCategory.Daily, _unitCount: 2, _time: 13.5, _firstOccurrence: Date().addingTimeInterval(4000) as NSDate?, _dayOfWeek: nil)
        let task5 = Task(_name: "Task 5", _description: "Fake task with daily repetition", _start: Date().addingTimeInterval(4000) as NSDate?, _finish: nil, _category: [CategoryDTO.shared.AllCategories!.value[2].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[2].value, _repeatable: repeatable1)
        task5.ID = IDGenerator.shared.nextTaskID
        task5.inProgress = true
        let repeatble2 = RepeatableTaskOccurrence(_unit: RepetitionTimeCategory.Weekly, _unitCount: 1, _time: 12.0, _firstOccurrence: Date().addingTimeInterval(400000) as NSDate?, _dayOfWeek: DayOfWeek.Monday)
        let task6 = Task(_name: "Task 6", _description: "Fake task with weekly repetition", _start: Date().addingTimeInterval(400000) as NSDate?, _finish: nil, _category: [CategoryDTO.shared.AllCategories!.value[2].value, CategoryDTO.shared.AllCategories!.value[0].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[1].value, _repeatable: repeatble2)
        task6.ID = IDGenerator.shared.nextTaskID
        let taskToDelete = Task(_name: "Task to delete", _description: "Shouldn't show", _start: Date()
            .addingTimeInterval(4000) as NSDate?, _finish: nil, _category: nil, _timeCategory: nil, _repeatable: nil)
        taskToDelete.ID = IDGenerator.shared.nextTaskID
        return Dynamic([Dynamic(task1), Dynamic(task2), Dynamic(task3), Dynamic(task4), Dynamic(task5), Dynamic(task6), Dynamic(taskToDelete)])
    }
    
    func loadFakeArchivedTasks() {
        let archive1 = Task(_name: "Archive 1", _description: "Fake archived task", _start: Date().addingTimeInterval(-4000) as NSDate?, _finish: Date().addingTimeInterval(-2000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[2].value, CategoryDTO.shared.AllCategories!.value[0].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[1].value, _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: UnitOfTime.Hour, _expectedTotalUnits: 2)
        let archive2 = Task(_name: "Archive 2", _description: "Fake archived task", _start: Date().addingTimeInterval(-8000) as NSDate?, _finish: Date().addingTimeInterval(-6000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[1].value, CategoryDTO.shared.AllCategories!.value[0].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[0].value, _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        let archive3 = Task(_name: "Archive 3", _description: "Fake archived task", _start: Date().addingTimeInterval(-400000) as NSDate?, _finish: Date().addingTimeInterval(-320000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[1].value, CategoryDTO.shared.AllCategories!.value[2].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[1].value, _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: .Day, _expectedTotalUnits: 2)
        let archive4 = Task(_name: "Archive 4", _description: "Fake archived task", _start: Date().addingTimeInterval(-6000000) as NSDate?, _finish: Date().addingTimeInterval(-580000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[2].value, CategoryDTO.shared.AllCategories!.value[0].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[2].value, _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: .Week, _expectedTotalUnits: 1)
        let repeatable1 = RepeatableTaskOccurrence(_unit: RepetitionTimeCategory.Daily, _unitCount: 2, _time: 13.5, _firstOccurrence: Date().addingTimeInterval(-40000) as NSDate?, _dayOfWeek: nil)
        let archive5 = Task(_name: "Archive 5", _description: "Fake archived task with daily repetition", _start: Date().addingTimeInterval(-40000) as NSDate?, _finish: Date().addingTimeInterval(-4000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[2].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[2].value, _repeatable: repeatable1)
        let archive6 = Task(_name: "Archive 6", _description: "Fake archived task", _start: Date().addingTimeInterval(-30000) as NSDate?, _finish: Date().addingTimeInterval(-28000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[2].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[2].value, _repeatable: nil, _dueDate: nil, _parent: archive5.ID!, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        let archive7 = Task(_name: "Archive 7", _description: "Fake archived task", _start: Date().addingTimeInterval(-20000) as NSDate?, _finish: Date().addingTimeInterval(-18000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[2].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[2].value, _repeatable: nil, _dueDate: nil, _parent: archive5.ID!, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        let archive8 = Task(_name: "Archive 8", _description: "Fake archived task", _start: Date().addingTimeInterval(-10000) as NSDate?, _finish: Date().addingTimeInterval(-8000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[2].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[2].value, _repeatable: nil, _dueDate: nil, _parent: archive5.ID!, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        let archive9 = Task(_name: "Archive 9", _description: "Fake archived task", _start: Date().addingTimeInterval(-8000) as NSDate?, _finish: Date().addingTimeInterval(-6000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[2].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[2].value, _repeatable: nil, _dueDate: nil, _parent: archive5.ID!, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        archive5.unwrappedRepeatables = [archive6, archive7, archive8, archive9]
        let repeatable2 = RepeatableTaskOccurrence(_unit: RepetitionTimeCategory.Daily, _unitCount: 2, _time: 13.5, _firstOccurrence: Date().addingTimeInterval(-400000) as NSDate?, _dayOfWeek: nil)
        let archive10 = Task(_name: "Archive 10", _description: "Fake task with daily repetition", _start: Date().addingTimeInterval(-40000) as NSDate?, _finish: nil, _category: [CategoryDTO.shared.AllCategories!.value[1].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[1].value, _repeatable: repeatable2)
        let archive11 = Task(_name: "Archive 11", _description: "Fake archived task", _start: Date().addingTimeInterval(-10000) as NSDate?, _finish: Date().addingTimeInterval(-8000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[1].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[1].value, _repeatable: nil, _dueDate: nil, _parent: archive10.ID!, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        let archive12 = Task(_name: "Archive 12", _description: "Fake archived task", _start: Date().addingTimeInterval(-8000) as NSDate?, _finish: Date().addingTimeInterval(-6000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[1].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[1].value, _repeatable: nil, _dueDate: nil, _parent: archive10.ID!, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        archive10.unwrappedRepeatables = [archive11, archive12]
        AllTasks?.value.append(Dynamic(archive10))
        archivedTasks = Dynamic([Dynamic(archive1), Dynamic(archive2), Dynamic(archive3), Dynamic(archive4), Dynamic(archive5), Dynamic(archive6), Dynamic(archive7), Dynamic(archive8), Dynamic(archive9), Dynamic(archive11), Dynamic(archive12)])
    }
    
    // CRUD
    
    func createNewTask(_task : Task) -> Bool {
        if _task.isValid()  && !AllTasks!.value.map({ $0.value.Name! }).contains(where: { $0 == _task.Name! }) {
            AllTasks!.value.append(Dynamic(_task))
            sortAllTasks()
            if !_task.isRepeatable() {
                tasksToPopulate!.value.append(Dynamic(_task))
                sortDisplayedTasks(forWindow: Constants.mainTaskVC_upper_limit_calendar_unit, units: Constants.mainTaskVC_upper_limit_number_of_units)
            }
            return true
        }
        return false
    }
    
    func createNewTempRepeatableTask(_task : Task) -> Bool {
        if _task.isValid() {
            AllTasks!.value.append(Dynamic(_task))
            sortAllTasks()
            return true
        }
        return false
    }
    
    
    
    func getTaskByID(_id : Int) -> Task? {
        for task in AllTasks!.value {
            if task.value.ID! == _id {
                return task.value
            }
        }
        
        return nil
    }
    
    func updateTask(_task : Task) -> Bool {
        for task in AllTasks!.value {
            if task.value.ID! == _task.ID && _task.isValid() {
                editTask(_task: _task, indexOf: AllTasks!.value.index(of: task)!, _populated: false)
                return true
            } else if !CollectionHelper.IsNilOrEmpty(_coll: _task.unwrappedRepeatables) {
                for repeatableTask in tasksToPopulate!.value {
                    for repeatable in task.value.unwrappedRepeatables! {
                        if repeatableTask.value == repeatable {
                            editTask(_task: repeatable, indexOf: tasksToPopulate!.value.index(of: Dynamic(repeatable))!, _populated: true)
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    func editArchivedTask(_task : Task) {
        archivedTasks!.value[archivedTasks!.value.index(of: Dynamic(_task))!] = Dynamic(_task)
    }
    
    func editTask(_task : Task, indexOf: Int, _populated : Bool) {
        print("New: \(_task.Name!)")
        AllTasks!.value[indexOf] = Dynamic(_task)
        /*for check in AllTasks!.value {
            print("Indexed: \(check.value.Name!)")
        }*/
        if _task.FinishTime != nil && !NumberHelper.isNilOrZero(num: _task.timeOnTask) && !_task.inProgress {
            if archiveTask(_task: _task) {
                //delegate?.taskDidUpdate(_task: _task)
                return
            } else if _task.isRepeatable() {
                populateRepeatables()
                sortAllTasks()
                return
            } else {
                print("Problem archiving")
                return
            }
        } else {
            //populateNonRepeatables()
            sortAllTasks()
            return
        }
    }
    
    func deleteTask(_task : Task) {
        if !CollectionHelper.IsNilOrEmpty(_coll: _task.unwrappedRepeatables) {
            for task in _task.unwrappedRepeatables! {
                deleteTask(_task: task)
            }
        }
        if let checkIndex = AllTasks?.value.index(of: Dynamic(_task)) {
            print("delete successful")
            AllTasks!.value.remove(at: checkIndex)
        }
        if let checkIndex = archivedTasks?.value.index(of: Dynamic(_task)) {
            print("delete successful")
            archivedTasks!.value.remove(at: checkIndex)
        }
        sortAllTasks()
        delegate?.handleModelUpdate()
    }
    
    func archiveTask(_task: Task) -> Bool {
        let index = AllTasks!.value.index(of: Dynamic(_task))
        let populatedIndex = tasksToPopulate?.value.index(of: Dynamic(_task))
        if let _ = index {
            AllTasks!.value.remove(at: index!)
            if let _ = populatedIndex {
                tasksToPopulate!.value.remove(at: populatedIndex!)
            }
            addToArchive(_task: _task)
            return true
        }
        if let _ = populatedIndex {
            tasksToPopulate!.value.remove(at: populatedIndex!)
            addToArchive(_task: _task)
            return true
        }
        return false
    }
    
    func addToArchive(_task: Task) {
        if let _ = archivedTasks {
            archivedTasks?.value.append(Dynamic(_task))
        } else {
            archivedTasks = Dynamic([Dynamic(_task)])
        }
    }
    
    func deArchive(_task: Task) -> Bool {
        _task.FinishTime = nil
        _task.StartTime = NSDate()
        editArchivedTask(_task: _task)
        print("Update successful")
        AllTasks!.value.append(Dynamic(_task))
        archivedTasks!.value.remove(at: Int(archivedTasks!.value.index(of: Dynamic(_task))!))
        return true
    }
    
    // Filter displayed tasks
    
    func applyFilter(categories : [Category]?, timeCategories : [TimeCategory]?) {
        if(CollectionHelper.IsNilOrEmpty(_coll: categories) && CollectionHelper.IsNilOrEmpty(_coll: timeCategories)) {
            //print("No filter")
            loadTasks()
            return
        }
        if !CollectionHelper.IsNilOrEmpty(_coll: tasksToPopulate!.value) {
            tasksToPopulate!.value.removeAll()
        }
        populateNonRepeatables()
        populateRepeatables()
        filteredTasks = Dynamic([Dynamic<Task>]())
        for _task in tasksToPopulate!.value {
            
            var addToFilter : Bool = false
            if _task.value.Categories != nil && !CollectionHelper.IsNilOrEmpty(_coll: categories) {
                for _category in _task.value.Categories! {
                    for _checkCategory in categories! {
                        if(_category.Name! == _checkCategory.Name!) {
                            addToFilter = true
                            break
                        }
                    }
                }
            }
            
            if _task.value.TimeCategory != nil && !CollectionHelper.IsNilOrEmpty(_coll: timeCategories) {
                for _checkCategory in timeCategories! {
                    if(_task.value.TimeCategory!.Name! == _checkCategory.Name!) {
                        addToFilter = true
                        break
                    }
                }
            }
        
            if(addToFilter) {
                filteredTasks!.value.append(_task)
                addToFilter = false
            }
        }
        
        tasksToPopulate = filteredTasks
        
        if let _ = delegate {
            delegate?.handleModelUpdate()
        }
    }
    
    func applyFilterToAllTasks(categories : [Category]?, timeCategories : [TimeCategory]?) -> Dynamic<[Dynamic<Task>]>? {
        if AllTasks == nil {
            loadTasks()
        }
        if(CollectionHelper.IsNilOrEmpty(_coll: categories) && CollectionHelper.IsNilOrEmpty(_coll: timeCategories)) {
            //print("No filter")
            return AllTasks
        }
        filteredTasks = Dynamic([Dynamic<Task>]())
        for _task in AllTasks!.value {
            
            var addToFilter : Bool = false
            if _task.value.Categories != nil && !CollectionHelper.IsNilOrEmpty(_coll: categories) {
                for _category in _task.value.Categories! {
                    for _checkCategory in categories! {
                        if(_category.Name! == _checkCategory.Name!) {
                            addToFilter = true
                            break
                        }
                    }
                }
            }
            
            if _task.value.TimeCategory != nil && !CollectionHelper.IsNilOrEmpty(_coll: timeCategories) {
                for _checkCategory in timeCategories! {
                    if(_task.value.TimeCategory!.Name! == _checkCategory.Name!) {
                        addToFilter = true
                        break
                    }
                }
            }
            
            if(addToFilter) {
                filteredTasks!.value.append(_task)
                addToFilter = false
            }
        }
        
        return filteredTasks
    }
    
    func applyFilterToTasks(_tasks : [Task], categories : [Category]?, timeCategories : [TimeCategory]?) -> Dynamic<[Dynamic<Task>]> {
        if(CollectionHelper.IsNilOrEmpty(_coll: categories) && CollectionHelper.IsNilOrEmpty(_coll: timeCategories)) {
            //print("No filter")
            return Dynamic(Dynamic.wrapArray(array: _tasks))
        }
        filteredTasks = Dynamic([Dynamic<Task>]())
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
                filteredTasks!.value.append(Dynamic(_task))
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
            tasksToPopulate = Dynamic([Dynamic<Task>]())
        }
        tasksToPopulate!.value.removeAll()
        for _task in AllTasks!.value {
            if !_task.value.isRepeatable() && tasksToPopulate!.value.index(of: _task) == nil {
                tasksToPopulate!.value.append(_task)
            }
        }
        
    }
    
    func populateRepeatables() {
        if AllTasks == nil {
            return
        }
        if tasksToPopulate == nil {
            tasksToPopulate = Dynamic([Dynamic<Task>]())
        }
        let tempTasks = AllTasks!
        for _task in tempTasks.value {
            if _task.value.isRepeatable() {
                if !CollectionHelper.IsNilOrEmpty(_coll: _task.value.unwrappedRepeatables) {
                    clearOldRepeatablesFrom(_task: _task.value)
                } else {
                    _task.value.unwrappedRepeatables = [Task]()
                }
                for i in 0..<Constants.repeatablesToGenerate {
                    var units = i
                    let component : TimeInterval
                    if _task.value.RepeatableTask!.UnitOfTime! == .Daily {
                        component = TimeInterval(Constants.seconds_per_day)
                    } else if _task.value.RepeatableTask!.UnitOfTime! == .Hourly {
                        component = TimeInterval(Constants.seconds_per_hour)
                    } else {
                        component = TimeInterval(Constants.seconds_per_day)
                        units *= 7
                    }
                    let taskToAdd = Task(_name: "\(_task.value.Name!)\(i)", _description: _task.value.Description!, _start: _task.value.RepeatableTask?.FirstOccurrence!.addingTimeInterval(component * TimeInterval(units)), _finish: nil, _category: _task.value.Categories, _timeCategory: _task.value.TimeCategory, _repeatable: nil)
                    taskToAdd.parentID = _task.value.ID!
                    taskToAdd.ID = Int(NSDate().timeIntervalSince1970) + Int(taskToAdd.StartTime!.timeIntervalSince1970)
                    tasksToPopulate!.value.append(Dynamic(taskToAdd))
                    _task.value.unwrappedRepeatables!.append(taskToAdd)
                }
            }
        }
        sortAllTasks()
    }
    
    
    
    func clearOldRepeatablesFrom(_task : Task) {
        for repeatable in _task.unwrappedRepeatables! {
            if let index = tasksToPopulate!.value.index(of: Dynamic(repeatable)) {
                tasksToPopulate!.value.remove(at: index)
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
        for _task in tempTasks.value {
            if (_task.value.StartTime! as Date) > upperLimit! {
                let indexOf = tasksToPopulate!.value.index(of: _task)
                tasksToPopulate!.value.remove(at: indexOf!)
            }
        }
        tasksToPopulate!.value.sort(by: {
            return ($0.value.StartTime! as Date) < ($1.value.StartTime! as Date)
        })
        delegate?.handleModelUpdate()
    }
    
    func sortAllTasks() {
        for _task in AllTasks!.value {
            if _task.value.isRepeatable() {
                if !CollectionHelper.IsNilOrEmpty(_coll: _task.value.unwrappedRepeatables) {
                    _task.value.unwrappedRepeatables!.sort(by: {
                        return ($0.StartTime! as Date) < ($1.StartTime! as Date)
                    })
                    _task.value.StartTime = _task.value.unwrappedRepeatables![0].StartTime
                } else {
                    _task.value.StartTime = Date().addingTimeInterval(500000) as NSDate?
                }
            }
        }
        
        AllTasks!.value.sort(by: {
            return ($0.value.StartTime! as Date) < ($1.value.StartTime! as Date)
        })
        sortDisplayedTasks(forWindow: Constants.mainTaskVC_upper_limit_calendar_unit, units: Constants.mainTaskVC_upper_limit_number_of_units)
        //delegate?.handleModelUpdate()
    }
    
    func sortArchivedTasks() {
        if let _ = archivedTasks {
            archivedTasks!.value.sort(by: {
                return ($0.value.StartTime! as Date) < ($1.value.StartTime! as Date)
            })
        }
    }
}

protocol TaskDTODelegate {
    func handleModelUpdate()
    func taskDidUpdate(_task : Task)
}
