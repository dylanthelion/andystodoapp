//
//  CategoryTableViewCell.swift
//  AndysToDo
//
//  Created by dillion on 11/6/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private var handle: UInt8 = 0

class CategoryTableViewCell : UITableViewCell {
    
    override func awakeFromNib() {
        
    }
    
    var categoryBond: Bond<Category> {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as! Bond<Category>
        } else {
            let b = Bond<Category>() { [unowned self] v in
                DispatchQueue.main.async {
                    self.textLabel?.text = v.Name!
                }
            }
            objc_setAssociatedObject(self, &handle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
}
