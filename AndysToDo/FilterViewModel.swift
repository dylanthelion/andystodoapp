//
//  FilterViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/1/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

private var catHandle: UInt8 = 0
private var timecatHandle: UInt8 = 0
private let populated = FilterViewModel()

class FilterViewModel {
    
    // Model
    
    var categories : Dynamic<[Dynamic<Category>]>?
    var timeCategories : Dynamic<[Dynamic<TimeCategory>]>?
    
    init() {
        self.categories = Dynamic(CategoryDTO.shared.AllCategories!.value.map({ $0 }))
        self.timeCategories = Dynamic(TimeCategoryDTO.shared.AllTimeCategories!.value.map({ $0 }))
        self.categoryDTOBond.bind(dynamic: CategoryDTO.shared.AllCategories!)
        self.timecatDTOBond.bind(dynamic: TimeCategoryDTO.shared.AllTimeCategories!)
    }
    
    class var shared : FilterViewModel {
        return populated
    }
    
    // Bonding
    
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
    
    var timecatDTOBond: Bond<[Dynamic<TimeCategory>]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &timecatHandle) as AnyObject? {
            return b as! Bond<[Dynamic<TimeCategory>]>
        } else {
            let b = Bond<[Dynamic<TimeCategory>]>() { [unowned self] v in
                //print("Update timecat in view model")
                self.updateTimecats()
            }
            objc_setAssociatedObject(self, &timecatHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    func updateCategories() {
        categories!.value.removeAll()
        categories!.value.append(contentsOf: CategoryDTO.shared.AllCategories!.value)
    }
    
    func updateTimecats() {
        timeCategories!.value.removeAll()
        timeCategories!.value.append(contentsOf: TimeCategoryDTO.shared.AllTimeCategories!.value)
    }
}
