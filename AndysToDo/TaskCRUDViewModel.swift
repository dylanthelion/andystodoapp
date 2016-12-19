//
//  TaskCRUDViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/10/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class TaskCRUDViewModel : DatePickerViewModel, CategoryCRUDViewModel {
    
    // Model
    
    var startMonth: String?
    var startDay: String?
    var startHours : String?
    var allCategories : [Category]?
    var allTimeCategories : Dynamic<[TimeCategory]>?
    var task : Dynamic<Task>?
    var name : String?
    var description : String?
    var startTime : NSDate?
    var finishTime : NSDate?
    var inProgress : Bool = false
    var categories : [Category]? = [Category]()
    var timeCategory : TimeCategory?
    var repeatableTask : RepeatableTaskOccurrence?
    var unwrappedRepeatables : [Task]?
    var siblingRepeatables : [Task]?
    var parentID : Int?
    var timeOnTask : TimeInterval?
    var dueDate : NSDate?
    var expectedTimeRequirement : ExpectedTimeRequirement
    var repeatable : Dynamic<Bool> = Dynamic(false)
    var multipleRepeatables : [RepeatableTaskOccurrence]?
    
    // Date Picker
    
    init() {
        expectedTimeRequirement = ExpectedTimeRequirement(_unit: .Null, _numberOfUnits: 0)
        updateCategories()
        updateTimecats()
    }
    
    // Update
    
    func setTask(newTask: Task) {
        if task == nil {
            task = Dynamic(newTask)
        } else {
            task?.value = newTask
        }
        name = newTask.Name
        description = newTask.Description
        if let _ = newTask.Categories {
            categories = newTask.Categories
        } else {
            categories = [Category]()
        }
        timeCategory = newTask.TimeCategory
        startTime = newTask.StartTime
        dueDate = newTask.dueDate
        expectedTimeRequirement = newTask.expectedTimeRequirement
        finishTime = newTask.FinishTime
        inProgress = newTask.inProgress
        repeatableTask = newTask.RepeatableTask
        unwrappedRepeatables = newTask.unwrappedRepeatables
        siblingRepeatables = newTask.siblingRepeatables
        parentID = newTask.parentID
        timeOnTask = newTask.timeOnTask
        startHours = TimeConverter.dateToTimeWithMeridianConverter(_time: task!.value.StartTime!)
        startMonth = TimeConverter.dateToMonthConverter(_time: task!.value.StartTime!)
        startDay = TimeConverter.dateToDateOfMonthConverter(_time: task!.value.StartTime!)
    }
    
    func updateTask() {
        if task == nil {
            return
        }
        for t in TaskDTO.globalManager.AllTasks!.value {
            if t.value == task!.value {
                task!.value = t.value
            }
        }
    }
    
    func updateTimecats() {
        allTimeCategories = Dynamic(TimeCategoryDTO.shared.AllTimeCategories!.value.map({ $0.value }))
    }
    
    func updateCategories() {
        allCategories = CategoryDTO.shared.AllCategories!.value.map({ $0.value })
    }
    
    // reset
    
    func resetModel() {
        repeatable.value = false
        repeatableTask = nil
        multipleRepeatables = nil
        expectedTimeRequirement = ExpectedTimeRequirement(_unit: .Null, _numberOfUnits: 0)
    }
    
    // Chosen categories
    
    func addCategory(_category : Category) {
        if let _ = categories {
            categories!.append(_category)
        } else {
            categories = [_category]
        }
    }
    
    func removeCategory(_category : Category) {
        let indexOf = categories!.index(of: _category)
        categories!.remove(at: indexOf!)
    }
}
