//
//  ExpectedTimeRequirement.swift
//  AndysToDo
//
//  Created by dillion on 12/10/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

struct ExpectedTimeRequirement {
    
    var _unit : UnitOfTime
    var unit : UnitOfTime? {
        set  {
            _unit = newValue!
        }
        get {
            if _unit != UnitOfTime.Null && _numberOfUnits > 0 {
                return _unit
            } else {
                return nil
            }
        }
    }
    
    var _numberOfUnits : Int
    var numberOfUnits : Int? {
        set  {
            _numberOfUnits = newValue!
        }
        get {
            if _unit != UnitOfTime.Null && _numberOfUnits > 0 {
                return _numberOfUnits
            } else {
                return nil
            }
        }
    }
    
    mutating func update(newUnitOfTime : UnitOfTime?, newValue: Int?) {
        if let _ = newUnitOfTime {
            unit = newUnitOfTime!
        }
        if let _ = newValue {
            numberOfUnits = newValue!
        }
    }
    
    func isValid() -> Bool {
        return unit! != nil
    }
}
