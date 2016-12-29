//
//  CreateTimecatTextFieldDelegate.swift
//  AndysToDo
//
//  Created by dillion on 12/15/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateTimecatTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    // View Model
    
    var viewModel : CreateTimeCategoryViewModel?
    
    // Delegate
    
    var viewDelegate : PickerViewViewDelegate?
    
    init(viewModel : CreateTimeCategoryViewModel, delegate : PickerViewViewDelegate) {
        self.viewModel = viewModel
        viewDelegate = delegate
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        viewDelegate!.textFieldSelected = textField.tag
        switch textField.tag {
        case _ where Constants.timecatVC_normal_txtfield_tags.contains(textField.tag):
            viewDelegate!.removePickerViewDoneButton()
            return true
        case _ where Constants.timecatVC_picker_view_txtfield_tags.contains(textField.tag):
            viewDelegate!.addPickerViewDoneButton()
            return true
        default:
            print("Invalid text field tag")
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        viewDelegate!.textFieldSelected = textField.tag
        switch textField.tag {
        case Constants.timecatVC_name_txtField_tag:
            viewModel!.name = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            return true
        case _ where Constants.timecatVC_picker_view_txtfield_tags.contains(textField.tag):
            return true
        default:
            print("Invalid text field tag")
            return false
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if !Constants.timecatVC_picker_view_txtfield_tags.contains(viewDelegate!.textFieldSelected) {
            viewDelegate!.removePickerViewDoneButton()
        }
        return true
    }
}
