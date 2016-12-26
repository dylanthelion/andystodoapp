//
//  CreateCategoryViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/2/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

private var catHandle : UInt8 = 0

class CreateCategoryViewModel : CategoryCRUDViewModel {
    
    // Model
    
    var category: Category?
    var name : String?
    var description : String?
    
    init() {
        self.categoryDTOBond.bind(dynamic: CategoryDTO.shared.allCategories!)
    }
    
    // Binding
    
    var categoryDTOBond: Bond<[Dynamic<Category>]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &catHandle) as AnyObject? {
            return b as! Bond<[Dynamic<Category>]>
        } else {
            let b = Bond<[Dynamic<Category>]>() { [unowned self] v in
                //print("Update cat in view model")
                self.updateCategory()
            }
            objc_setAssociatedObject(self, &catHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // Updates
    
    func setCategory(cat: Category) {
        category = cat
        name = cat.name!
        description = cat.description!
    }
    
    func updateCategory() {
        if let _ = category {
            for cat in CategoryDTO.shared.allCategories!.value {
                if cat.value == category! {
                    category = cat.value
                }
            }
        }
    }
    
    // Submit
    
    func validateAndSubmitCategory() -> Bool {
        if let _ = category {
            if CategoryDTO.shared.updateCategory(oldCategory: category!, newCategory: Category(name: name!, description: description!)) {
                return true
            } else {
                return false
            }
        }
        if CategoryDTO.shared.createNewCategory(Category(name: name!, description: description!)) {
            return true
        } else {
            return false
        }
    }
}
