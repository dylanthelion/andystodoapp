//
//  PopulatedTasksVM.swift
//  AndysToDo
//
//  Created by dillion on 11/26/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

// View Model for Main Tasks VC

private var handle: UInt8 = 0


class PopulatedTasksViewModel : TaskFilterableViewModel {
    
    
    override init() {
        super.init()
        tasksToPopulate = Dynamic(TaskDTO.globalManager.AllTasks!.value.map({ $0 }))
        filteredTasks = Dynamic([Dynamic<Task>]())
        populateNonRepeatables()
        populateRepeatables()
        taskDTOBond.bind(dynamic: TaskDTO.globalManager.AllTasks!)
        sortDisplayedTasks(forWindow: Constants.mainTaskVC_upper_limit_calendar_unit, units: Constants.mainTaskVC_upper_limit_number_of_units)
    }
    
    // Binding
    
    var taskDTOBond: Bond<[Dynamic<Task>]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as! Bond<[Dynamic<Task>]>
        } else {
            let b = Bond<[Dynamic<Task>]>() { [unowned self] v in
                //print("Update in view model")
                self.setup()
            }
            objc_setAssociatedObject(self, &handle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // Model setup
    
    func setup() {
        tasksToPopulate.value.removeAll()
        tasksToPopulate.value.append(contentsOf: TaskDTO.globalManager.AllTasks!.value)
        populateNonRepeatables()
        populateRepeatables()
        sortDisplayedTasks(forWindow: Constants.mainTaskVC_upper_limit_calendar_unit, units: Constants.mainTaskVC_upper_limit_number_of_units)
    }
    
    // Populate tasks
    
    func populateNonRepeatables() {
        for _task in TaskDTO.globalManager.AllTasks!.value {
            if !_task.value.isRepeatable() && _tasksToPopulate!.value.index(of: _task) == nil {
                _tasksToPopulate!.value.append(_task)
            }
        }
    }
    
    func populateRepeatables() {
        let tempTasks = _tasksToPopulate
        for _task in tempTasks!.value {
            if _task.value.isRepeatable() {
                _tasksToPopulate!.value.append(contentsOf: RepeatableUnwrapper.unwrapRepeatables(_task: _task.value, toUnwrap: 3))
                _tasksToPopulate!.value.remove(at: _tasksToPopulate!.value.index(of: _task)!)
            }
        }
    }
    
    // on update
    
    override func removeDeletedTasks() {
        let tempTasks = tasksToPopulate
        for _task in tempTasks.value {
            if _task.value.parentID == nil && TaskDTO.globalManager.AllTasks!.value.index(of: _task) == nil {
                _tasksToPopulate!.value.remove(at: _tasksToPopulate!.value.index(of: _task)!)
            }
        }
    }
    
    override func addNewTasks() {
        for _task in TaskDTO.globalManager.AllTasks!.value {
            if !_task.value.isRepeatable() && _tasksToPopulate!.value.index(of: _task) == nil && _task.value.StartTime!.timeIntervalSince(Date()) <= Constants.mainTaskVC_upper_limit_time_interval && _task.value.FinishTime == nil {
                _tasksToPopulate!.value.append(_task)
            } else if _task.value.isRepeatable() && CollectionHelper.containsNoChildren(children: _tasksToPopulate!.value, ofParents: [_task]) && _task.value.FinishTime == nil  {
                if _task.value.RepeatableTask!.FirstOccurrence!.timeIntervalSince(Date()) <= Constants.mainTaskVC_upper_limit_time_interval {
                    _tasksToPopulate!.value.append(contentsOf: RepeatableUnwrapper.unwrapRepeatables(_task: _task.value, toUnwrap: 3))
                }
            }
        }
    }
}
