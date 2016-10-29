//
//  RepeatableTaskOccurrence.swift
//  AndysToDo
//
//  Created by dillion on 10/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class RepeatableTaskOccurrence {
    
    var UnitOfTime : RepetitionTimeCategory?
    var UnitsPerTask : Int?
    var TimeOfDay : Float?
    var FirstOccurrence : NSDate?
    var DayOfWeek : DayOfWeek?
    
    init(_unit : RepetitionTimeCategory, _unitCount : Int, _time : Float?, _firstOccurrence : NSDate?, _dayOfWeek: DayOfWeek?) {
        UnitOfTime = _unit
        UnitsPerTask = _unitCount
        TimeOfDay = _time
        FirstOccurrence = _firstOccurrence
        DayOfWeek = _dayOfWeek
    }
    
    func isValid() -> Bool {
        if let _ = UnitOfTime {
            switch UnitOfTime! {
            case .Hourly:
                return UnitsPerTask != nil && FirstOccurrence != nil
            case.Daily:
                return UnitsPerTask != nil && TimeOfDay != nil && FirstOccurrence != nil
            case .Weekly:
                return UnitsPerTask != nil && TimeOfDay != nil  && DayOfWeek != nil && FirstOccurrence != nil
            }
        }
        
        return false
    }
}
