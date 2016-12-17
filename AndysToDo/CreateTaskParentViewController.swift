//
//  CreateTaskParentViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/4/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

// Shared parent for CreateTaskVC and AllTasksIndividualTaskVC

class CreateTaskParentViewController : UIViewController {
    
    // UI
    
    var textFieldSelected = 0
    
    // View Model
    
    var viewModel : TaskCRUDViewModel?
    
    // Picker views
    
    let pickerView = UIPickerView()
    let timeCatPickerView = UIPickerView()
    var datePickerView = UIPickerView()
    var expectedUnitOfTimePickerView = UIPickerView()
    var timePickerDelegate : TimePickerViewDelegate?
    let timePickerDataSource : TimePickerViewDataSource = TimePickerViewDataSource()
    var timeCatPickerDataSource : TimecatPickerDataSource?
    var timeCatDelegate : TimecatPickerDelegate?
    var datePickerDelegate : DatePickerViewDelegate?
    let datePickerDataSource = DatePickerDataSource()
    let expectedPickerDataSource = ExpectedUnitOfTimePickerDataSource()
    var expectedPickerDelegate : ExpectedUnitOfTimePickerDelegate?
    
    override func viewDidLoad() {
    }
}
