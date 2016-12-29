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
        allCategories = CategoryDTO.shared.allCategories!.value.map({ $0.value })
        var allTimecats : [TimeCategory] = TimeCategoryDTO.shared.allTimeCategories!.value.map({ $0.value })
        allTimecats.append(Constants.timecat_none)
        allTimeCategories = Dynamic(allTimecats)
    }
    
    // Update
    
    func setTask(_ newTask: Task) {
        if task == nil {
            task = Dynamic(newTask)
        } else {
            task!.value = newTask
        }
        name = newTask.name
        description = newTask.description
        if let _ = newTask.categories {
            categories = newTask.categories
        } else {
            categories = [Category]()
        }
        timeCategory = newTask.timeCategory
        startTime = newTask.startTime
        dueDate = newTask.dueDate
        expectedTimeRequirement = newTask.expectedTimeRequirement
        finishTime = newTask.finishTime
        inProgress = newTask.inProgress
        repeatableTask = newTask.repeatableTask
        unwrappedRepeatables = newTask.unwrappedRepeatables
        siblingRepeatables = newTask.siblingRepeatables
        parentID = newTask.parentID
        timeOnTask = newTask.timeOnTask
        startHours = TimeConverter.dateToTimeWithMeridianConverter(task!.value.startTime!)
        startMonth = TimeConverter.dateToMonthConverter(task!.value.startTime!)
        startDay = TimeConverter.dateToDateOfMonthConverter(task!.value.startTime!)
    }
    
    func updateTask() {
        if let _ = task {
            for t in TaskDTO.globalManager.allTasks!.value {
                if t.value == task!.value {
                    task!.value = t.value
                }
            }
        }
    }
    
    func updateTimecats() {
        var allTimecats : [TimeCategory] = TimeCategoryDTO.shared.allTimeCategories!.value.map({ $0.value })
        allTimecats.append(Constants.timecat_none)
        allTimeCategories = Dynamic(allTimecats)
        allTimeCategories!.value = allTimecats
    }
    
    func updateCategories() {
        allCategories = CategoryDTO.shared.allCategories!.value.map({ $0.value })
    }
    
    // reset
    
    func resetModel() {
        repeatable.value = false
        repeatableTask = nil
        multipleRepeatables = nil
        expectedTimeRequirement = ExpectedTimeRequirement(_unit: .Null, _numberOfUnits: 0)
    }
    
    // Chosen categories
    
    func addCategory(_ category : Category) {
        if let _ = categories {
            categories!.append(category)
        } else {
            categories = [category]
        }
    }
    
    func removeCategory(_ category : Category) {
        let indexOf = categories!.index(of: category)
        categories!.remove(at: indexOf!)
    }
}
