//
//  CreateRepeatableTaskOccurrenceViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/23/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateRepeatableTaskOccurrenceViewController : UIViewController,  DatePickerViewDelegateViewDelegate, TimePickerViewDelegateViewDelegate, DayOfWeekPickerDelegateViewDelegate, UnitOfTimePickerDelegateViewDelegate, PickerViewViewDelegate {
    
    // UI
    
    var textFieldSelected : Int = 0
    var top_y_coord : CGFloat = Constants.createRepeatableVC_starting_checkboxes_y_coord
    var labelsToAdd : [UILabel] = [UILabel]()
    var checkboxesToAdd : [CheckboxButton] = [CheckboxButton]()
    
    // View Model
    
    var viewModel = CreateRepeatableTaskOccurrenceViewModel()
    
    // Pickerviews
    
    var unitOfTimePickerView = UIPickerView()
    var timeOfDayPickerView = UIPickerView()
    var datePickerView = UIPickerView()
    var dayOfWeekPicker = UIPickerView()
    let timeOfDayDataSource : TimePickerViewDataSource = TimePickerViewDataSource()
    var datePickerDelegate : DatePickerViewDelegate?
    var datePickerDataSource = DatePickerDataSource()
    var timePickerDelegate : TimePickerViewDelegate?
    var dayOfWeekDelegate : DayOfWeekPickerDelegate?
    var dayOfWeekDataSource = DayOfWeekPickerDataSource()
    var unitOfTimePickerDelegate : UnitOfTimePickerDelegate?
    var unitOfTimePickerDataSource : UnitOfTimePickerDataSource = UnitOfTimePickerDataSource()
    
    // Text Fields
    
    var textFieldDelegate : CreateRepeatableTaskOccurenceTextFieldDelegate?
    
    // Outlets
    
    @IBOutlet weak var unitOfTime_txtField: UITextField!
    @IBOutlet weak var unitsPerTask_txtField: UITextField!
    @IBOutlet weak var firstTimeOfDay_txtField: UITextField!
    @IBOutlet weak var firstDate_txtField: UITextField!
    @IBOutlet weak var dayOfWeek_label: UILabel!
    @IBOutlet weak var dayOfWeek_txtField: UITextField!
    
    override func viewDidLoad() {
        setupPickerDelegation()
        setupTextFieldInput()
        setupTextFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !viewModel.validRepeatableSubmitted {
            if let rootVC = self.navigationController?.viewControllers[0] as? CreateTaskParentViewController {
                rootVC.viewModel?.resetModel()
            }
        }
    }
    
    // View setup
    
    func setupPickerDelegation() {
        timePickerDelegate = TimePickerViewDelegate(_delegate: self)
        unitOfTimePickerView.dataSource = unitOfTimePickerDataSource
        timeOfDayPickerView.delegate = timePickerDelegate!
        timeOfDayPickerView.dataSource = timeOfDayDataSource
        datePickerDelegate = DatePickerViewDelegate(_delegate: self)
        datePickerView.delegate = datePickerDelegate
        datePickerView.dataSource = datePickerDataSource
        dayOfWeekDelegate = DayOfWeekPickerDelegate(_delegate: self)
        dayOfWeekPicker.delegate = dayOfWeekDelegate
        dayOfWeekPicker.dataSource = dayOfWeekDataSource
        unitOfTimePickerDelegate = UnitOfTimePickerDelegate(_delegate: self)
        unitOfTimePickerView.delegate = unitOfTimePickerDelegate
    }
    
    func setupTextFieldInput() {
        dayOfWeek_txtField.inputView = dayOfWeekPicker
        unitOfTime_txtField.inputView = unitOfTimePickerView
        firstTimeOfDay_txtField.inputView = timeOfDayPickerView
        firstDate_txtField.inputView = datePickerView
    }
    
    func addDayOfWeekCheckBoxes() {
        let checkboxesAndLabels = CheckboxesHelper.generateCheckboxesAndLabels(titles: Array(Constants.days_of_week_as_strings.prefix(7)), cols: 2, viewWidth: self.view.frame.width, top_y_coord: top_y_coord)
        for checkbox in checkboxesAndLabels.0 {
            checkbox.addTarget(self, action: #selector(toggleDidSelectDate(sender:)), for: .touchUpInside)
            checkboxesToAdd.append(checkbox)
            DispatchQueue.main.async {
                self.view.addSubview(checkbox)
            }
        }
        for lbl in checkboxesAndLabels.1 {
            labelsToAdd.append(lbl)
            DispatchQueue.main.async {
                self.view.addSubview(lbl)
            }
        }
    }
    
    func setupTextFields() {
        textFieldDelegate = CreateRepeatableTaskOccurenceTextFieldDelegate(viewModel: viewModel, delegate: self)
        unitOfTime_txtField.delegate = textFieldDelegate
        unitsPerTask_txtField.delegate = textFieldDelegate
        firstTimeOfDay_txtField.delegate = textFieldDelegate
        firstDate_txtField.delegate = textFieldDelegate
        dayOfWeek_txtField.delegate = textFieldDelegate
    }
    
    // View reset
    
    func removeCheckboxesFromView() {
        DispatchQueue.main.async {
            for _label in self.labelsToAdd {
                _label.removeFromSuperview()
            }
            for _checkbox in self.checkboxesToAdd {
                _checkbox.removeFromSuperview()
            }
        }
    }
    
    // PickerViewViewDelegate
    
    func addPickerViewDoneButton() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(dismissPickerView))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func removePickerViewDoneButton() {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func dismissPickerView() {
        switch  textFieldSelected {
        case 0:
            unitOfTime_txtField.resignFirstResponder()
        case 2:
            firstTimeOfDay_txtField.resignFirstResponder()
        case 3:
            firstDate_txtField.resignFirstResponder()
        case 4:
            dayOfWeek_txtField.resignFirstResponder()
        default:
            print("Invalid value for selected text field")
        }
        removePickerViewDoneButton()
    }
    
    // DatePickerViewDelegateViewDelegate
    
    func handleDidSelect(months: String, days: String, fulldate: String) {
        firstDate_txtField.text = fulldate
        viewModel.startDay = days
        viewModel.startMonth = months
    }
    
    // TimePickerViewDelegateViewDelegate
    
    func handleDidSelect(hours: String, minutes: String, meridian: String, fullTime: String) {
        var floatToPass : Float = 0.0
        floatToPass += Float(hours)!
        floatToPass += (Float(minutes))! / Constants.seconds_per_minute
        if meridian == Constants.meridian_pm {
            floatToPass += Constants.hours_per_meridian
        }
        firstTimeOfDay_txtField.text = fullTime
        viewModel.startHours = fullTime
        viewModel.timeOfDay = floatToPass
    }
    
    // DayOfWeekPickerDelegateViewDelegate
    
    func handleDidSelect(day : String, enumValue : DayOfWeek?) {
        self.dayOfWeek_txtField.text = day
        viewModel.dayOfWeek = enumValue
        if enumValue! != DayOfWeek.Multiple {
            if !CollectionHelper.IsNilOrEmpty(_coll: labelsToAdd) {
                removeCheckboxesFromView()
                viewModel.daysOfWeek?.removeAll()
            }
        } else {
            addDayOfWeekCheckBoxes()
        }
    }
    
    // UnitOfTimePickerDelegateViewDelegate
    
    func handleDidSelect(unit : String) {
        viewModel.unitOfTimeAsString = unit
        self.unitOfTime_txtField.text = unit
        if unit == Constants.timeOfDay_All_As_Strings[2] {
            dayOfWeek_txtField.isHidden = false
            dayOfWeek_txtField.isUserInteractionEnabled = true
            dayOfWeek_label.isHidden = false
        } else {
            dayOfWeek_txtField.isHidden = true
            dayOfWeek_txtField.isUserInteractionEnabled = false
            dayOfWeek_label.isHidden = true
        }
    }
    
    // Day of week checkboxes
    
    func toggleDidSelectDate(sender: CheckboxButton) {
        if sender.checked {
            let index = viewModel.daysOfWeek!.index(of: Constants.dayOfWeek_all[sender.tag])!
            viewModel.daysOfWeek!.remove(at: index)
        } else {
            viewModel.daysOfWeek!.append(Constants.dayOfWeek_all[sender.tag])
        }
        sender.toggleChecked()
    }
    
    // IB Actions
    
    @IBAction func submit(_ sender: AnyObject) {
        if !validateForSubmit() {
            return
        }
        let check = viewModel.submit()
        if !check.0 {
            AlertHelper.PresentAlertController(sender: self, title: check.1, message: check.2, actions: [Constants.standard_ok_alert_action])
        } else {
            // handle success
            unwindToTaskCreate()
        }
    }
    
    // Validation
    
    func validateForSubmit() -> Bool {
        if unitOfTime_txtField.text == "" || unitsPerTask_txtField.text! == "" {
            AlertHelper.PresentAlertController(sender: self, title: Constants.standard_alert_error_title, message: Constants.createRepeatableVC_alert_no_unitOfTime_failure_message, actions: [Constants.standard_ok_alert_action])
            return false
        }
        if(firstDate_txtField.text! == "" || firstTimeOfDay_txtField.text! == "" || (unitOfTime_txtField.text == Constants.timeOfDay_All_As_Strings[2] && dayOfWeek_txtField.text! == "")) {
            AlertHelper.PresentAlertController(sender: self, title: Constants.standard_alert_error_title, message: Constants.createRepeatableVC_alert_missing_data_failure_message, actions: [Constants.standard_ok_alert_action])
            return false
        }
        return true
    }
    
    // On successful submit
    
    func unwindToTaskCreate() {
        if let rootVC = self.navigationController?.viewControllers[Constants.main_storyboard_create_tasks_VC_index] as? CreateTaskParentViewController {
            if viewModel.multipleRepeatables!.count > 1 {
                rootVC.viewModel?.multipleRepeatables = viewModel.multipleRepeatables!
            } else {
                rootVC.viewModel?.repeatableTask = viewModel.multipleRepeatables![0]
            }
            rootVC.viewModel?.repeatable.value = true
            rootVC.viewModel?.startTime = viewModel.date
            self.navigationController?.popToViewController(rootVC, animated: true)
        }
    }
}
