//
//  TimecatPickerDelegate.swift
//  AndysToDo
//
//  Created by dillion on 10/28/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class TimecatPickerDelegate : NSObject, UIPickerViewDelegate {
    
    var viewDelegate : TimecatPickerDelegateViewDelegate?
    var allTimeCategories : [TimeCategory]?
    
    convenience init(_categories : [TimeCategory]?, _delegate : TimecatPickerDelegateViewDelegate) {
        self.init()
        viewDelegate = _delegate
        allTimeCategories = _categories
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.allTimeCategories![row].name!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewDelegate?.handleDidSelect(timecat: allTimeCategories![row], name: allTimeCategories![row].name!)
    }
}
