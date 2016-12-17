//
//  CreateTaskViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/3/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

private var timecatHandle : UInt8 = 0
private var taskHandle : UInt8 = 0

class CreateTaskViewModel : TaskCRUDViewModel {
    
    override init() {
        super.init()
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
    
    
    
    // submit
    
    func submit() -> (Bool, String, String) {
        if repeatable.value {
            if CollectionHelper.IsNilOrEmpty(_coll: multipleRepeatables) {
                let check = validateRepeatable()
                if !check.0 {
                    return (false, Constants.standard_alert_error_title, check.1)
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
        let task = Task(_name: name!, _description: description!, _start: startTime, _finish: finishTime, _category: categories, _timeCategory: timeCategory, _repeatable: repeatableTask, _dueDate: dueDate, _parent: parentID, _expectedUnitOfTime: expectedTimeRequirement.unit, _expectedTotalUnits: expectedTimeRequirement.numberOfUnits)
        if TaskDTO.globalManager.createNewTask(_task: task) {
            return (true, Constants.createTaskVC_alert_success_message)
        } else {
            return (false, Constants.createTaskVC_alert_invalid_repeatable_information_failure_message)
        }
    }
    
    func validateMultipleRepeatables(_repeatables : [RepeatableTaskOccurrence]) -> (Bool, String) {
        task = Dynamic(Task(_name: name!, _description: description!, _start: startTime, _finish: finishTime, _category: categories, _timeCategory: timeCategory, _repeatable: repeatableTask, _dueDate: dueDate, _parent: nil, _expectedUnitOfTime: expectedTimeRequirement.unit, _expectedTotalUnits: expectedTimeRequirement._numberOfUnits))
        if let newTasks = RepeatableUnwrapper.generateRepeatablesFrom(repeatables: _repeatables, ofParent: Task(_name: name!, _description: description!, _start: startTime, _finish: finishTime, _category: categories, _timeCategory: timeCategory, _repeatable: repeatableTask, _dueDate: dueDate, _parent: nil, _expectedUnitOfTime: expectedTimeRequirement.unit, _expectedTotalUnits: expectedTimeRequirement._numberOfUnits), withID: task!.value.ID!) {
            if !TaskDTO.globalManager.createNewTask(_task: task!.value) {
                return (false, Constants.createTaskVC_alert_invalid_repeatable_information_failure_message)
            }
            for _task in newTasks {
                let _ = TaskDTO.globalManager.createNewTask(_task: _task)
            }
            return (true, Constants.createTaskVC_alert_success_message)
        }
        return (false, Constants.createTaskVC_alert_invalid_repeatable_information_failure_message)
    }
    
    func validateNonRepeatableTask() -> (Bool, String) {
        let date = TimeConverter.hoursDaysAndMonthToDate(startMonth: startMonth!, startDay: startDay!, startHours: startHours!)
        let task = Task(_name: name!, _description: description!, _start: date, _finish: finishTime, _category: categories, _timeCategory: timeCategory, _repeatable: repeatableTask, _dueDate: dueDate, _parent: parentID, _expectedUnitOfTime: expectedTimeRequirement.unit, _expectedTotalUnits: expectedTimeRequirement.numberOfUnits)
        if TaskDTO.globalManager.createNewTask(_task: task) {
            return (true, Constants.createTaskVC_alert_success_message)
        } else {
            return (false, Constants.createTaskVC_alert_invalid_nonrepeatable_failure_message)
        }
    }
}
