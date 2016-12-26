//
//  CreateTimeCategoryViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/3/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation
import CoreGraphics

private var catHandle : UInt8 = 0

class CreateTimeCategoryViewModel : CategoryCRUDViewModel {
    
    // Model
    
    var timeCategory: TimeCategory?
    var color : CGColor?
    var startOfTimeWindow : Float?
    var endOfTimeWindow : Float?
    var name : String?
    var description : String?
    
    init() {
        self.timecatDTOBond.bind(dynamic: TimeCategoryDTO.shared.allTimeCategories!)
    }
    
    // Binding
    
    var timecatDTOBond: Bond<[Dynamic<TimeCategory>]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &catHandle) as AnyObject? {
            return b as! Bond<[Dynamic<TimeCategory>]>
        } else {
            let b = Bond<[Dynamic<TimeCategory>]>() { [unowned self] v in
                self.updateCategory()
            }
            objc_setAssociatedObject(self, &catHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // Updates
    
    func setCategory(_ timecat: TimeCategory) {
        timeCategory = timecat
        name = timecat.name!
        description = timecat.description!
        color = timecat.color
        startOfTimeWindow = timecat.startOfTimeWindow
        endOfTimeWindow = timecat.endOfTimeWindow
    }
    
    func updateCategory() {
        if let _ = timeCategory {
            for cat in TimeCategoryDTO.shared.allTimeCategories!.value {
                if cat.value == timeCategory! {
                    timeCategory = cat.value
                }
            }
        }
    }
    
    // Submit
    
    func validateAndSubmitCategory() -> Bool {
        if let _ = timeCategory {
            if TimeCategoryDTO.shared.updateTimeCategory(oldCategory: timeCategory!, newCategory: TimeCategory(name: name!, description: description!, start: startOfTimeWindow!, end: endOfTimeWindow!, color: color)) {
                return true
            } else {
                return false
            }
        }
        
        if TimeCategoryDTO.shared.createNewTimeCategory(TimeCategory(name: name!, description: description!, start: startOfTimeWindow!, end: endOfTimeWindow!, color: color)) {
            return true
        } else {
            return false
        }
    }
}
