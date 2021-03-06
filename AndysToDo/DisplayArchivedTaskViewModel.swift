//
//  DisplayArchivedTaskViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/9/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

private var taskHandle : UInt8 = 0

class DisplayArchivedTaskViewModel {
    
    var task : Dynamic<Task>?
    
    init() {
        self.taskDTOBond.bind(dynamic: TaskDTO.globalManager.allTasks!)
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
    
    // Update
    
    func setTask(_ newTask: Task) {
        if task == nil {
            task = Dynamic(newTask)
        } else {
            task!.value = newTask
        }
    }
    
    func updateTask() {
        if task == nil {
            return
        }
        for t in ArchivedTaskDTO.shared.allTasks!.value {
            if t.value == task?.value {
                setTask(t.value)
                break
            }
        }
    }
}
