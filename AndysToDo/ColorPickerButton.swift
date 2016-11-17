//
//  ColorPickerButton.swift
//  AndysToDo
//
//  Created by dillion on 11/1/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class ColorPickerButton : UIButton {
    
    var r_value : Float?
    var g_value : Float?
    var b_value : Float?
    
    init(frame: CGRect, _r: Float, _g: Float, _b: Float) {
        super.init(frame: frame)
        r_value = _r
        g_value = _g
        b_value = _b
        self.backgroundColor = UIColor(colorLiteralRed: r_value!, green: g_value!, blue: b_value!, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
    }
    
    func select() {
        DispatchQueue.main.async {
            self.layer.borderWidth = Constants.timecatVC_color_picker_selected_border_width
            self.layer.borderColor = Constants.timecatVC_color_picker_selected_border_color
        }
    }
    
    func deselect() {
        DispatchQueue.main.async {
            self.layer.borderWidth = Constants.timecatVC_color_picker_deselected_border_width
            self.layer.borderColor = Constants.timecatVC_color_picker_deselected_border_color
        }
    }
}
