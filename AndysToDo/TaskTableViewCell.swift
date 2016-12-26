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
            if let _ = task!.finishTime {
                return .Finished
            }
            return .Inactive
        }
    }
    
    // Outlets
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var onItButton: UIButton!
    
    func setTask(_ task : Task) {
        if task.isValid() {
            self.task = task
        }
    }
    
    @IBAction func ToggleOnItStatus(_ sender: AnyObject) {
        if let _ = task {
            if (onItState == OnItButtonState.Inactive) {
                self.task?.inProgress = true
                self.task?.startTime = NSDate()
            } else if onItState == OnItButtonState.Active {
                self.task?.inProgress = false
                self.task?.finishTime = NSDate()
            } else if onItState == OnItButtonState.Finished {
                self.task?.inProgress = false
                self.task?.finishTime = nil
            }
            _ = TaskDTO.globalManager.updateTask(task!)
        }
    }
    
}
