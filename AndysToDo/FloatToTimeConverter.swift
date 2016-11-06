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
        let minutes : String = String(format: "%02d", (Int((_time - floor(_time)) * 60)))
        var hours : String
        if(_time > Constants.hours_per_meridian) {
            hours = String(Int(floor(_time - Constants.hours_per_meridian)))
        } else {
            hours = String(Int(floor(_time)))
        }
        if hours == "0" || hours == "00" {
            hours = "12"
        }
        return "\(hours):\(minutes)"
    }
    
    class func convertFloatToTimeStringWithMeridian(_time: Float) -> String {
        let minutes : String = String(format: "%02d", (Int((_time - floor(_time)) * 60)))
        var hours : String
        var meridian = "AM"
        if(_time > Constants.hours_per_meridian) {
            hours = String(Int(floor(_time - Constants.hours_per_meridian)))
            meridian = "PM"
        } else {
            hours = String(Int(floor(_time)))
        }
        if hours == "0" || hours == "00" {
            hours = "12"
        }
        return "\(hours):\(minutes) \(meridian)"
    }
    
    class func dateToTimeConverter(_time : NSDate) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = Constants.standard_hours_and_minutes_format
        return dateformatter.string(from: _time as Date)
    }
    
    class func dateToTimeWithMeridianConverter(_time : NSDate) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "hh:mm a"
        return dateformatter.string(from: _time as Date)
    }
    
    class func dateToShortDateConverter(_time: NSDate) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM dd"
        return dateformatter.string(from: _time as Date)
    }
    
    class func dateToMonthConverter(_time: NSDate) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM"
        return dateformatter.string(from: _time as Date)
    }
    
    class func dateToDateOfMonthConverter(_time: NSDate) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd"
        return dateformatter.string(from: _time as Date)
    }
}
