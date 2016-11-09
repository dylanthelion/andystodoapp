//
//  DisplayActiveTaskViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/2/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class DisplayActiveTaskViewController : UIViewController, TaskDTODelegate {
    
    // Model values
    
    let taskDTO = TaskDTO.globalManager
    var task : Task?
    var timer : Timer?
    
    // Outlets
    
    @IBOutlet weak var startTime_lbl: UILabel!
    @IBOutlet weak var timer_lbl: UILabel!
    @IBOutlet weak var description_txtView: UITextView!
    
    override func viewDidLoad() {
        populateLabels()
        setupTimer()
        if let _ = task?.TimeCategory?.color {
            self.view.backgroundColor = UIColor(cgColor: task!.TimeCategory!.color!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taskDTO.delegate = self
        if !task!.inProgress {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        taskDTO.delegate = nil
    }
    
    // UI setup
    
    func populateLabels() {
        if let _ = task?.StartTime {
            startTime_lbl.text = TimeConverter.dateToTimeConverter(_time: task!.StartTime!)
        }
        
        if let _ = task?.Description {
            description_txtView.text = task!.Description!
        }
    }
    
    func setupTimer() {
        if (task?.inProgress)! {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
        }
        
    }
    
    // TaskDTODelegate
    
    func handleModelUpdate() {
        
    }
    
    func taskDidUpdate(_task: Task) {
        
    }
    
    // Timer
    
    func updateTimer() {
        var elapsedTime = Date().timeIntervalSince(task!.StartTime! as Date)
        if let check = task?.timeOnTask {
            elapsedTime += check
        }
        let hours = String(format: "%02d", Int(elapsedTime) / Int(Constants.seconds_per_minute))
        let minutes = String(format: "%02d", Int(elapsedTime) % Int(Constants.seconds_per_minute))
        timer_lbl.text = "\(hours):\(minutes)"
    }
    
    // IBActions
    
    @IBAction func pause(_ sender: AnyObject) {
        if (task?.inProgress)! {
            let timeToAdd : TimeInterval = Date().timeIntervalSince(task?.StartTime! as! Date)
            if let _ = task?.timeOnTask {
                task?.timeOnTask! += timeToAdd
            } else {
                task?.timeOnTask = timeToAdd
            }
            task?.StartTime = Date() as NSDate?
            task?.inProgress = false
            if !taskDTO.updateTask(_task: task!) {
                //alertOfError()
            }
        } else {
            task?.inProgress = true
            task?.StartTime = Date() as NSDate?
            if !taskDTO.updateTask(_task: task!) {
                //alertOfError()
            }
        }
        setupTimer()
    }
    
    @IBAction func endTask(_ sender: AnyObject) {
        
        if task!.inProgress {
            let timeToAdd : TimeInterval = Date().timeIntervalSince(task?.StartTime! as! Date)
            if let _ = task?.timeOnTask {
                task?.timeOnTask! += timeToAdd
            } else {
                task?.timeOnTask = timeToAdd
            }
        }
        task?.FinishTime = Date() as NSDate?
        task?.inProgress = false
        if !taskDTO.updateTask(_task: task!) {
            //alertOfError()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func goToEdit(_ sender: AnyObject) {
        let displayInactiveTaskVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_inactiveTask_VC_id) as! DisplayInactiveTaskViewController
        displayInactiveTaskVC.task = task
        self.navigationController?.pushViewController(displayInactiveTaskVC, animated: true)
    }
    
    // Temporary error alert
    
    /*func alertOfError() {
        let alertController = UIAlertController(title: Constants.standard_alert_fail_title, message: "Something went wrong", preferredStyle: .alert)
        alertController.addAction(Constants.standard_ok_alert_action)
        self.present(alertController, animated: true, completion: nil)
    }*/
}
