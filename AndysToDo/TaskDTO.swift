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
    
    var AllTasks : Dynamic<[Dynamic<Task>]>?
    
    init() {
        CategoryDTO.shared.loadCategories()
        TimeCategoryDTO.shared.loadTimeCategories()
        loadTasks()
    }
    
    class var globalManager : TaskDTO {
        return allTasks
    }
    
    func loadTasks() {
        if let _ = AllTasks {
            // Don't load fake tasks more than once
            return
        }
        AllTasks = loadFakeTasks()
    }
    
    func loadFakeTasks() -> Dynamic<[Dynamic<Task>]> {
        let task1 = Task(_name: "Task 1", _description: "Fake task", _start: Date().addingTimeInterval(5400) as NSDate?, _finish: nil, _category: nil, _timeCategory: nil, _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        task1.ID = IDGenerator.shared.nextTaskID
        let task2 = Task(_name: "Task 2", _description: "Fake task with a fake category", _start: Date().addingTimeInterval(720000) as NSDate?, _finish: nil, _category: [CategoryDTO.shared.AllCategories!.value[0].value], _timeCategory: nil, _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        task2.ID = IDGenerator.shared.nextTaskID
        let task3 = Task(_name: "Task 3", _description: "Fake task with multiple fake categories", _start: Date().addingTimeInterval(3600) as NSDate?, _finish: nil, _category: [CategoryDTO.shared.AllCategories!.value[1].value, CategoryDTO.shared.AllCategories!.value[0].value, CategoryDTO.shared.AllCategories!.value[2].value], _timeCategory: nil, _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        task3.ID = IDGenerator.shared.nextTaskID
        let task4 = Task(_name: "Task 4", _description: "Fake task with a fake time category", _start: Date().addingTimeInterval(14400) as NSDate?, _finish: nil, _category: [CategoryDTO.shared.AllCategories!.value[1].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[2].value, _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        task4.ID = IDGenerator.shared.nextTaskID
        let repeatable1 = RepeatableTaskOccurrence(_unit: RepetitionTimeCategory.Daily, _unitCount: 2, _time: 13.5, _firstOccurrence: Date().addingTimeInterval(4000) as NSDate?, _dayOfWeek: nil)
        let task5 = Task(_name: "Task 5", _description: "Fake task with daily repetition", _start: Date().addingTimeInterval(4000) as NSDate?, _finish: nil, _category: [CategoryDTO.shared.AllCategories!.value[2].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[2].value, _repeatable: repeatable1, _dueDate: nil, _parent: nil, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        task5.ID = IDGenerator.shared.nextTaskID
        task5.inProgress = true
        let repeatble2 = RepeatableTaskOccurrence(_unit: RepetitionTimeCategory.Weekly, _unitCount: 1, _time: 12.0, _firstOccurrence: Date().addingTimeInterval(400000) as NSDate?, _dayOfWeek: DayOfWeek.Monday)
        let task6 = Task(_name: "Task 6", _description: "Fake task with weekly repetition", _start: Date().addingTimeInterval(400000) as NSDate?, _finish: nil, _category: [CategoryDTO.shared.AllCategories!.value[2].value, CategoryDTO.shared.AllCategories!.value[0].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[1].value, _repeatable: repeatble2, _dueDate: nil, _parent: nil, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        task6.ID = IDGenerator.shared.nextTaskID
        let taskToDelete = Task(_name: "Task to delete", _description: "Shouldn't show", _start: Date()
            .addingTimeInterval(4000) as NSDate?, _finish: nil, _category: nil, _timeCategory: nil, _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        taskToDelete.ID = IDGenerator.shared.nextTaskID
        return Dynamic([Dynamic(task1), Dynamic(task2), Dynamic(task3), Dynamic(task4), Dynamic(task5), Dynamic(task6), Dynamic(taskToDelete)])
    }
    
    
    
    // CRUD
    
    func createNewTask(_task : Task) -> Bool {
        if _task.isValid()  && !AllTasks!.value.map({ $0.value.Name! }).contains(where: { $0 == _task.Name! }) {
            AllTasks!.value.append(Dynamic(_task))
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
            }
        }
        return false
    }
    
    func editTask(_task : Task, indexOf: Int, _populated : Bool) {
        AllTasks!.value[indexOf] = Dynamic(_task)
        if _task.FinishTime != nil && !NumberHelper.isNilOrZero(num: _task.timeOnTask) && !_task.inProgress {
            let _ = archiveTask(_task: _task)
        }
    }
    
    func deleteTask(_task : Task) {
        if !CollectionHelper.IsNilOrEmpty(_coll: _task.unwrappedRepeatables) {
            for task in _task.unwrappedRepeatables! {
                deleteTask(_task: task)
            }
        }
        if let checkIndex = AllTasks!.value.index(of: Dynamic(_task)) {
            AllTasks!.value.remove(at: checkIndex)
        }
    }
    
    // Temporary tasks
    
    func createNewTempRepeatableTask(_task : Task) -> Bool {
        if _task.isValid() {
            AllTasks!.value.append(Dynamic(_task))
            return true
        }
        return false
    }
    
    
    func archiveTask(_task: Task) -> Bool {
        let index = AllTasks!.value.index(of: Dynamic(_task))
        if let _ = index {
            AllTasks!.value.remove(at: index!)
            ArchivedTaskDTO.shared.addToArchive(_task: _task)
            return true
        }
        return false
    }
    
    func deArchive(task : Task) {
        AllTasks!.value.append(Dynamic(task))
    }
}
