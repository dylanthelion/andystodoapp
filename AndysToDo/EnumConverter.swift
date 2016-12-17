//
//  EnumConverter.swift
//  AndysToDo
//
//  Created by dillion on 12/10/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class EnumConverter {
    
    class func timeOfDayConvertValueToString(_timeOfDay: RepetitionTimeCategory?) -> String? {
        if _timeOfDay == nil {
            return nil
        }
        return Constants.timeOfDay_All_As_Strings[Constants.timeOfDay_All.index(of: _timeOfDay!)!]
    }
    
    class func timeOfDayConvertStringToValue(_timeOfDay : String) -> RepetitionTimeCategory? {
        if Constants.timeOfDay_All_As_Strings.index(of: _timeOfDay) == nil {
            return nil
        }
        return Constants.timeOfDay_All[Constants.timeOfDay_All_As_Strings.index(of: _timeOfDay)!]
    }
}
