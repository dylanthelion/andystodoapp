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
        let minutes : String = String(format: "%02d", (Int((_time - floor(_time)) * Constants.seconds_per_minute)))
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
        let minutes : String = String(format: "%02d", (Int((_time - floor(_time)) * Constants.seconds_per_minute)))
        var hours : String
        var meridian = Constants.meridian_am
        if(_time > Constants.hours_per_meridian) {
            hours = String(Int(floor(_time - Constants.hours_per_meridian)))
            meridian = Constants.meridian_pm
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
        dateformatter.dateFormat = Constants.standard_hours_meridian_format
        return dateformatter.string(from: _time as Date)
    }
    
    class func dateToShortDateConverter(_time: NSDate) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = Constants.standard_months_and_days_format
        return dateformatter.string(from: _time as Date)
    }
    
    class func dateToMonthConverter(_time: NSDate) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = Constants.standard_month_format
        return dateformatter.string(from: _time as Date)
    }
    
    class func dateToDateOfMonthConverter(_time: NSDate) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = Constants.standard_days_format
        return dateformatter.string(from: _time as Date)
    }
    
    class func convertTimeIntervalToCalendarUnits(_interval : TimeInterval, _units : Calendar.Component) -> Int {
        let denominator : Int
        switch _units {
        case .day:
            denominator = Constants.seconds_per_day
        case .hour:
            denominator = Constants.seconds_per_hour
        case .minute:
            denominator = Int(Constants.seconds_per_minute)
        case .month:
            denominator = Constants.seconds_per_month
        default:
            print("Invalid unit for conversion")
            return 0
        }
        
        return Int(_interval) / denominator
    }
}
