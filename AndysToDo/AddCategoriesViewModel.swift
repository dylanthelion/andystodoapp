//
//  AddCategoriesViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/4/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

private var catHandle : UInt8 = 0

class AddCategoriesViewModel {
    
    // Model
    
    var categories : Dynamic<[Dynamic<Category>]>?
    var selectedCategories : Dynamic<[Dynamic<Category>]>?
    
    init() {
        self.categories = Dynamic(CategoryDTO.shared.AllCategories!.value.map({ $0 }))
        self.categoryDTOBond.bind(dynamic: CategoryDTO.shared.AllCategories!)
    }
    
    // Binding
    
    var categoryDTOBond: Bond<[Dynamic<Category>]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &catHandle) as AnyObject? {
            return b as! Bond<[Dynamic<Category>]>
        } else {
            let b = Bond<[Dynamic<Category>]>() { [unowned self] v in
                //print("Update cat in view model")
                self.updateCategories()
            }
            objc_setAssociatedObject(self, &catHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // Updates
    
    func updateCategories() {
        categories!.value.removeAll()
        categories!.value.append(contentsOf: CategoryDTO.shared.AllCategories!.value)
    }
}
