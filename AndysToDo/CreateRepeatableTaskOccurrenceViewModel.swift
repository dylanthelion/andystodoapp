//
//  CreateRepeatableTaskOccurrenceViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/4/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class CreateRepeatableTaskOccurrenceViewModel {
    
    var startMonth: String?
    var startDay: String?
    var _timeOfDay : Float?
    var _dayOfWeek : DayOfWeek?
    var daysOfWeek : [DayOfWeek]?
    var startHours : String?
    var date : NSDate?
    var numberOfUnits : Int = 0
    var validRepeatableSubmitted = false
    var unitOfTimeAsString : String?
    var multipleRepeatables : [RepeatableTaskOccurrence]? = [RepeatableTaskOccurrence]()
    
    init() {
        daysOfWeek = [DayOfWeek]()
    }
    
    func submit() -> (Bool, String, String) {
        multipleRepeatables = createRepeatable()
        if CollectionHelper.IsNilOrEmpty(_coll: multipleRepeatables) {
            return (false, Constants.standard_alert_error_title, Constants.createRepeatableVC_alert_invalid_failure_message)
        }
        var areValid = true
        for repeatable in multipleRepeatables! {
            if(!repeatable.isValid()) {
                print(repeatable.UnitsPerTask)
                areValid = false
                break
            }
        }
        if !areValid {
            return (false, Constants.standard_alert_error_title, Constants.createRepeatableVC_alert_invalid_failure_message)
        }
        validRepeatableSubmitted = true
        return(true, "", "")
    }
    
    func createRepeatable() -> [RepeatableTaskOccurrence]? {
        var _unitOfTime : RepetitionTimeCategory?
        
        switch unitOfTimeAsString! {
        case Constants.timeOfDay_hourly_value:
            _unitOfTime = .Hourly
        case Constants.timeOfDay_daily_value:
            _unitOfTime = .Daily
        case Constants.timeOfDay_weekly_value:
            _unitOfTime = .Weekly
        default:
            _unitOfTime = nil
        }
        let _numberOfUnits : Int? = Constants.repetitionTimeCategory_All_As_Strings.index(of: unitOfTimeAsString!)
        if _numberOfUnits == nil {
            print("Unit is nil")
            return nil
        }
        
        let formatter = StandardDateFormatter()
        let year = formatter.getNextMonthOccurrence(startMonth: startMonth!, startDay: startDay!)
        let taskDate = formatter.date(from: "\(startMonth!) \(startDay!) \(startHours!) \(year)")! as NSDate
        if _dayOfWeek! == DayOfWeek.Multiple {
            let dayOfWeek = Int(Calendar(identifier: .gregorian).component(.weekday, from: taskDate as Date)) - 1
            var repeatablesToReturn = [RepeatableTaskOccurrence]()
            for day in daysOfWeek! {
                let daysToAdd = abs(Constants.dayOfWeek_all.index(of: day)! - dayOfWeek) * Constants.seconds_per_day
                if self.date == nil {
                    self.date = taskDate.addingTimeInterval(TimeInterval(daysToAdd))
                }
                let newRepeatable = RepeatableTaskOccurrence(_unit: _unitOfTime!, _unitCount: _numberOfUnits!, _time: _timeOfDay, _firstOccurrence: taskDate.addingTimeInterval(TimeInterval(daysToAdd)) , _dayOfWeek: day)
                repeatablesToReturn.append(newRepeatable)
            }
            return repeatablesToReturn
        } else {
            let repeatable = RepeatableTaskOccurrence(_unit: _unitOfTime!, _unitCount: _numberOfUnits!, _time: _timeOfDay, _firstOccurrence: taskDate, _dayOfWeek: self._dayOfWeek)
            self.date = taskDate
            return [repeatable]
        }
        
    }
}
