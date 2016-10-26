//
//  DatePickerViewDelegate.swift
//  AndysToDo
//
//  Created by dillion on 10/26/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class DatePickerViewDelegate : NSObject, UIPickerViewDelegate {
    
    var viewDelegate : DatePickerViewDelegateViewDelegate?
    
    let months = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"]
    let days = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
    
    convenience init(_delegate : DatePickerViewDelegateViewDelegate) {
        self.init()
        viewDelegate = _delegate
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            return months[row]
        case 1:
            return days[row]
        default:
            print("Something went wrong with date title for row")
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewDelegate?.handleDidSelect(months: months[pickerView.selectedRow(inComponent: 0)].substring(to: months[pickerView.selectedRow(inComponent: 0)].index(months[pickerView.selectedRow(inComponent: 0)].startIndex, offsetBy: 3)), days: days[pickerView.selectedRow(inComponent: 1)], fulldate: "\(months[pickerView.selectedRow(inComponent: 0)]) \(days[pickerView.selectedRow(inComponent: 1)])")
    }
}

protocol  DatePickerViewDelegateViewDelegate {
    
    func handleDidSelect(months : String, days: String, fulldate : String)
}
