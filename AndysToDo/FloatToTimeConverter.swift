//
//  FloatToTimeConverter.swift
//  AndysToDo
//
//  Created by dillion on 10/17/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class TimeConverter {
    
    class func convertFloatToTimeString(_ time : Float) -> String {
        let minutes : String = String(format: "%02d", (Int((time - floor(time)) * Constants.seconds_per_minute)))
        var hours : String
        if(time > Constants.hours_per_meridian) {
            hours = String(Int(floor(time - Constants.hours_per_meridian)))
        } else {
            hours = String(Int(floor(time)))
        }
        if hours == "0" || hours == "00" {
            hours = Constants.hours_per_meridian_as_string
        }
        return "\(hours):\(minutes)"
    }
    
    class func convertFloatToTimeStringWithMeridian(_ time: Float) -> String {
        let minutes : String = String(format: "%02d", (Int((time - floor(time)) * Constants.seconds_per_minute)))
        var hours : String
        var meridian = Constants.meridian_am
        if(time > Constants.hours_per_meridian) {
            hours = String(Int(floor(time - Constants.hours_per_meridian)))
            meridian = Constants.meridian_pm
        } else {
            hours = String(Int(floor(time)))
        }
        if hours == "0" || hours == "00" {
            hours = Constants.hours_per_meridian_as_string
        }
        return "\(hours):\(minutes) \(meridian)"
    }
    
    class func dateToTimeConverter(_ time : NSDate) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = Constants.standard_hours_and_minutes_format
        return dateformatter.string(from: time as Date)
    }
    
    class func dateToTimeWithMeridianConverter(_ time : NSDate) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = Constants.standard_hours_meridian_format
        return dateformatter.string(from: time as Date)
    }
    
    class func dateToShortDateConverter(_ time: NSDate) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = Constants.standard_months_and_days_format
        return dateformatter.string(from: time as Date)
    }
    
    class func dateToMonthConverter(_ time: NSDate) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = Constants.standard_month_format
        return dateformatter.string(from: time as Date)
    }
    
    class func dateToDateOfMonthConverter(_ time: NSDate) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = Constants.standard_days_format
        return dateformatter.string(from: time as Date)
    }
    
    class func convertTimeIntervalToCalendarUnits(interval : TimeInterval, units : Calendar.Component) -> Int {
        let denominator : Int
        switch units {
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
        
        return Int(interval) / denominator
    }
    
    class func hoursDaysAndMonthToDate(startMonth : String, startDay : String, startHours : String) -> NSDate {
        let formatter = StandardDateFormatter()
        let df = DateFormatter()
        df.dateFormat = Constants.standard_month_format
        let year : String = formatter.getNextMonthOccurrence(startMonth: startMonth, startDay: startDay)
        //print("\(startMonth!) \(startDay!) \(startHours!) \(year)")
        return formatter.date(from: "\(startMonth) \(startDay) \(startHours) \(year)")! as NSDate
    }
    
    class func hoursMinutesAndMeridianToTimeAsFloat(hours: String, minutes: String, meridian: String) -> Float {
        var time : Float = Float(hours)! + (Float(minutes)! / Constants.seconds_per_minute)
        if meridian == Constants.meridian_pm && hours != Constants.hours_per_meridian_as_string {
            time += Constants.hours_per_meridian
        }
        return time
    }
}
