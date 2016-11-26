//
//  CreateCategoryTextViewDelegate.swift
//  AndysToDo
//
//  Created by dillion on 12/15/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateCategoryTextViewDelegate : ReturnableTextView {
    
    // View Model
    
    var viewModel : CategoryCRUDViewModel?
    
    init(viewModel : CategoryCRUDViewModel) {
        self.viewModel = viewModel
    }
    
    override func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        viewModel!.description = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return super.textView(textView, shouldChangeTextIn: range,  replacementText: text)
    }
}
