//
//  CreateTaskParentViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/4/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

// Shared parent for CreateTaskVC and AllTasksIndividualTaskVC

protocol CreateTaskParentViewController {
    
    // UI
    
    var textFieldSelected : Int { get set }
    
    // View Model
    
    var viewModel : TaskCRUDViewModel? { get set }
    
    // Picker views
    
    var pickerView : UIPickerView { get set }
    var timeCatPickerView : UIPickerView { get set }
    var datePickerView : UIPickerView { get set }
    var expectedUnitOfTimePickerView : UIPickerView { get set }
    var timePickerDelegate : TimePickerViewDelegate? { get set }
    var timePickerDataSource : TimePickerViewDataSource { get set }
    var timeCatPickerDataSource : TimecatPickerDataSource? { get set }
    var timeCatDelegate : TimecatPickerDelegate? { get set }
    var datePickerDelegate : DatePickerViewDelegate? { get set }
    var datePickerDataSource : DatePickerDataSource { get set }
    var expectedPickerDataSource : ExpectedUnitOfTimePickerDataSource { get set }
    var expectedPickerDelegate : ExpectedUnitOfTimePickerDelegate? { get set }
}
