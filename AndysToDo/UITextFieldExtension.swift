//
//  UITextFieldExtension.swift
//  AndysToDo
//
//  Created by dillion on 11/25/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private var handle: UInt8 = 0

extension UITextField {
    var textBond: Bond<String> {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as! Bond<String>
        } else {
            let b = Bond<String>() { [unowned self] v in self.text = v }
            objc_setAssociatedObject(self, &handle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
}
