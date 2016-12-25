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
        self.timecatDTOBond.bind(dynamic: TimeCategoryDTO.shared.AllTimeCategories!)
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
    
    func setCategory(timecat: TimeCategory) {
        timeCategory = timecat
        name = timecat.Name!
        description = timecat.Description!
        color = timecat.color
        startOfTimeWindow = timecat.StartOfTimeWindow
        endOfTimeWindow = timecat.EndOfTimeWindow
    }
    
    func updateCategory() {
        if let _ = timeCategory {
            for cat in TimeCategoryDTO.shared.AllTimeCategories!.value {
                if cat.value == timeCategory! {
                    timeCategory = cat.value
                }
            }
        }
    }
    
    // Submit
    
    func validateAndSubmitCategory() -> Bool {
        if let _ = timeCategory {
            if TimeCategoryDTO.shared.updateTimeCategory(_oldCategory: timeCategory!, _category: TimeCategory(_name: name!, _description: description!, _start: startOfTimeWindow!, _end: endOfTimeWindow!, _color: color)) {
                return true
            } else {
                return false
            }
        }
        
        if TimeCategoryDTO.shared.createNewTimeCategory(_category: TimeCategory(_name: name!, _description: description!, _start: startOfTimeWindow!, _end: endOfTimeWindow!, _color: color)) {
            return true
        } else {
            return false
        }
    }
}
