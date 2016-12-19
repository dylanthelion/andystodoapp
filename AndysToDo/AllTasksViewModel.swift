//
//  AllTasksViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/8/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

private var handle: UInt8 = 0


class AllTasksViewModel : TaskFilterableViewModel {
    
    override init() {
        super.init()
        self.tasksToPopulate = Dynamic(TaskDTO.globalManager.AllTasks!.value.map({ $0 }))
        filteredTasks = Dynamic([Dynamic<Task>]())
        localTasks = Dynamic(TaskDTO.globalManager.AllTasks!.value.map({ $0 }))
        localFilteredTasks = Dynamic([Dynamic<Task>]())
        self.taskDTOBond.bind(dynamic: TaskDTO.globalManager.AllTasks!)
        sortDisplayedTasks()
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
        localTasks!.value.removeAll()
        localTasks!.value.append(contentsOf: TaskDTO.globalManager.AllTasks!.value)
        sortDisplayedTasks()
    }
    
    // Table view actions
    
    func moveTaskToDayPlanner(index : Int) {
        let _task = localTasks!.value[index].value
        _task.inProgress = true
        _task.StartTime = NSDate()
        if TaskDTO.globalManager.updateTask(_task: _task) {
            // handle success
        }
    }
    
    // on update
    
    override func removeDeletedTasks() {
        let tempTasks = localTasks!
        for _task in tempTasks.value {
            if _task.value.parentID == nil && TaskDTO.globalManager.AllTasks!.value.index(of: _task) == nil {
                localTasks!.value.remove(at: localTasks!.value.index(of: _task)!)
            }
        }
    }
    
    override func addNewTasks() {
        for _task in TaskDTO.globalManager.AllTasks!.value {
            if localTasks!.value.index(of: _task) == nil {
                localTasks!.value.append(_task)
            }
        }
    }
}
