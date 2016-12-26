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
        self.timecatDTOBond.bind(dynamic: TimeCategoryDTO.shared.allTimeCategories!)
        self.taskDTOBond.bind(dynamic: TaskDTO.globalManager.allTasks!)
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
                //print("Update task in view model")
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
        if !NumberHelper.isNilOrZero(task?.value.timeOnTask) && task!.value.inProgress {
            let timeToAdd : TimeInterval = Date().timeIntervalSince(task!.value.startTime! as Date)
            task!.value.timeOnTask! += timeToAdd
        }
        task!.value.startTime! = task!.value.startTime!.addingTimeInterval(TimeInterval(Constants.seconds_per_day))
        task!.value.inProgress = false
        if TaskDTO.globalManager.updateTask(task!.value) {
            return true
        }
        return false
    }
    
    // Validation
    
    func validateNonRepeatableTask() -> (Bool, String) {
        let date = TimeConverter.hoursDaysAndMonthToDate(startMonth: startMonth!, startDay: startDay!, startHours: startHours!)
        //print(date)
        let newTask = Task(name: name!, description: description!, start: date, finish: finishTime, category: categories, timeCategory: timeCategory, repeatable: nil, dueDate: dueDate, parent: task?.value.parentID, expectedUnitOfTime: expectedTimeRequirement.unit, expectedTotalUnits: expectedTimeRequirement.numberOfUnits)
        newTask.ID = task!.value.ID
        if TaskDTO.globalManager.updateTask(newTask) {
            return (true, Constants.createTaskVC_alert_success_message)
        } else {
            return (false, Constants.createTaskVC_alert_invalid_nonrepeatable_failure_message)
        }
    }
}
