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
                self.task?.inProgress = true
                self.task?.StartTime = NSDate()
                DispatchQueue.main.async {
                    self.onItButton.alpha = Constants.alpha_solid
                }
            } else if onItState == OnItButtonState.Active {
                onItState = OnItButtonState.Finished
                self.task?.inProgress = false
                self.task?.FinishTime = NSDate()
                DispatchQueue.main.async {
                    self.onItButton.alpha = Constants.alpha_solid
                    self.onItButton.setTitle(Constants.taskTableViewCell_done, for: .normal)
                    
                }
            } else if onItState == OnItButtonState.Finished {
                self.task?.inProgress = false
                onItState = OnItButtonState.Inactive
                DispatchQueue.main.async  {
                    self.onItButton.alpha = Constants.alpha_faded
                    self.onItButton.setTitle(Constants.taskTableViewCell_onIt, for: .normal)
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
