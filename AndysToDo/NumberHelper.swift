//
//  NumberHelper.swift
//  AndysToDo
//
//  Created by dillion on 11/11/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class NumberHelper {
    
    class func isNilOrZero(_ num : Int?) -> Bool {
        if num == nil {
            return true
        }
        if num! == 0 {
            return true
        }
        return false
    }
    
    class func isNilOrZero(_ num : TimeInterval?) -> Bool {
        if num == nil {
            return true
        }
        if num! == 0 {
            return true
        }
        return false
    }
}
