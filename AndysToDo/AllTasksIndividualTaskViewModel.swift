//
//  AllTasksIndividualTaskViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/8/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation


private var taskHandle : UInt8 = 0
private var catHandle : UInt8 = 0
private var timecatHandle : UInt8 = 0

class AllTasksIndividualTaskViewModel {
    
    // DatePickerViewDelegateViewDelegate
    
    var startMonth: String?
    var startDay: String?
    var startHours : String?
    
    // Model values
    
    var task : Dynamic<Task>?
    var AllTimeCategories : Dynamic<[TimeCategory]>?
    var AllCategories : [Category]?
    var TimeCategory : TimeCategory?
    var RepeatableTask : RepeatableTaskOccurrence?
    var expectedTimeRequirement : (UnitOfTime, Int)?
    var StartTime : NSDate?
    var Name : String?
    var Description : String?
    var multipleRepeatables : [RepeatableTaskOccurrence]?
    var dueDate : NSDate?
    var FinishTime : NSDate?
    var inProgress : Bool = false
    var unwrappedRepeatables : [Task]?
    var siblingRepeatables : [Task]?
    var parentID : Int?
    var timeOnTask : TimeInterval?
    
    init() {
        self.timecatDTOBond.bind(dynamic: TimeCategoryDTO.shared.AllTimeCategories!)
        self.taskDTOBond.bind(dynamic: TaskDTO.globalManager.AllTasks!)
        AllTimeCategories = Dynamic(TimeCategoryDTO.shared.AllTimeCategories!.value.map({ $0.value }))
    }
    
    // Binding
    
