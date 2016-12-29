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

class AllTasksIndividualTaskViewModel : TaskCRUDViewModel {
    
    
    override init() {
        super.init()
        self.timecatDTOBond.bind(dynamic: TimeCategoryDTO.shared.allTimeCategories!)
        self.taskDTOBond.bind(dynamic: TaskDTO.globalManager.allTasks!)
        allTimeCategories = Dynamic(TimeCategoryDTO.shared.allTimeCategories!.value.map({ $0.value }))
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
        let date = TimeConverter.hoursDaysAndMonthToDate(startMonth: startMonth!, startDay: startDay!, startHours: startHours!)
        //print(date)
        let newTask = Task(name: name!, description: description!, start: date, finish: nil, category: categories, timeCategory: timeCategory, repeatable: nil, dueDate: nil, parent: nil, expectedUnitOfTime: expectedTimeRequirement.unit, expectedTotalUnits: expectedTimeRequirement.numberOfUnits)
        newTask.ID = task!.value.ID!
        if TaskDTO.globalManager.updateTask(newTask) {
            return true
        } else {
            return false
        }
    }
    
    func validateNonRepeatableTask() -> Bool {
        let date = TimeConverter.hoursDaysAndMonthToDate(startMonth: startMonth!, startDay: startDay!, startHours: startHours!)
        //print(date)
        let newTask = Task(name: name!, description: description!, start: date, finish: nil, category: categories, timeCategory: timeCategory, repeatable: nil, dueDate: nil, parent: nil, expectedUnitOfTime: expectedTimeRequirement.unit, expectedTotalUnits: expectedTimeRequirement.numberOfUnits)
        newTask.ID = task!.value.ID!
        if TaskDTO.globalManager.updateTask(newTask) {
            return true
        } else {
            return false
        }
    }
    
    func validateNewInstance() -> Bool {
        let date = TimeConverter.hoursDaysAndMonthToDate(startMonth: startMonth!, startDay: startDay!, startHours: startHours!)
        //print(date)
        let newTask = Task(name: "Temp \(name!)", description: description!, start: date, finish: nil, category: categories, timeCategory: timeCategory, repeatable: nil, dueDate: nil, parent: nil, expectedUnitOfTime: expectedTimeRequirement.unit, expectedTotalUnits: expectedTimeRequirement.numberOfUnits)
        if TaskDTO.globalManager.createNewTask(newTask) {
            return true
        } else {
            return false
        }
    }
    
    func validateNewRepeatableInstance() -> Bool {
        let date = TimeConverter.hoursDaysAndMonthToDate(startMonth: startMonth!, startDay: startDay!, startHours: startHours!)
        print(date)
        let newTask = Task(name: "Temp \(name!) instance", description: description!, start: date, finish: nil, category: categories, timeCategory: timeCategory, repeatable: nil, dueDate: nil, parent: self.task!.value.ID!, expectedUnitOfTime: expectedTimeRequirement.unit, expectedTotalUnits: expectedTimeRequirement.numberOfUnits)
        if TaskDTO.globalManager.createNewTempRepeatableTask(newTask) {
            return true
        } else {
            return false
        }
    }
}
