//
//  TimePickerViewDelegateViewDelegate.swift
//  AndysToDo
//
//  Created by dillion on 12/26/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

protocol TimePickerViewDelegateViewDelegate {
    func handleDidSelect(hours : String, minutes : String, meridian : String, fullTime : String)
}
