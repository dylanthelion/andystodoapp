//
//  TaskDTO.swift
//  AndysToDo
//
//  Created by dillion on 10/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private let sharedTasks = TaskDTO()

class TaskDTO : TaskCRUDDTO {
    
    var allTasks : Dynamic<[Dynamic<Task>]>?
    
    init() {
        CategoryDTO.shared.loadCategories()
        TimeCategoryDTO.shared.loadTimeCategories()
        loadTasks()
    }
    
    class var globalManager : TaskDTO {
        return sharedTasks
    }
    
    func loadTasks() {
        if let _ = allTasks {
            // Don't load fake tasks more than once
            return
        }
        allTasks = loadFakeTasks()
    }
    
    func loadFakeTasks() -> Dynamic<[Dynamic<Task>]> {
        let task1 = Task(name: "Task 1", description: "Fake task", start: Date().addingTimeInterval(5400) as NSDate?, finish: nil, category: nil, timeCategory: nil, repeatable: nil, dueDate: nil, parent: nil, expectedUnitOfTime: nil, expectedTotalUnits: nil)
        task1.ID = IDGenerator.shared.nextTaskID
        let task2 = Task(name: "Task 2", description: "Fake task with a fake category", start: Date().addingTimeInterval(720000) as NSDate?, finish: nil, category: [CategoryDTO.shared.allCategories!.value[0].value], timeCategory: nil, repeatable: nil, dueDate: nil, parent: nil, expectedUnitOfTime: nil, expectedTotalUnits: nil)
        task2.ID = IDGenerator.shared.nextTaskID
        let task3 = Task(name: "Task 3", description: "Fake task with multiple fake categories", start: Date().addingTimeInterval(3600) as NSDate?, finish: nil, category: [CategoryDTO.shared.allCategories!.value[1].value, CategoryDTO.shared.allCategories!.value[0].value, CategoryDTO.shared.allCategories!.value[2].value], timeCategory: nil, repeatable: nil, dueDate: nil, parent: nil, expectedUnitOfTime: nil, expectedTotalUnits: nil)
        task3.ID = IDGenerator.shared.nextTaskID
        let task4 = Task(name: "Task 4", description: "Fake task with a fake time category", start: Date().addingTimeInterval(14400) as NSDate?, finish: nil, category: [CategoryDTO.shared.allCategories!.value[1].value], timeCategory: TimeCategoryDTO.shared.allTimeCategories!.value[2].value, repeatable: nil, dueDate: nil, parent: nil, expectedUnitOfTime: nil, expectedTotalUnits: nil)
        task4.ID = IDGenerator.shared.nextTaskID
        let repeatable1 = RepeatableTaskOccurrence(unit: RepetitionTimeCategory.Daily, unitCount: 2, time: 13.5, firstOccurrence: Date().addingTimeInterval(4000) as NSDate?, dayOfWeek: nil)
        let task5 = Task(name: "Task 5", description: "Fake task with daily repetition", start: Date().addingTimeInterval(4000) as NSDate?, finish: nil, category: [CategoryDTO.shared.allCategories!.value[2].value], timeCategory: TimeCategoryDTO.shared.allTimeCategories!.value[2].value, repeatable: repeatable1, dueDate: nil, parent: nil, expectedUnitOfTime: nil, expectedTotalUnits: nil)
        task5.ID = IDGenerator.shared.nextTaskID
        task5.inProgress = true
        let repeatble2 = RepeatableTaskOccurrence(unit: RepetitionTimeCategory.Weekly, unitCount: 1, time: 12.0, firstOccurrence: Date().addingTimeInterval(400000) as NSDate?, dayOfWeek: DayOfWeek.Monday)
        let task6 = Task(name: "Task 6", description: "Fake task with weekly repetition", start: Date().addingTimeInterval(400000) as NSDate?, finish: nil, category: [CategoryDTO.shared.allCategories!.value[2].value, CategoryDTO.shared.allCategories!.value[0].value], timeCategory: TimeCategoryDTO.shared.allTimeCategories!.value[1].value, repeatable: repeatble2, dueDate: nil, parent: nil, expectedUnitOfTime: nil, expectedTotalUnits: nil)
        task6.ID = IDGenerator.shared.nextTaskID
        let taskToDelete = Task(name: "Task to delete", description: "Shouldn't show", start: Date()
            .addingTimeInterval(4000) as NSDate?, finish: nil, category: nil, timeCategory: nil, repeatable: nil, dueDate: nil, parent: nil, expectedUnitOfTime: nil, expectedTotalUnits: nil)
        taskToDelete.ID = IDGenerator.shared.nextTaskID
        return Dynamic([Dynamic(task1), Dynamic(task2), Dynamic(task3), Dynamic(task4), Dynamic(task5), Dynamic(task6), Dynamic(taskToDelete)])
    }
    
    
    
    // CRUD
    
    func createNewTask(_ task : Task) -> Bool {
        if task.isValid()  && !allTasks!.value.map({ $0.value.name! }).contains(where: { $0 == task.name! }) {
            allTasks!.value.append(Dynamic(task))
            return true
        }
        return false
    }
    
    func getTaskByID(_ id : Int) -> Task? {
        for task in allTasks!.value {
            if task.value.ID! == id {
                return task.value
            }
        }
        return nil
    }
    
    func updateTask(_ task : Task) -> Bool {
        for checkTask in allTasks!.value {
            if checkTask.value.ID! == task.ID && task.isValid() {
                editTask(checkTask.value)
                return true
            }
        }
        return false
    }
    
    func editTask(_ task : Task) {
        allTasks!.value[allTasks!.value.index(of: Dynamic(task))!] = Dynamic(task)
        if task.finishTime != nil && !NumberHelper.isNilOrZero(task.timeOnTask) && !task.inProgress {
            let _ = archiveTask(task)
        }
    }
    
    func deleteTask(_ task : Task) {
        if !CollectionHelper.IsNilOrEmpty(task.unwrappedRepeatables) {
            for task in task.unwrappedRepeatables! {
                deleteTask(task)
            }
        }
        if let checkIndex = allTasks!.value.index(of: Dynamic(task)) {
            allTasks!.value.remove(at: checkIndex)
        }
    }
    
    // Temporary tasks
    
    func createNewTempRepeatableTask(_ task : Task) -> Bool {
        if task.isValid() {
            allTasks!.value.append(Dynamic(task))
            return true
        }
        return false
    }
    
    
    func archiveTask(_ task: Task) -> Bool {
        let index = allTasks!.value.index(of: Dynamic(task))
        if let _ = index {
            allTasks!.value.remove(at: index!)
            let _ = ArchivedTaskDTO.shared.archiveTask(task)
            return true
        }
        return false
    }
    
    func deArchive(_ task : Task) {
        allTasks!.value.append(Dynamic(task))
    }
}
