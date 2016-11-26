//
//  CreateRepeatableTaskOccurrenceViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/23/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateRepeatableTaskOccurrenceViewController : UIViewController, UITextFieldDelegate,  DatePickerViewDelegateViewDelegate, TimePickerViewDelegateViewDelegate, DayOfWeekPickerDelegateViewDelegate, UnitOfTimePickerDelegateViewDelegate {
    
    // DatePickerViewDelegateViewDelegate
    
    var startMonth: String?
    var startDay: String?
    
    // UI
    
    var textFieldSelected : Int = 0
    
    var top_y_coord : CGFloat = Constants.createRepeatableVC_starting_checkboxes_y_coord
    var labelsToAdd : [UILabel] = [UILabel]()
    var checkboxesToAdd : [CheckboxButton] = [CheckboxButton]()
    
    // View Model
    
    var viewModel = CreateRepeatableTaskOccurrenceViewModel()
    
    // Model values
    
    /*var _timeOfDay : Float?
    var _dayOfWeek : DayOfWeek?
    var daysOfWeek : [DayOfWeek]?
    var startHours : String?
    var date : NSDate?*/
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !viewModel.validRepeatableSubmitted {
            if let rootVC = self.navigationController?.viewControllers[0] as? AllTasksIndividualTaskViewController {
                rootVC.viewModel.resetModel()
            } else if let rootVC = self.navigationController?.viewControllers[0] as? CreateTaskViewController {
                rootVC.viewModel.resetModel()
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
    
    // Text Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }*/
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textFieldSelected = textField.tag
        switch textField.tag {
        case 0:
            addPickerViewDoneButton()
            return true
        case 1:
            return true
        case 2:
            addPickerViewDoneButton()
            return true
        case 3:
            addPickerViewDoneButton()
            return true
        case 4:
            addPickerViewDoneButton()
            return true
        default:
            print("Invalid text field tag")
            return false
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textFieldSelected == 1 {
            self.navigationItem.rightBarButtonItem = nil
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textFieldSelected = textField.tag
        switch textField.tag {
        case 0:
            return true
        case 1:
            if let check = Int((textField.text! as NSString).replacingCharacters(in: range, with: string)) {
                viewModel.numberOfUnits = check
            } else {
                viewModel.numberOfUnits = 0
            }
            return true
        case 2:
            return true
        case 3:
            return true
        case 4:
            
            return true
        case 5:
            return true
        default:
            print("Invalid text field tag")
            return false
        }
    }
    
    // Picker view UI updates
    
    func addPickerViewDoneButton() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(dismissPickerView))
        self.navigationItem.rightBarButtonItem = doneButton
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
        self.navigationItem.rightBarButtonItem = nil
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
        viewModel._timeOfDay = floatToPass
    }
    
    // DayOfWeekPickerDelegateViewDelegate
    
    func handleDidSelect(day : String, enumValue : DayOfWeek?) {
        self.dayOfWeek_txtField.text = day
        viewModel._dayOfWeek = enumValue
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
        if unit == Constants.timeOfDay_weekly_value {
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
    
    func validateForSubmit() -> Bool {
        if unitOfTime_txtField.text == "" {
            let alertController = UIAlertController(title: Constants.standard_alert_error_title, message: Constants.createRepeatableVC_alert_no_unitOfTime_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        if unitsPerTask_txtField.text! == "" {
            let alertController = UIAlertController(title: Constants.standard_alert_error_title, message: Constants.createRepeatableVC_alert_nonnumeric_numberOfUnits_value_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        if(firstDate_txtField.text! == "" || firstTimeOfDay_txtField.text! == "" || (unitOfTime_txtField.text == Constants.timeOfDay_weekly_value && dayOfWeek_txtField.text! == "")) {
            let alertController = UIAlertController(title: Constants.standard_alert_error_title, message: Constants.createRepeatableVC_alert_missing_data_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    func unwindToTaskCreate() {
        if let rootVC = self.navigationController?.viewControllers[Constants.main_storyboard_create_tasks_VC_index] as? CreateTaskViewController {
            if viewModel.multipleRepeatables!.count > 1 {
                rootVC.viewModel.multipleRepeatables = viewModel.multipleRepeatables!
            } else {
                rootVC.viewModel.RepeatableTask = viewModel.multipleRepeatables![0]
            }
            
            rootVC.viewModel.StartTime = viewModel.date
            
            self.navigationController?.popToViewController(rootVC, animated: true)
        } else if let rootVC = self.navigationController?.viewControllers[Constants.main_storyboard_create_tasks_VC_index] as? AllTasksIndividualTaskViewController {
            if viewModel.multipleRepeatables!.count > 1 {
                rootVC.viewModel.multipleRepeatables = viewModel.multipleRepeatables!
            } else {
                rootVC.viewModel.RepeatableTask = viewModel.multipleRepeatables![0]
            }
            
            rootVC.viewModel.StartTime = viewModel.date
            
            self.navigationController?.popToViewController(rootVC, animated: true)
        }
        
    }
    
}
