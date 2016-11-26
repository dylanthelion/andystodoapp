//
//  TaskTableViewCell.swift
//  AndysToDo
//
//  Created by dillion on 10/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private var handle: UInt8 = 0

class TaskTableViewCell : UITableViewCell {
    
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
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var onItButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
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
            let update = TaskDTO.globalManager.updateTask(_task: task!)
        }
    }
    
}

enum OnItButtonState {
    case Inactive
    case Active
    case Finished
}
