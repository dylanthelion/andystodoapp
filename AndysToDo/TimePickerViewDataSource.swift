//
//  TimePickerViewDataSource.swift
//  AndysToDo
//
//  Created by dillion on 10/28/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class TimePickerViewDataSource : NSObject, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return Int(Constants.hours_per_meridian)
        case 1:
            return Constants.picker_minutes_per_hour
        case 2:
            return Constants.total_meridians
        default:
            print("Something went wrong picker view number of rows")
            return 0
        }
    }
}
