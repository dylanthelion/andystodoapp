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

class CreateTimeCategoryViewModel {
    
    var timeCategory: TimeCategory?
    var name : String?
    var description : String?
    var color : CGColor?
    var StartOfTimeWindow : Float?
    var EndOfTimeWindow : Float?
    
    init() {
        self.timecatDTOBond.bind(dynamic: TimeCategoryDTO.shared.AllTimeCategories!)
    }
    
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
    
    func setCategory(timecat: TimeCategory) {
        timeCategory = timecat
        name = timecat.Name!
        description = timecat.Description!
        color = timecat.color
        StartOfTimeWindow = timecat.StartOfTimeWindow
        EndOfTimeWindow = timecat.EndOfTimeWindow
    }
    
    func updateCategory() {
        if timeCategory == nil {
            return
        }
        for cat in TimeCategoryDTO.shared.AllTimeCategories!.value {
            if cat.value == timeCategory! {
                timeCategory = cat.value
            }
        }
    }
    
    func validateAndSubmitCategory() -> Bool {
        if let _ = timeCategory {
            if TimeCategoryDTO.shared.updateTimeCategory(_oldCategory: timeCategory!, _category: TimeCategory(_name: name!, _description: description!, _start: StartOfTimeWindow!, _end: EndOfTimeWindow!, _color: color)) {
                return true
            } else {
                return false
            }
        }
        
        if TimeCategoryDTO.shared.createNewTimeCategory(_category: TimeCategory(_name: name!, _description: description!, _start: StartOfTimeWindow!, _end: EndOfTimeWindow!, _color: color)) {
            return true
        } else {
            return false
        }
    }
}
