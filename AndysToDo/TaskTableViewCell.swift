//
//  TaskTableViewCell.swift
//  AndysToDo
//
//  Created by dillion on 10/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class TaskTableViewCell : UITableViewCell {
    
    var task : Task?
    weak var delegate : MainTasksViewController?
    var onItState : OnItButtonState = OnItButtonState.Inactive
    
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
                onItState = OnItButtonState.Active
                if (self.task!.StartTime == nil) {
                    self.task?.StartTime = NSDate()
                }
                //print("Starting task at \(self.task!.StartTime!.description)")
                DispatchQueue.main.async {
                    self.onItButton.alpha = 1.0
                }
            } else if onItState == OnItButtonState.Active {
                onItState = OnItButtonState.Finished
                self.task?.FinishTime = NSDate()
                //print("Finishing task at \(self.task!.FinishTime!.description)")
                DispatchQueue.main.async {
                    self.onItButton.alpha = 1.0
                    self.onItButton.titleLabel?.text = "DONE"
                    
                }
            } else if onItState == OnItButtonState.Finished {
                
                onItState = OnItButtonState.Inactive
                DispatchQueue.main.async {
                    self.onItButton.alpha = 0.3
                    self.onItButton.titleLabel?.text = "ON IT!"
                }
            }
            if let _ = delegate {
                delegate!.taskDidUpdate(_task: self.task!)
            }
        }
    }
}

enum OnItButtonState {
    case Inactive
    case Active
    case Finished
}
