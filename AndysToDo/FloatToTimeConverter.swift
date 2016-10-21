//
//  FloatToTimeConverter.swift
//  AndysToDo
//
//  Created by dillion on 10/17/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class TimeConverter {
    
    class func convertFloatToTimeString(_time : Float) -> String {
        let minutes : String = String((_time - floor(_time)) * 0.6)
        var hours : String
        if(_time >= 13) {
            hours = String(Int(floor(_time - 12.0)))
        } else {
            hours = String(Int(floor(_time)))
        }
        return "\(hours):\(minutes)"
    }
    
    class func dateToTimeConverter(_time : NSDate) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:MM"
        return dateformatter.string(from: _time as Date)
    }
}
