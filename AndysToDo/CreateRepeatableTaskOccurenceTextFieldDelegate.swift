//
//  CreateRepeatableTaskOccurenceTextFieldDelegate.swift
//  AndysToDo
//
//  Created by dillion on 12/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateRepeatableTaskOccurenceTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    // View Model
    
    var viewModel : CreateRepeatableTaskOccurrenceViewModel?
    
    // Delegate
    
    var viewDelegate : PickerViewViewDelegate?
    
    init(viewModel : CreateRepeatableTaskOccurrenceViewModel, delegate : PickerViewViewDelegate) {
        self.viewModel = viewModel
        viewDelegate = delegate
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        viewDelegate!.textFieldSelected = textField.tag
        switch textField.tag {
        case 0,2,3,4:
            viewDelegate!.addPickerViewDoneButton()
            return true
        case 1:
            viewDelegate!.removePickerViewDoneButton()
            return true
        default:
            print("Invalid text field tag")
            return false
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if viewDelegate!.textFieldSelected == 1 {
            viewDelegate!.removePickerViewDoneButton()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        viewDelegate!.textFieldSelected = textField.tag
        switch textField.tag {
        case 0,2,3,4,5:
            return true
        case 1:
            if let check = Int((textField.text! as NSString).replacingCharacters(in: range, with: string)) {
                viewModel!.numberOfUnits = check
            } else {
                viewModel!.numberOfUnits = 0
            }
            return true
        default:
            print("Invalid text field tag")
            return false
        }
    }
}
