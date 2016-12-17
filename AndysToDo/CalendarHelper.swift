//
//  CalendarHelper.swift
//  AndysToDo
//
//  Created by dillion on 11/18/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class CalendarHelper {
    
    class var shortDateAsInt : (Int, Int)  {
        return (Calendar.current.component(.month, from: Date()),Calendar.current.component(.day, from: Date()))
    }
}
