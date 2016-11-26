//
//  CreateTaskViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/3/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

private var catHandle : UInt8 = 0
private var timecatHandle : UInt8 = 0
private var taskHandle : UInt8 = 0

class CreateTaskViewModel {
    
    // Model
    
    var AllCategories : [Category]?
    var AllTimeCategories : [TimeCategory]?
    
    // View model
    
    var task : Task?
    var Name : String?
    var Description : String?
    var StartTime : NSDate?
    var FinishTime : NSDate?
    var inProgress : Bool = false
    var Categories : [Category]? = [Category]()
    var TimeCategory : TimeCategory?
    var RepeatableTask : RepeatableTaskOccurrence?
    var unwrappedRepeatables : [Task]?
    var siblingRepeatables : [Task]?
    var parentID : Int?
    var timeOnTask : TimeInterval?
    var dueDate : NSDate?
    var expectedTimeRequirement : (UnitOfTime, Int)? = (UnitOfTime.Null, 0)
    var repeatable : Bool = false
    var multipleRepeatables : [RepeatableTaskOccurrence]?
    
    // Date Picker
    
    var startMonth: String?
    var startDay: String?
    var startHours : String?
    
    init() {
        updateCategories()
        updateTimecats()
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
    
    func setTask(newTask: Task) {
        task = newTask
        Name = newTask.Name
        Description = newTask.Description
        Categories = newTask.Categories
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
    
    // reset
    
    func resetModel() {
        repeatable = false
        RepeatableTask = nil
        multipleRepeatables = nil
        expectedTimeRequirement = nil
    }
    
    func updateTask() {
        if task == nil {
            return
        }
        for t in TaskDTO.globalManager.AllTasks!.value {
            if t.value == task {
                task = t.value
            }
        }
    }
    
    func updateTimecats() {
        AllTimeCategories = TimeCategoryDTO.shared.AllTimeCategories!.value.map({ $0.value })
    }
    
    func updateCategories() {
        AllCategories = CategoryDTO.shared.AllCategories!.value.map({ $0.value })
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
    
    // submit
    
    func submit() -> (Bool, String, String) {
        if repeatable {
            if CollectionHelper.IsNilOrEmpty(_coll: multipleRepeatables) {
                let check = validateRepeatable()
                if !check.0 {
                    
                }
            } else {
                let check = validateMultipleRepeatables(_repeatables: multipleRepeatables!)
                if !check.0 {
                    return (false, Constants.standard_alert_error_title, check.1)
                }
            }
            
        } else {
            let check = validateNonRepeatableTask()
            if !check.0 {
                return (false, Constants.standard_alert_error_title, check.1)
            }
        }
        return (true, Constants.standard_alert_ok_title, Constants.createTaskVC_alert_success_message)
    }
    
    // Validation
    
    func validateRepeatable() -> (Bool, String) {
        var unit : UnitOfTime? = nil
        var number : Int? = nil
        if let _ = expectedTimeRequirement {
            unit = expectedTimeRequirement!.0
            number = expectedTimeRequirement!.1
        }
        if NumberHelper.isNilOrZero(num: number) {
            unit = nil
            number = nil
        }
        let task = Task(_name: Name!, _description: Description!, _start: StartTime, _finish: FinishTime, _category: Categories, _timeCategory: TimeCategory, _repeatable: RepeatableTask, _dueDate: dueDate, _parent: parentID, _expectedUnitOfTime: unit, _expectedTotalUnits: number)
        if TaskDTO.globalManager.createNewTask(_task: task) {
            /*let alertController = UIAlertController(title: Constants.standard_alert_ok_title, message: Constants.createTaskVC_alert_success_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            resetAfterSuccessfulSubmit()*/
            return (true, Constants.createTaskVC_alert_success_message)
        } else {
            /*let alertController = UIAlertController(title: Constants.standard_alert_fail_title, message: Constants.createTaskVC_alert_invalid_repeatable_information_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)*/
            return (false, Constants.createTaskVC_alert_invalid_repeatable_information_failure_message)
        }
    }
    
    func validateMultipleRepeatables(_repeatables : [RepeatableTaskOccurrence]) -> (Bool, String) {
        let unit : UnitOfTime?
        let number : Int?
        if let _ = expectedTimeRequirement {
            unit = expectedTimeRequirement!.0
            number = expectedTimeRequirement!.1
        } else {
            unit = nil
            number = nil
        }
        var newTasks = [Task]()
        var areValid = true
        for (index, _repeatable) in _repeatables.enumerated() {
            let task = Task(_name: Name!, _description: Description!, _start: StartTime, _finish: FinishTime, _category: Categories, _timeCategory: TimeCategory, _repeatable: _repeatable, _dueDate: dueDate, _parent: parentID, _expectedUnitOfTime: unit, _expectedTotalUnits: number)
            if !task.isValidWithoutId() {
                areValid = false
                break
            }
            newTasks.append(task)
            if index != 0 {
                newTasks[0].siblingRepeatables!.append(task)
            }
        }
        
        if areValid {
            for _task in newTasks {
                let _ = TaskDTO.globalManager.createNewTask(_task: _task)
            }
            /*let alertController = UIAlertController(title: Constants.standard_alert_ok_title, message: Constants.createTaskVC_alert_success_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            resetAfterSuccessfulSubmit()*/
            return (true, Constants.createTaskVC_alert_success_message)
        } else {
            /*let alertController = UIAlertController(title: Constants.standard_alert_fail_title, message: Constants.createTaskVC_alert_invalid_repeatable_information_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)*/
            return (false, Constants.createTaskVC_alert_invalid_repeatable_information_failure_message)
        }
    }
    
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
        let task = Task(_name: Name!, _description: Description!, _start: date, _finish: FinishTime, _category: Categories, _timeCategory: TimeCategory, _repeatable: RepeatableTask, _dueDate: dueDate, _parent: parentID, _expectedUnitOfTime: unit, _expectedTotalUnits: number)
        if TaskDTO.globalManager.createNewTask(_task: task) {
            /*let alertController = UIAlertController(title: Constants.standard_alert_ok_title, message: Constants.createTaskVC_alert_success_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            resetAfterSuccessfulSubmit()*/
            return (true, Constants.createTaskVC_alert_success_message)
        } else {
            /*let alertController = UIAlertController(title: Constants.standard_alert_fail_title, message: Constants.createTaskVC_alert_invalid_nonrepeatable_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)*/
            return (false, Constants.createTaskVC_alert_invalid_nonrepeatable_failure_message)
        }
    }
    
    /*func validateAndSubmitTask() -> Bool {
        let unit : UnitOfTime?
        let total : Int?
        if let _ = expectedTimeRequirement {
            unit = expectedTimeRequirement!.0
            total = expectedTimeRequirement!.1
        } else {
            unit = nil
            total = nil
        }
        if let _ = task {
            if TaskDTO.globalManager.updateTask(_task: Task(_name: Name!, _description: Description!, _start: StartTime, _finish: FinishTime, _category: Categories, _timeCategory: TimeCategory, _repeatable: RepeatableTask, _dueDate: dueDate, _parent: parentID, _expectedUnitOfTime: unit, _expectedTotalUnits: total)) {
                return true
            } else {
                return false
            }
        }
        
        if TaskDTO.globalManager.createNewTask(_task: Task(_name: Name!, _description: Description!, _start: StartTime, _finish: FinishTime, _category: Categories, _timeCategory: TimeCategory, _repeatable: RepeatableTask, _dueDate: dueDate, _parent: parentID, _expectedUnitOfTime: unit, _expectedTotalUnits: total)) {
            return true
        } else {
            return false
        }
    }*/
}
