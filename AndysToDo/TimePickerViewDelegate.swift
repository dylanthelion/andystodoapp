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
    let hours : [Int] = [1,2,3,4,5,6,7,8,9,10,11,12]
    let minutes : [Int] = [00,05,10,15,20,25,30,35,40,45,50,55]
    let meridians : [String] = ["AM", "PM"]
    
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
        let hours : String = String(self.hours[pickerView.selectedRow(inComponent: 0)])
        let minutes : String = String(format: "%02d", self.minutes[pickerView.selectedRow(inComponent: 1)])
        let meridian : String = meridians[pickerView.selectedRow(inComponent: 2)]
        viewDelegate?.handleDidSelect(hours: hours, minutes: minutes, meridian: meridian, fullTime: "\(hours):\(minutes) \(meridian)")
    }
    
}

protocol TimePickerViewDelegateViewDelegate {
    
    func handleDidSelect(hours : String, minutes : String, meridian : String, fullTime : String)
}
