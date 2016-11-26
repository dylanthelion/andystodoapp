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

class DisplayInactiveTaskViewModel : TaskCRUDViewModel {
    
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
        }
        return false
    }
    
    // Validation
    
    func validateNonRepeatableTask() -> (Bool, String) {
        let date = TimeConverter.hoursDaysAndMonthToDate(startMonth: startMonth!, startDay: startDay!, startHours: startHours!)
        //print(date)
        let newTask = Task(_name: name!, _description: description!, _start: date, _finish: finishTime, _category: categories, _timeCategory: timeCategory, _repeatable: nil, _dueDate: dueDate, _parent: task?.value.parentID, _expectedUnitOfTime: expectedTimeRequirement.unit, _expectedTotalUnits: expectedTimeRequirement.numberOfUnits)
        newTask.ID = task?.value.ID
        if TaskDTO.globalManager.updateTask(_task: newTask) {
            return (true, Constants.createTaskVC_alert_success_message)
        } else {
            return (false, Constants.createTaskVC_alert_invalid_nonrepeatable_failure_message)
        }
    }
}
