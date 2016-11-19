//
//  DisplayArchivedTaskViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/19/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class DisplayArchivedTaskViewController : UIViewController {
    
    var task : Task?
    
    // Outlets
    
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var description_txtView: BorderedTextView!
    @IBOutlet weak var startTime_txtField: UILabel!
    @IBOutlet weak var endTime_txtField: UILabel!
    @IBOutlet weak var totalTime_txtField: UILabel!
    @IBOutlet weak var timeBudgeted_txtField: UILabel!
    
    override func viewDidLoad() {
        populateTaskInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    // Setup
    
    func populateTaskInfo() {
        if task == nil {
            print("No task")
            return
        }
        name_lbl.text = task?.Name!
        description_txtView.text = task?.Description
        startTime_txtField.text = TimeConverter.dateToShortDateConverter(_time: (task?.StartTime!)!)
        endTime_txtField.text = TimeConverter.dateToShortDateConverter(_time: (task?.FinishTime!)!)
        let interval = task!.FinishTime!.timeIntervalSince(task!.StartTime! as Date)
        let componentAsString : String
        if let _ = task?.expectedTimeRequirement {
            let units : String = Constants.expectedUnitsOfTimeAsString[Constants.expectedUnitOfTime_All.index(of: task!.expectedTimeRequirement!.0)!]
            let expectedTotal : String = String(task!.expectedTimeRequirement!.1)
            let total : String
            switch task!.expectedTimeRequirement!.0 {
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
