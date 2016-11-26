//
//  CheckboxButton.swift
//  AndysToDo
//
//  Created by dillion on 10/21/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private var handle: UInt8 = 0

class CheckboxButton : UIButton {
    
    var checked = false
    
    func toggleChecked() {
        switch checked {
        case false :
            checked = true
            DispatchQueue.main.async {
                self.setImage(UIImage(named: Constants.img_checkbox_checked), for: .normal)
            }
        case true :
            checked = false
            DispatchQueue.main.async {
                self.setImage(UIImage(named: Constants.img_checkbox_unchecked), for: .normal)
            }
        }
    }
    
    func setChecked(_checked : Bool) {
        if (_checked && !self.checked) || (!_checked && self.checked) {
            self.toggleChecked()
        }
    }
    
    var checkedBond: Bond<Bool> {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as! Bond<Bool>
        } else {
            let b = Bond<Bool>() { [unowned self] v in self.setChecked(_checked: v) }
            objc_setAssociatedObject(self, &handle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
}
