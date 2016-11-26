//
//  DisplayArchivedTaskViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/19/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private var taskHandle : UInt8 = 0

class DisplayArchivedTaskViewController : UIViewController {
    
    // View Model
    
    let viewModel = DisplayArchivedTaskViewModel()
    
    // Outlets
    
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var description_txtView: BorderedTextView!
    @IBOutlet weak var startTime_txtField: UILabel!
    @IBOutlet weak var endTime_txtField: UILabel!
    @IBOutlet weak var totalTime_txtField: UILabel!
    @IBOutlet weak var timeBudgeted_txtField: UILabel!
    
    override func viewDidLoad() {
    taskBond.bind(dynamic: viewModel.task!)
        populateTaskInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    // Binding
    
    var taskBond: Bond<Task> {
        if let b: AnyObject = objc_getAssociatedObject(self, &taskHandle) as AnyObject? {
            return b as! Bond<Task>
        } else {
            let b = Bond<Task>() { [unowned self] v in
                //print("update task in view model")
                self.populateTaskInfo()
            }
            objc_setAssociatedObject(self, &taskHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // Setup
    
    func populateTaskInfo() {
        name_lbl.text = viewModel.task?.value.Name!
        description_txtView.text = viewModel.task?.value.Description
        startTime_txtField.text = TimeConverter.dateToShortDateConverter(_time: (viewModel.task?.value.StartTime!)!)
        endTime_txtField.text = TimeConverter.dateToShortDateConverter(_time: (viewModel.task?.value.FinishTime!)!)
        let interval = viewModel.task!.value.FinishTime!.timeIntervalSince(viewModel.task!.value.StartTime! as Date)
        let componentAsString : String
        if let _ = viewModel.task?.value.expectedTimeRequirement {
            //let units : String = Constants.expectedUnitsOfTimeAsString[Constants.expectedUnitOfTime_All.index(of: viewModel.task!.value.expectedTimeRequirement!.0)!]
            let expectedTotal : String = String(viewModel.task!.value.expectedTimeRequirement!.1)
            let total : String
            switch viewModel.task!.value.expectedTimeRequirement!.0 {
                case .Day:
                    total = String(TimeConverter.convertTimeIntervalToCalendarUnits(_interval: interval, _units: .day))
                    componentAsString = "Day"
                case.Hour:
                    total = String(TimeConverter.convertTimeIntervalToCalendarUnits(_interval: interval, _units: .hour))
                    componentAsString = "Hour"
                case .Minute:
                    total = String(TimeConverter.convertTimeIntervalToCalendarUnits(_interval: interval, _units: .minute))
                    componentAsString = "Minute"
                case.Month:
                    total = String(TimeConverter.convertTimeIntervalToCalendarUnits(_interval: interval, _units: .month))
                    componentAsString = "Month"
                case .Week:
                    total = String(TimeConverter.convertTimeIntervalToCalendarUnits(_interval: interval, _units: .day) / 7)
                    componentAsString = "Week"
            case .Null:
                print("WHAT WENT HERP WRONG?")
                total = ""
                componentAsString = ""
            }
            totalTime_txtField.text = "\(total) \(componentAsString)s"
            timeBudgeted_txtField.text = "\(expectedTotal) \(componentAsString)s"
        } else {
            let component : Calendar.Component
            
            if Int(interval) > Constants.seconds_per_day {
                component = .hour
                componentAsString = "Hour"
            } else if Int(interval) > Constants.seconds_per_week {
                component = .day
                componentAsString = "Day"
            } else if Int(interval) > Constants.seconds_per_month {
                component = .month
                componentAsString = "Month"
            } else {
                component = .minute
                componentAsString = "Minute"
            }
            totalTime_txtField.text = "\(String(TimeConverter.convertTimeIntervalToCalendarUnits(_interval: interval, _units: component))) \(componentAsString)s"
        }
    }
}
