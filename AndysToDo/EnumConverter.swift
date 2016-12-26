//
//  EnumConverter.swift
//  AndysToDo
//
//  Created by dillion on 12/10/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class EnumConverter {
    
    class func timeOfDayConvertValueToString(_ timeOfDay: RepetitionTimeCategory?) -> String? {
        if timeOfDay == nil {
            return nil
        }
        return Constants.timeOfDay_All_As_Strings[Constants.timeOfDay_All.index(of: timeOfDay!)!]
    }
    
    class func timeOfDayConvertStringToValue(_ timeOfDay : String) -> RepetitionTimeCategory? {
        if Constants.timeOfDay_All_As_Strings.index(of: timeOfDay) == nil {
            return nil
        }
        return Constants.timeOfDay_All[Constants.timeOfDay_All_As_Strings.index(of: timeOfDay)!]
    }
}
