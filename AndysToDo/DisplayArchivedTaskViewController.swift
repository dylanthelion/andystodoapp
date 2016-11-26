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
        if let _ = viewModel.task?.value.expectedTimeRequirement.numberOfUnits {
            setTimeOnTaskWithBudget()
        } else {
            setTimeOnTaskWithoutBudget()
        }
    }
    
    func setTimeOnTaskWithBudget() {
        let interval = viewModel.task!.value.FinishTime!.timeIntervalSince(viewModel.task!.value.StartTime! as Date)
        let expectedTotal : String = String(viewModel.task!.value.expectedTimeRequirement.numberOfUnits!)
        let total : String
        let componentAsString = Constants.expectedUnitsOfTimeAsString[Constants.expectedUnitOfTime_All.index(of: viewModel.task!.value.expectedTimeRequirement._unit)!]
        switch viewModel.task!.value.expectedTimeRequirement.unit! {
        case .Day:
            total = String(TimeConverter.convertTimeIntervalToCalendarUnits(_interval: interval, _units: .day))
        case.Hour:
            total = String(TimeConverter.convertTimeIntervalToCalendarUnits(_interval: interval, _units: .hour))
        case .Minute:
            total = String(TimeConverter.convertTimeIntervalToCalendarUnits(_interval: interval, _units: .minute))
        case.Month:
            total = String(TimeConverter.convertTimeIntervalToCalendarUnits(_interval: interval, _units: .month))
        case .Week:
            total = String(TimeConverter.convertTimeIntervalToCalendarUnits(_interval: interval, _units: .day) / 7)
        case .Null:
            print("WHAT WENT HERP WRONG?")
            total = ""
        }
        totalTime_txtField.text = "\(total) \(componentAsString)"
        timeBudgeted_txtField.text = "\(expectedTotal) \(componentAsString)"
    }
    
    func setTimeOnTaskWithoutBudget() {
        let interval = viewModel.task!.value.FinishTime!.timeIntervalSince(viewModel.task!.value.StartTime! as Date)
        let component : Calendar.Component
        let componentAsString : String
        if Int(interval) > Constants.seconds_per_day {
            component = .hour
            componentAsString = Constants.displayArchivedTaskVC_hour
        } else if Int(interval) > Constants.seconds_per_week {
            component = .day
            componentAsString = Constants.displayArchivedTaskVC_day
        } else if Int(interval) > Constants.seconds_per_month {
            component = .month
            componentAsString = Constants.displayArchivedTaskVC_month
        } else {
            component = .minute
            componentAsString = Constants.displayArchivedTaskVC_minute
        }
        totalTime_txtField.text = "\(String(TimeConverter.convertTimeIntervalToCalendarUnits(_interval: interval, _units: component))) \(componentAsString)s"
    }
}
