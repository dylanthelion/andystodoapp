//
//  ExpectedUnitOfTimePickerDelegate.swift
//  AndysToDo
//
//  Created by dillion on 11/18/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class ExpectedUnitOfTimePickerDelegate : NSObject, UIPickerViewDelegate {
    
    var viewDelegate : ExpectedUnitOfTimePickerDelegateViewDelegate?
    
    convenience init(_delegate : ExpectedUnitOfTimePickerDelegateViewDelegate) {
        self.init()
        viewDelegate = _delegate
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.expectedUnitsOfTimeAsString[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewDelegate?.handleDidSelect(unit: Constants.expectedUnitOfTime_All[row], text: Constants.expectedUnitsOfTimeAsString[row])
        
    }
}
