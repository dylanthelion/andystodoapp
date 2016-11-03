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
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    // TaskDTODelegate
    
    func handleModelUpdate() {
        
    }
    
    func taskDidUpdate(_task: Task) {
        
    }
    
    // Timer
    
    func updateTimer() {
        let elapsedTime = Date().timeIntervalSince(task!.StartTime! as Date)
        let hours = String(format: "%02d", Int(elapsedTime) / 60)
        let minutes = String(format: "%02d", Int(elapsedTime) % 60)
        timer_lbl.text = "\(hours):\(minutes)"
    }
    
    // IBActions
    
    @IBAction func pause(_ sender: AnyObject) {
    }
    
    @IBAction func endTask(_ sender: AnyObject) {
    }
    
    @IBAction func goToEdit(_ sender: AnyObject) {
    }
}
