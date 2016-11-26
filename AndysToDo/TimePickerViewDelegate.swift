//
//  TimePickerViewDelegate.swift
//  AndysToDo
//
//  Created by dillion on 10/26/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class TimePickerViewDelegate : NSObject, UIPickerViewDelegate {
    
    var viewDelegate : TimePickerViewDelegateViewDelegate?
    let hours : [Int] = Constants.all_hours_as_ints
    let minutes : [Int] = Constants.picker_all_minutes_as_ints
    let meridians : [String] = [Constants.meridian_am, Constants.meridian_pm]
    
    convenience init(_delegate : TimePickerViewDelegateViewDelegate) {
        self.init()
        viewDelegate = _delegate
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(hours[row])
        case 1:
            return String(format: "%02d", minutes[row])
        case 2:
            return meridians[row]
        default:
            print("Problem with pickerView titleForRow")
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewDelegate?.handleDidSelect(hours: String(self.hours[pickerView.selectedRow(inComponent: 0)]), minutes: String(format: "%02d", self.minutes[pickerView.selectedRow(inComponent: 1)]), meridian: meridians[pickerView.selectedRow(inComponent: 2)], fullTime: "\(self.hours[pickerView.selectedRow(inComponent: 0)]):\(String(format: "%02d", self.minutes[pickerView.selectedRow(inComponent: 1)])) \(meridians[pickerView.selectedRow(inComponent: 2)])")
    }
    
}

protocol TimePickerViewDelegateViewDelegate {
    
    func handleDidSelect(hours : String, minutes : String, meridian : String, fullTime : String)
}
