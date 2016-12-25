//
//  UnitOfTimePickerDelegate.swift
//  AndysToDo
//
//  Created by dillion on 10/28/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class UnitOfTimePickerDelegate : NSObject, UIPickerViewDelegate {
    
    let unitsOfTime = Constants.timeOfDay_All_As_Strings
    var viewDelegate : UnitOfTimePickerDelegateViewDelegate?
    
    convenience init(_delegate : UnitOfTimePickerDelegateViewDelegate) {
        self.init()
        viewDelegate = _delegate
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return unitsOfTime[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewDelegate?.handleDidSelect(unit: unitsOfTime[row])
        
    }
    
}


