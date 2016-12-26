//
//  CreateRepeatableTaskOccurrenceViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/4/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class CreateRepeatableTaskOccurrenceViewModel : DatePickerViewModel {
    
    // Model
    
    var startMonth: String?
    var startDay: String?
    var startHours : String?
    var timeOfDay : Float?
    var dayOfWeek : DayOfWeek?
    var daysOfWeek : [DayOfWeek]?
    var date : NSDate?
    var numberOfUnits : Int = 0
    var validRepeatableSubmitted = false
    var unitOfTimeAsString : String?
    var multipleRepeatables : [RepeatableTaskOccurrence]? = [RepeatableTaskOccurrence]()
    
    init() {
        daysOfWeek = [DayOfWeek]()
    }
    
    // Submit
    
    func submit() -> (Bool, String, String) {
        if !validateForSubmit() {
            return (false, Constants.standard_alert_error_title, Constants.createRepeatableVC_alert_invalid_failure_message)
        }
        multipleRepeatables = createRepeatable()
        if CollectionHelper.IsNilOrEmpty(multipleRepeatables) {
            return (false, Constants.standard_alert_error_title, Constants.createRepeatableVC_alert_invalid_failure_message)
        }
        var areValid = true
        for repeatable in multipleRepeatables! {
            if(!repeatable.isValid()) {
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
    
    // Validation
    
    func validateForSubmit() -> Bool {
        if numberOfUnits <= 0 {
            return false
        }
        return true
    }
    
    // Create
    
    func createRepeatable() -> [RepeatableTaskOccurrence]? {
        let unitOfTime : RepetitionTimeCategory? = EnumConverter.timeOfDayConvertStringToValue(unitOfTimeAsString!)
        let date = TimeConverter.hoursDaysAndMonthToDate(startMonth: startMonth!, startDay: startDay!, startHours: startHours!)
        self.date = date
        guard let check = dayOfWeek else {
            return [buildRepeatableFrom(unitOfTime: unitOfTime!, date: date)]
        }
        if check == DayOfWeek.Multiple {
            return buildMultipleRepeatablesFrom(unitOfTime: unitOfTime!, date: date)
        } else {
            return [buildRepeatableFrom(unitOfTime: unitOfTime!, date: date)]
        }
        
    }
    
    // Build repeatables
    
    func buildRepeatableFrom(unitOfTime : RepetitionTimeCategory, date : NSDate) -> RepeatableTaskOccurrence {
        return RepeatableTaskOccurrence(unit: unitOfTime, unitCount: numberOfUnits, time: timeOfDay, firstOccurrence: date, dayOfWeek: dayOfWeek)
    }
    
    func buildMultipleRepeatablesFrom(unitOfTime : RepetitionTimeCategory, date : NSDate) -> [RepeatableTaskOccurrence] {
        let dayOfWeek = Int(Calendar(identifier: .gregorian).component(.weekday, from: date as Date)) - 1
        var repeatablesToReturn = [RepeatableTaskOccurrence]()
        for day in daysOfWeek! {
            let daysToAdd = abs(Constants.dayOfWeek_all.index(of: day)! - dayOfWeek) * Constants.seconds_per_day
            if self.date == nil {
                self.date = date.addingTimeInterval(TimeInterval(daysToAdd))
            }
            let newRepeatable = RepeatableTaskOccurrence(unit: unitOfTime, unitCount: numberOfUnits, time: timeOfDay, firstOccurrence: date.addingTimeInterval(TimeInterval(daysToAdd)), dayOfWeek: day)
            repeatablesToReturn.append(newRepeatable)
        }
        return repeatablesToReturn
    }
}
