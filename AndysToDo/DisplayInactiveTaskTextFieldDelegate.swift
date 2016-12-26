//
//  DisplayInactiveTaskTextFieldDelegate.swift
//  AndysToDo
//
//  Created by dillion on 12/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class DisplayInactiveTaskTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    // View Model
    
    var viewModel : DisplayInactiveTaskViewModel?
    
    // Delegate
    
    var viewDelegate : PickerViewViewDelegate?
    
    init(viewModel : DisplayInactiveTaskViewModel, delegate : PickerViewViewDelegate) {
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
        case _ where Constants.displayInactiveTaskVC_normal_txtfield_tags.contains(textField.tag):
            viewDelegate!.removePickerViewDoneButton()
            return true
        case _ where Constants.displayInactiveTaskVC_picker_view_txtfield_tags.contains(textField.tag):
            viewDelegate!.addPickerViewDoneButton()
            return true
        default:
            print("Invalid text field tag")
            return false
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if viewDelegate!.textFieldSelected == 0 {
            viewDelegate!.removePickerViewDoneButton()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("Should change")
        viewDelegate!.textFieldSelected = textField.tag
        switch textField.tag {
        case Constants.displayInactiveTaskVC_name_txtField_tag:
            viewModel!.name = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            return true
        case _ where Constants.displayInactiveTaskVC_picker_view_txtfield_tags.contains(textField.tag):
            return true
        default:
            print("Invalid text field tag")
            return false
        }
    }
}