    var timecatDTOBond: Bond<[Dynamic<TimeCategory>]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &timecatHandle) as AnyObject? {
            return b as! Bond<[Dynamic<TimeCategory>]>
        } else {
            let b = Bond<[Dynamic<TimeCategory>]>() { [unowned self] v in
                //print("Update timecats in view model")
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
                //print("update task in view model")
                self.updateTask()
            }
            objc_setAssociatedObject(self, &taskHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // Setup model
    
    func setup() {
        if task!.value.isRepeatable() {
            RepeatableTask = task!.value.RepeatableTask
        }
        if let _ = task!.value.expectedTimeRequirement, let _ = expectedTimeRequirement {
            expectedTimeRequirement = (task!.value.expectedTimeRequirement!.0, expectedTimeRequirement!.1)
        }
        StartTime = task!.value.StartTime
        AllCategories = task!.value.Categories
        TimeCategory = task!.value.TimeCategory
        startHours = TimeConverter.dateToTimeWithMeridianConverter(_time: task!.value.StartTime!)
        startMonth = TimeConverter.dateToMonthConverter(_time: task!.value.StartTime!)
        startDay = TimeConverter.dateToDateOfMonthConverter(_time: task!.value.StartTime!)
    }
    
    // reset
    
    func resetModel() {
        //repeatable = false
        RepeatableTask = nil
        //multipleRepeatables = nil
        expectedTimeRequirement = nil
    }
    
    func setTask(newTask: Task) {
        if task == nil {
            task = Dynamic(newTask)
        } else {
           task!.value = newTask
        }
        Name = newTask.Name
        Description = newTask.Description
        AllCategories = newTask.Categories
        TimeCategory = newTask.TimeCategory
        StartTime = newTask.StartTime
        dueDate = newTask.dueDate
        expectedTimeRequirement = newTask.expectedTimeRequirement
        FinishTime = newTask.FinishTime
        inProgress = newTask.inProgress
        RepeatableTask = newTask.RepeatableTask
        unwrappedRepeatables = newTask.unwrappedRepeatables
        siblingRepeatables = newTask.siblingRepeatables
        parentID = newTask.parentID
        timeOnTask = newTask.timeOnTask
    }
    
    func updateTask() {
        if task == nil {
            return
        }
        for t in TaskDTO.globalManager.AllTasks!.value {
            if t.value == task?.value {
                setTask(newTask: t.value)
                break
            }
        }
    }
    
    func updateTimecats() {
        AllTimeCategories = Dynamic(TimeCategoryDTO.shared.AllTimeCategories!.value.map({ $0.value }))
    }
    
    // Model values
    
    func updateExpectedTimeRequirement(newUnitOfTime : UnitOfTime?, newValue: Int?) {
        var unit : UnitOfTime?
        var value : Int?
        if let _ = expectedTimeRequirement {
            unit = expectedTimeRequirement!.0
            value = expectedTimeRequirement!.1
        } else {
            unit = UnitOfTime.Null
            value = 0
        }
        if let _ = newUnitOfTime {
            unit = newUnitOfTime
        }
        if let _ = newValue {
            value = newValue
        }
        expectedTimeRequirement = (unit!, value!)
    }
    
    // Chosen categories
    
    func addCategory(_category : Category) {
        if let _ = self.AllCategories {
            self.AllCategories!.append(_category)
        } else {
            self.AllCategories = [_category]
        }
    }
    
    func removeCategory(_category : Category) {
        let indexOf = self.AllCategories?.index(of: _category)
        self.AllCategories?.remove(at: indexOf!)
    }
    
    // Submit
    
    func submit() -> (Bool, String, String)  {
        if task!.value.isRepeatable() {
            if !validateRepeatable() {
                return (false, Constants.standard_alert_fail_title, Constants.createTaskVC_alert_invalid_repeatable_information_failure_message)
            } else {
                return (true, Constants.standard_alert_ok_title, Constants.createTaskVC_alert_success_message)
            }
        } else {
            if !validateNonRepeatableTask() {
                return (false, Constants.standard_alert_fail_title, Constants.createTaskVC_alert_invalid_nonrepeatable_failure_message)
            } else {
                return (true, Constants.standard_alert_ok_title, Constants.createTaskVC_alert_success_message)
            }
        }
    }
    
    func generateNewTask() -> (Bool, String, String) {
        if task!.value.isRepeatable() {
            if validateNewRepeatableInstance() {
                return (true, Constants.standard_alert_ok_title, Constants.createTaskVC_alert_success_message)
            } else {
                return (false, Constants.standard_alert_fail_title, Constants.createTaskVC_alert_invalid_repeatable_information_failure_message)
            }
        } else {
            if validateNewInstance() {
                return (true, Constants.standard_alert_ok_title, Constants.createTaskVC_alert_success_message)
            } else {
                return (false, Constants.standard_alert_fail_title, Constants.createTaskVC_alert_invalid_nonrepeatable_failure_message)
            }
        }
    }
    
    // Validation
    
    func validateRepeatable() -> Bool {
        var units : UnitOfTime? = nil
        var totalUnits : Int? = nil
        if let _ = expectedTimeRequirement {
            if expectedTimeRequirement!.0 != UnitOfTime.Null && expectedTimeRequirement!.1 >= 0 {
                units = expectedTimeRequirement!.0
                totalUnits = expectedTimeRequirement!.1
            }
        }
        let formatter = StandardDateFormatter()
        let df = DateFormatter()
        df.dateFormat = Constants.standard_month_format
        let year : String = formatter.getNextMonthOccurrence(startMonth: startMonth!, startDay: startDay!)
        let date = formatter.date(from: "\(startMonth!) \(startDay!) \(startHours!) \(year)")! as NSDate
        let newTask = Task(_name: Name!, _description: Description!, _start: date, _finish: nil, _category: AllCategories, _timeCategory: TimeCategory, _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: units, _expectedTotalUnits: totalUnits)
        newTask.ID = task!.value.ID!
        if TaskDTO.globalManager.updateTask(_task: newTask) {
            return true
        } else {
            //resetRepeatableTextFields()
            return false
        }
    }
    
    func validateNonRepeatableTask() -> Bool {
        var units : UnitOfTime? = nil
        var totalUnits : Int? = nil
        if let _ = expectedTimeRequirement {
            if expectedTimeRequirement!.0 != UnitOfTime.Null && expectedTimeRequirement!.1 >= 0 {
                units = expectedTimeRequirement!.0
                totalUnits = expectedTimeRequirement!.1
            }
        }
        let formatter = StandardDateFormatter()
        let df = DateFormatter()
        df.dateFormat = Constants.standard_month_format
        let year : String = formatter.getNextMonthOccurrence(startMonth: startMonth!, startDay: startDay!)
        //print("\(startMonth!) \(startDay!) \(startHours!) \(year)")
        let date = formatter.date(from: "\(startMonth!) \(startDay!) \(startHours!) \(year)")! as NSDate
        let newTask = Task(_name: Name!, _description: Description!, _start: date, _finish: nil, _category: AllCategories, _timeCategory: TimeCategory, _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: units, _expectedTotalUnits: totalUnits)
        newTask.ID = task!.value.ID!
        if TaskDTO.globalManager.updateTask(_task: newTask) {
            return true
        } else {
            return false
        }
    }
    
    func validateNewInstance() -> Bool {
        var units : UnitOfTime? = nil
        var totalUnits : Int? = nil
        if let _ = expectedTimeRequirement {
            if expectedTimeRequirement!.0 != UnitOfTime.Null && expectedTimeRequirement!.1 >= 0 {
                units = expectedTimeRequirement!.0
                totalUnits = expectedTimeRequirement!.1
            }
        }
        let formatter = StandardDateFormatter()
        let df = DateFormatter()
        df.dateFormat = Constants.standard_month_format
        let year : String = formatter.getNextMonthOccurrence(startMonth: startMonth!, startDay: startDay!)
        //print("\(startMonth!) \(startDay!) \(startHours!) \(year)")
        let date = formatter.date(from: "\(startMonth!) \(startDay!) \(startHours!) \(year)")! as NSDate
        let newTask = Task(_name: "Temp \(Name!)", _description: Description!, _start: date, _finish: nil, _category: AllCategories, _timeCategory: TimeCategory, _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: units, _expectedTotalUnits: totalUnits)
        if TaskDTO.globalManager.createNewTask(_task: newTask) {
            return true
        } else {
            return false
        }
    }
    
    func validateNewRepeatableInstance() -> Bool {
        var units : UnitOfTime? = nil
        var totalUnits : Int? = nil
        if let _ = expectedTimeRequirement {
            if expectedTimeRequirement!.0 != UnitOfTime.Null && expectedTimeRequirement!.1 >= 0 {
                units = expectedTimeRequirement!.0
                totalUnits = expectedTimeRequirement!.1
            }
        }
        let formatter = StandardDateFormatter()
        let df = DateFormatter()
        df.dateFormat = Constants.standard_month_format
        let year : String = formatter.getNextMonthOccurrence(startMonth: startMonth!, startDay: startDay!)
        //print("\(startMonth!) \(startDay!) \(startHours!) \(year)")
        let date = formatter.date(from: "\(startMonth!) \(startDay!) \(startHours!) \(year)")! as NSDate
        let newTask = Task(_name: "Temp \(Name!) instance", _description: Description!, _start: date, _finish: nil, _category: AllCategories, _timeCategory: TimeCategory, _repeatable: nil, _dueDate: nil, _parent: self.task!.value.ID!, _expectedUnitOfTime: units, _expectedTotalUnits: totalUnits)
        if TaskDTO.globalManager.createNewTempRepeatableTask(_task: newTask) {
            return true
        } else {
            //resetRepeatableTextFields()
            return false
        }
    }
}
