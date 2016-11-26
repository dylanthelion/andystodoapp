//
//  DisplayInactiveTaskViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/7/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

private var taskHandle : UInt8 = 0
private var timecatHandle : UInt8 = 0

class DisplayInactiveTaskViewModel {
    
    // Model
    
    var AllTimeCategories : [TimeCategory]?
    
    // View model
    
    var task : Dynamic<Task>?
    var Name : String?
    var Description : String?
    var StartTime : NSDate?
    var FinishTime : NSDate?
    var inProgress : Bool = false
    var Categories : [Category]?
    var TimeCategory : TimeCategory?
    var dueDate : NSDate?
    var expectedTimeRequirement : (UnitOfTime, Int)? = (UnitOfTime.Null, 0)
    
    // Date Picker
    
    var startMonth: String?
    var startDay: String?
    var startHours : String?
    
    init() {
        updateTimecats()
        AllTimeCategories = TimeCategoryDTO.shared.AllTimeCategories?.value.map({ $0.value })
        self.timecatDTOBond.bind(dynamic: TimeCategoryDTO.shared.AllTimeCategories!)
        self.taskDTOBond.bind(dynamic: TaskDTO.globalManager.AllTasks!)
    }
    
    // Binding
    
    var timecatDTOBond: Bond<[Dynamic<TimeCategory>]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &timecatHandle) as AnyObject? {
            return b as! Bond<[Dynamic<TimeCategory>]>
        } else {
            let b = Bond<[Dynamic<TimeCategory>]>() { [unowned self] v in
                self.updateTimecats()
            }
            objc_setAssociatedObject(self, &timecatHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    var taskDTOBond: Bond<[Dynamic<Task>]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &taskHandle) as AnyObject? {
            return b as! Bond<[Dynamic<Task>]>
        } else {
            let b = Bond<[Dynamic<Task>]>() { [unowned self] v in
                self.updateTask()
            }
            objc_setAssociatedObject(self, &taskHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // Model setup
    
    func setTask(newTask: Task) {
        task = Dynamic(newTask)
        Name = newTask.Name
        Description = newTask.Description
        Categories = newTask.Categories
        TimeCategory = newTask.TimeCategory
        StartTime = newTask.StartTime
        dueDate = newTask.dueDate
        expectedTimeRequirement = newTask.expectedTimeRequirement
        FinishTime = newTask.FinishTime
        inProgress = newTask.inProgress
        startMonth = TimeConverter.dateToMonthConverter(_time: task!.value.StartTime!)
        startDay = TimeConverter.dateToDateOfMonthConverter(_time: task!.value.StartTime!)
        startHours = TimeConverter.dateToTimeWithMeridianConverter(_time: task!.value.StartTime!)
    }
    
    func updateTask() {
        if task == nil {
            return
        }
        for t in TaskDTO.globalManager.AllTasks!.value {
            if t.value == task?.value {
                task = t
            }
        }
    }
    
    func updateTimecats() {
        AllTimeCategories = TimeCategoryDTO.shared.AllTimeCategories!.value.map({ $0.value })
    }
    
    // Chosen categories
    
    func addCategory(_category : Category) {
        if let _ = self.Categories {
            self.Categories!.append(_category)
        } else {
            self.Categories = [_category]
        }
    }
    
    func removeCategory(_category : Category) {
        let indexOf = self.Categories?.index(of: _category)
        self.Categories?.remove(at: indexOf!)
    }
    
    // Model values
    
    func updateExpectedTimeRequirement(newUnitOfTime : UnitOfTime?, newValue: Int?) {
        var unit : UnitOfTime? = expectedTimeRequirement!.0
        var value : Int? = expectedTimeRequirement!.1
        if let _ = newUnitOfTime {
            unit = newUnitOfTime
        }
        if let _ = newValue {
            value = newValue
        }
        expectedTimeRequirement = (unit!, value!)
    }
    
    // Submit
    
    func submit() -> (Bool, String, String) {
        let check = validateNonRepeatableTask()
        if !check.0 {
            return (false, Constants.standard_alert_error_title, check.1)
        }
        return (true, Constants.standard_alert_ok_title, Constants.createTaskVC_alert_success_message)
    }
    
    func postpone() -> Bool {
        if !NumberHelper.isNilOrZero(num: task?.value.timeOnTask) && (task?.value.inProgress)! {
            let timeToAdd : TimeInterval = Date().timeIntervalSince(task?.value.StartTime! as! Date)
            task!.value.timeOnTask! += timeToAdd
        }
        task!.value.StartTime! = task!.value.StartTime!.addingTimeInterval(86400)
        task?.value.inProgress = false
        if TaskDTO.globalManager.updateTask(_task: task!.value) {
            return true
        } else {
            print("Something went wrong postponing task")
            return false
        }
    }
    
    // Validation
    
    func validateNonRepeatableTask() -> (Bool, String) {
        let unit : UnitOfTime?
        let number : Int?
        if let _ = expectedTimeRequirement {
            unit = expectedTimeRequirement!.0
            number = expectedTimeRequirement!.1
        } else {
            unit = nil
            number = nil
        }
        let formatter = StandardDateFormatter()
        let df = DateFormatter()
        df.dateFormat = Constants.standard_month_format
        let year : String = formatter.getNextMonthOccurrence(startMonth: startMonth!, startDay: startDay!)
        //print("\(startMonth!) \(startDay!) \(startHours!) \(year)")
        let date = formatter.date(from: "\(startMonth!) \(startDay!) \(startHours!) \(year)")! as NSDate
        let newTask = Task(_name: Name!, _description: Description!, _start: date, _finish: FinishTime, _category: Categories, _timeCategory: TimeCategory, _repeatable: nil, _dueDate: dueDate, _parent: task?.value.parentID, _expectedUnitOfTime: unit, _expectedTotalUnits: number)
        newTask.ID = task?.value.ID
        if TaskDTO.globalManager.updateTask(_task: newTask) {
            return (true, Constants.createTaskVC_alert_success_message)
        } else {
            return (false, Constants.createTaskVC_alert_invalid_nonrepeatable_failure_message)
        }
    }
}
