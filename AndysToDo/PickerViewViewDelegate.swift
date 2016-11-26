//
//  PickerViewViewDelegate.swift
//  AndysToDo
//
//  Created by dillion on 12/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

protocol PickerViewViewDelegate {
    
    var textFieldSelected : Int { get set }
    func addPickerViewDoneButton()
    func removePickerViewDoneButton()
}
