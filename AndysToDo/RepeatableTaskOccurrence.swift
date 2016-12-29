//
//  RepeatableTaskOccurrence.swift
//  AndysToDo
//
//  Created by dillion on 10/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class RepeatableTaskOccurrence {
    
    var unitOfTime : RepetitionTimeCategory?
    var unitsPerTask : Int?
    var timeOfDay : Float?
    var firstOccurrence : NSDate?
    var dayOfWeek : DayOfWeek?
    
    init(unit : RepetitionTimeCategory, unitCount : Int, time : Float?, firstOccurrence : NSDate?, dayOfWeek: DayOfWeek?) {
        unitOfTime = unit
        unitsPerTask = unitCount
        timeOfDay = time
        self.firstOccurrence = firstOccurrence
        self.dayOfWeek = dayOfWeek
    }
    
    func isValid() -> Bool {
        if let _ = unitOfTime {
            switch unitOfTime! {
            case .Hourly:
                return unitsPerTask != nil && firstOccurrence != nil
            case.Daily:
                return unitsPerTask != nil && timeOfDay != nil && firstOccurrence != nil
            case .Weekly:
                return unitsPerTask != nil && timeOfDay != nil  && dayOfWeek != nil && firstOccurrence != nil
            }
        }
        return false
    }
}
