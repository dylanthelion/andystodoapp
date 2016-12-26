//
//  DayOfWeekPickerDelegateViewDelegate.swift
//  AndysToDo
//
//  Created by dillion on 12/26/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

protocol DayOfWeekPickerDelegateViewDelegate {
    func handleDidSelect(day : String, enumValue : DayOfWeek?)
}
