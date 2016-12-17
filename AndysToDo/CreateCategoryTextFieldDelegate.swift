//
//  CreateCategoryTextFieldDelegate.swift
//  AndysToDo
//
//  Created by dillion on 12/15/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateCategoryTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    // View Model
    
    var viewModel : CreateCategoryViewModel?
    
    init(viewModel : CreateCategoryViewModel) {
        self.viewModel = viewModel
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel!.name = textField.text!
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        viewModel!.name = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        return true
    }
}
