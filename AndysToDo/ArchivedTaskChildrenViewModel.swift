//
//  ArchivedTaskChildrenViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/9/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

private var taskHandle : UInt8 = 0

class ArchivedTaskChildrenViewModel {
    
    var tasksToPopulate : Dynamic<[Dynamic<Task>]>?
    var emptied = false
    
    // Binding
    
    init() {
        self.taskDTOBond.bind(dynamic: TaskDTO.globalManager.archivedTasks!)
    }
    
    var taskDTOBond: Bond<[Dynamic<Task>]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &taskHandle) as AnyObject? {
            return b as! Bond<[Dynamic<Task>]>
        } else {
            let b = Bond<[Dynamic<Task>]>() { [unowned self] v in
                //print("Update in view model")
                self.setup()
            }
            objc_setAssociatedObject(self, &taskHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // Model setup
    
    func setTasks(tasks : [Dynamic<Task>]) {
        if tasksToPopulate == nil {
            tasksToPopulate = Dynamic([Dynamic<Task>]())
        }
        tasksToPopulate!.value.removeAll()
        tasksToPopulate!.value.append(contentsOf: tasks)
        sortDisplayedTasks()
    }
    
    func setup() {
        var tasksToRemove = [Dynamic<Task>]()
        for task in tasksToPopulate!.value {
            if TaskDTO.globalManager.archivedTasks!.value.index(of: task) == nil {
                tasksToRemove.append(task)
            }
        }
        if tasksToRemove.count == tasksToPopulate!.value.count {
            emptied = true
            tasksToPopulate!.value.removeAll()
            return
        }
        for task in tasksToRemove {
            tasksToPopulate!.value.remove(at: tasksToPopulate!.value.index(of: task)!)
        }
        sortDisplayedTasks()
    }
    
    func sortDisplayedTasks() {
        tasksToPopulate!.value.sort(by: {
            return ($0.value.StartTime! as Date) < ($1.value.StartTime! as Date)
        })
    }
}
