//
//  DatePickerViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/10/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

protocol DatePickerViewModel {
    
    var startMonth: String? { get set }
    var startDay: String? { get set }
    var startHours : String? { get set }
}
