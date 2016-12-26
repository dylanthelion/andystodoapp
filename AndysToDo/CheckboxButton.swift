//
//  CheckboxButton.swift
//  AndysToDo
//
//  Created by dillion on 10/21/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CheckboxButton : UIButton {
    
    var _checked : Bool
    var checked : Bool {
        get {
            return _checked
        }
        set {
            if (newValue && !self._checked) || (!newValue && self._checked) {
                self.toggleChecked()
            }
        }
    }
    
    override init(frame: CGRect) {
        _checked = false
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        _checked = false
        super.init(coder: aDecoder)
    }
    
    func toggleChecked() {
        switch _checked {
        case false :
            _checked = true
            DispatchQueue.main.async {
                self.setImage(UIImage(named: Constants.img_checkbox_checked), for: .normal)
            }
        case true :
            _checked = false
            DispatchQueue.main.async {
                self.setImage(UIImage(named: Constants.img_checkbox_unchecked), for: .normal)
            }
        }
    }
}
