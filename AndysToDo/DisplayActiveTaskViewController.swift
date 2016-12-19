//
//  DisplayActiveTaskViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/2/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private var taskHandle : UInt8 = 0

class DisplayActiveTaskViewController : UIViewController {
    
    // UI
    
    var timer : Timer?
    
    // ViewModel
    
    let viewModel = DisplayActiveTaskViewModel()
    
    // Outlets
    
    @IBOutlet weak var startTime_lbl: UILabel!
    @IBOutlet weak var timer_lbl: UILabel!
    @IBOutlet weak var description_txtView: BorderedTextView!
    
    override func viewDidLoad() {
        modelBond.bind(dynamic: viewModel.task!)
        checkTask()
        populateLabels()
        setupTimer()
    }
    
    // Binding
    
    var modelBond: Bond<Task> {
        if let b: AnyObject = objc_getAssociatedObject(self, &taskHandle) as AnyObject? {
            return b as! Bond<Task>
        } else {
            let b = Bond<Task>() { [unowned self] v in
                DispatchQueue.main.async {
                    self.checkTask()
                    self.populateLabels()
                    self.timer?.invalidate()
                    self.setupTimer()
                }
            }
            objc_setAssociatedObject(self, &taskHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // UI setup
    
    func populateLabels() {
        if let _ = viewModel.task?.value.StartTime {
            startTime_lbl.text = TimeConverter.dateToTimeConverter(_time: viewModel.task!.value.StartTime!)
        }
        
        if let _ = viewModel.task?.value.Description {
            description_txtView.text = viewModel.task!.value.Description!
        }
    }
    
    func setupTimer() {
        if (viewModel.task?.value.inProgress)! {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
        }
    }
    
    func checkTask() {
        if let _ = viewModel.task?.value.TimeCategory?.color {
            self.view.backgroundColor = UIColor(cgColor: viewModel.task!.value.TimeCategory!.color!)
        }
        if !viewModel.task!.value.inProgress {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    // Timer
    
    func updateTimer() {
        timer_lbl.text = viewModel.updateTimer()
    }
    
    // IBActions
    
    @IBAction func pause(_ sender: AnyObject) {
        if viewModel.pause() {
            setupTimer()
        } else {
            timer?.invalidate()
        }
    }
    
    @IBAction func endTask(_ sender: AnyObject) {
        if viewModel.endTask() {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func goToEdit(_ sender: AnyObject) {
        let displayInactiveTaskVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_inactiveTask_VC_id) as! DisplayInactiveTaskViewController
        displayInactiveTaskVC.viewModel!.setTask(newTask: viewModel.task!.value)
        self.navigationController?.pushViewController(displayInactiveTaskVC, animated: true)
    }
}
