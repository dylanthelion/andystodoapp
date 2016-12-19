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
    
    // Local model. These classes are used to prevent excessive view updates, caused by frequent model changes
    
    private var localCats : Dynamic<[Dynamic<Category>]>?
    
    init() {
        self.localCats = Dynamic(CategoryDTO.shared.AllCategories!.value.map({ $0 }))
        sort()
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
        localCats!.value.removeAll()
        localCats!.value.append(contentsOf: CategoryDTO.shared.AllCategories!.value)
        sort()
    }
    
    // Sorting
    
    func sort() {
        localCats!.value.sort(by: {
            return ($0.value.Name! < $1.value.Name!)
        })
        if let _ = categories {
            categories!.value = localCats!.value
        } else {
            categories = localCats
        }
    }
}
