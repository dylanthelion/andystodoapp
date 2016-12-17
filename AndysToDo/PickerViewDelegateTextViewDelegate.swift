//
//  PickerViewDelegateTextViewDelegate.swift
//  AndysToDo
//
//  Created by dillion on 12/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class PickerViewDelegateTextViewDelegate : CreateCategoryTextViewDelegate {
    
    // Delegate
    
    var viewDelegate : PickerViewViewDelegate?
    
    init(viewModel : CategoryCRUDViewModel, delegate : PickerViewViewDelegate) {
        super.init(viewModel: viewModel)
        viewDelegate = delegate
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        viewDelegate?.textFieldSelected = textView.tag
        viewDelegate!.removePickerViewDoneButton()
        return true
    }
}
