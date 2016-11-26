//
//  DisplayActiveTaskViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/7/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

private var taskHandle : UInt8 = 0

class DisplayActiveTaskViewModel : SingleTaskViewModel {
    
    override init() {
        super.init()
        taskDTOBond.bind(dynamic: TaskDTO.globalManager.AllTasks!)
    }
    
    // Binding
    
    var taskDTOBond: Bond<[Dynamic<Task>]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &taskHandle) as AnyObject? {
            return b as! Bond<[Dynamic<Task>]>
        } else {
            let b = Bond<[Dynamic<Task>]>() { [unowned self] v in
                //print("Update in view model")
                self.updateTask()
            }
            objc_setAssociatedObject(self, &taskHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // Timer
    
    func updateTimer() -> String {
        var elapsedTime = Date().timeIntervalSince(task!.value.StartTime! as Date)
        if let check = task?.value.timeOnTask {
            elapsedTime += check
        }
        let hours = String(format: "%02d", Int(elapsedTime) / Int(Constants.seconds_per_minute))
        let minutes = String(format: "%02d", Int(elapsedTime) % Int(Constants.seconds_per_minute))
        return "\(hours):\(minutes)"
    }
    
    func pause() -> Bool {
        if (task?.value.inProgress)! {
            let timeToAdd : TimeInterval = Date().timeIntervalSince(task?.value.StartTime! as! Date)
            if let _ = task?.value.timeOnTask {
                task?.value.timeOnTask! += timeToAdd
            } else {
                task?.value.timeOnTask = timeToAdd
            }
            task?.value.StartTime = Date() as NSDate?
            task?.value.inProgress = false
            return TaskDTO.globalManager.updateTask(_task: task!.value)
        } else {
            task?.value.inProgress = true
            task?.value.StartTime = Date() as NSDate?
            return TaskDTO.globalManager.updateTask(_task: task!.value)
        }
        
    }
    
    func endTask() -> Bool {
        if task!.value.inProgress {
            let timeToAdd : TimeInterval = Date().timeIntervalSince(task?.value.StartTime! as! Date)
            if let _ = task?.value.timeOnTask {
                task?.value.timeOnTask! += timeToAdd
            } else {
                task?.value.timeOnTask = timeToAdd
            }
        }
        task?.value.FinishTime = Date() as NSDate?
        task?.value.inProgress = false
        if !TaskDTO.globalManager.updateTask(_task: task!.value) {
            return false
        } else {
            return true
        }
    }
}
