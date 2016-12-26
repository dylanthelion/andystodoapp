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
        case _ where Constants.createTaskVC_normal_txtfield_tags.contains(textField.tag):
            viewDelegate!.removePickerViewDoneButton()
            return true
        case _ where Constants.createTaskVC_picker_view_txtfield_tags.contains(textField.tag):
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
        case Constants.createTaskVC_name_txtfield_tag:
            viewModel?.name = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            return true
        case _ where Constants.createTaskVC_picker_view_txtfield_tags.contains(textField.tag):
            return true
        case Constants.createTaskVC_unitsOfTime_txtfield_tag:
            if let check = Int((textField.text! as NSString).replacingCharacters(in: range, with: string)) {
                viewModel?.expectedTimeRequirement.update(nil, check)
            } else {
                viewModel?.expectedTimeRequirement.update(nil, 0)
            }
            return true
        default:
            print("Invalid text field tag")
            return false
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if Constants.createTaskVC_normal_txtfield_tags.contains(viewDelegate!.textFieldSelected) {
            viewDelegate!.removePickerViewDoneButton()
        }
        return true
    }
}
