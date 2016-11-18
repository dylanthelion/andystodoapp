//
//  DatePickerDataSource.swift
//  AndysToDo
//
//  Created by dillion on 10/26/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class DatePickerDataSource : NSObject, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return Constants.months_per_year
        case 1:
            return Constants.days_per_month
        default:
            print("Something went wrong with date picker view data source")
            return 0
        }
    }
}
