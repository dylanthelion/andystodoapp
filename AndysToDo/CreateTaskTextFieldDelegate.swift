//
//  CreateTaskTextFieldDelegate.swift
//  AndysToDo
//
//  Created by dillion on 12/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateTaskTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    // View Model
    
    var viewModel : TaskCRUDViewModel?
    
    // Delegate
    
    var viewDelegate : PickerViewViewDelegate?
    
    init(viewModel : TaskCRUDViewModel, delegate : PickerViewViewDelegate) {
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
        case 0,4:
            viewDelegate!.removePickerViewDoneButton()
            return true
        case 1,2,3,5:
            viewDelegate!.addPickerViewDoneButton()
            return true
        default:
            print("Invalid text field tag")
            return false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        viewDelegate!.textFieldSelected = textField.tag
        switch textField.tag {
        case 0:
            viewModel?.name = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            return true
        case 1,2,3,5:
            return true
        case 4:
            if let check = Int((textField.text! as NSString).replacingCharacters(in: range, with: string)) {
                viewModel?.expectedTimeRequirement.update(newUnitOfTime: nil, newValue: check)
            } else {
                viewModel?.expectedTimeRequirement.update(newUnitOfTime: nil, newValue: 0)
            }
            return true
        default:
            print("Invalid text field tag")
            return false
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if [0,4].contains(viewDelegate!.textFieldSelected) {
            viewDelegate!.removePickerViewDoneButton()
        }
        return true
    }
}
