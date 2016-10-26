//
//  DayOfWeekPickerDelegate.swift
//  AndysToDo
//
//  Created by dillion on 10/28/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class DayOfWeekPickerDelegate : NSObject, UIPickerViewDelegate {
    
    let days  = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    let daysOfWeek : [DayOfWeek] = [.Sunday, .Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday]
    
    var viewDelegate : DayOfWeekPickerDelegateViewDelegate?
    
    convenience init(_delegate : DayOfWeekPickerDelegateViewDelegate) {
        self.init()
        viewDelegate = _delegate
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return days[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewDelegate?.handleDidSelect(day: days[row], enumValue: daysOfWeek[row])
    }
}

protocol DayOfWeekPickerDelegateViewDelegate {
    func handleDidSelect(day : String, enumValue : DayOfWeek)
}
