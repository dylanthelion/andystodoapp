//
//  TaskTableViewCell.swift
//  AndysToDo
//
//  Created by dillion on 10/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class TaskTableViewCell : UITableViewCell {
    
    // Model values
    
    var task : Task?
    var onItState : OnItButtonState  {
        get {
            if task == nil {
                return .Inactive
            }
            if task!.inProgress {
                return .Active
            }
            if let _ = task!.FinishTime {
                return .Finished
            }
            return .Inactive
        }
    }
    
    // Outlets
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var onItButton: UIButton!
    
    func setTask(_task : Task) {
        if _task.isValid() {
            task = _task
        }
    }
    
    @IBAction func ToggleOnItStatus(_ sender: AnyObject) {
        if let _ = task {
            if (onItState == OnItButtonState.Inactive) {
                self.task?.inProgress = true
                self.task?.StartTime = NSDate()
            } else if onItState == OnItButtonState.Active {
                self.task?.inProgress = false
                self.task?.FinishTime = NSDate()
            } else if onItState == OnItButtonState.Finished {
                self.task?.inProgress = false
                self.task?.FinishTime = nil
            }
            _ = TaskDTO.globalManager.updateTask(_task: task!)
        }
    }
    
}
