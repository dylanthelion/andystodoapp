//
//  BorderedTextView.swift
//  AndysToDo
//
//  Created by dillion on 11/17/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class BorderedTextView : UITextView {
    
    override func awakeFromNib() {
        self.layer.borderWidth = Constants.text_view_border_width
        self.layer.borderColor = Constants.text_view_border_color
    }
}
