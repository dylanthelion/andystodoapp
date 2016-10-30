//
//  CreateRepeatableTaskOccurrenceViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/23/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateRepeatableTaskOccurrenceViewController : UIViewController, TaskDTODelegate, UITextFieldDelegate,  DatePickerViewDelegateViewDelegate, TimePickerViewDelegateViewDelegate, DayOfWeekPickerDelegateViewDelegate, UnitOfTimePickerDelegateViewDelegate {
    
    // UI
    
    var textFieldSelected : Int = 0
        
    // Model values
    
    var _timeOfDay : Float?
    var _dayOfWeek : DayOfWeek?
    var startMonth : String?
    var startDay : String?
    var startHours : String?
    var date : NSDate?
    
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
        setupTextFieldDelegation()
        setupTextFieldInput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    // View setup
    
    func setupTextFieldDelegation() {
        unitOfTime_txtField.delegate = self
        unitsPerTask_txtField.delegate = self
        firstTimeOfDay_txtField.delegate = self
        firstDate_txtField.delegate = self
        dayOfWeek_txtField.delegate = self
    }
    
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
    
    // TaskDTODelegate
    
    func handleModelUpdate() {
        
    }
    
    func taskDidUpdate(_task: Task) {
        
    }
    
    // Text Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
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
        startMonth = months
        startDay = days
        firstDate_txtField.text = fulldate
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
        startHours = fullTime
        _timeOfDay = floatToPass
    }
    
    // DayOfWeekPickerDelegateViewDelegate
    
    func handleDidSelect(day : String, enumValue : DayOfWeek) {
        self.dayOfWeek_txtField.text = day
        self._dayOfWeek = enumValue
    }
    
    // UnitOfTimePickerDelegateViewDelegate
    
    func handleDidSelect(unit : String) {
        unitOfTime_txtField.text = unit
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
    
    @IBAction func submit(_ sender: AnyObject) {
        if !validateForSubmit() {
            return
        }
        let repeatable = createRepeatable()
        if repeatable == nil {
            return
        }
        if(!repeatable!.isValid()) {
            
            let alertController = UIAlertController(title: Constants.standard_alert_error_title, message: Constants.createRepeatableVC_alert_invalid_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        unwindToTaskCreate(date: date!, repeatable: repeatable!)
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
    
    func createRepeatable() -> RepeatableTaskOccurrence? {
        var _unitOfTime : RepetitionTimeCategory?
        
        switch unitOfTime_txtField.text! {
        case Constants.timeOfDay_hourly_value:
            _unitOfTime = .Hourly
        case Constants.timeOfDay_daily_value:
            _unitOfTime = .Daily
        case Constants.timeOfDay_weekly_value:
            _unitOfTime = .Weekly
        default:
            _unitOfTime = nil
        }
        let _numberOfUnits : Int? = Int(unitsPerTask_txtField.text!)
        if _numberOfUnits == nil {
            let alertController = UIAlertController(title: Constants.standard_alert_error_title, message: Constants.createRepeatableVC_alert_nonnumeric_numberOfUnits_value_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return nil
        }
        
        let formatter = StandardDateFormatter()
        let year = formatter.getNextMonthOccurrence(startMonth: startMonth!, startDay: startDay!)
        //print("\(startMonth!) \(startDay!) \(startHours!) \(year)")
        date = formatter.date(from: "\(startMonth!) \(startDay!) \(startHours!) \(year)")! as NSDate
        let repeatable = RepeatableTaskOccurrence(_unit: _unitOfTime!, _unitCount: _numberOfUnits!, _time: _timeOfDay, _firstOccurrence: date, _dayOfWeek: self._dayOfWeek)
        return repeatable
    }
    
    func unwindToTaskCreate(date : NSDate, repeatable : RepeatableTaskOccurrence) {
        let rootVC = self.navigationController?.viewControllers[Constants.main_storyboard_create_tasks_VC_index] as! CreateTaskViewController
        rootVC.repeatableDetails = repeatable
        rootVC.startTime = date
        rootVC.startDateTextView.text = Constants.createRepeatableVC_repeatable
        rootVC.start_txtField.text = Constants.createRepeatableVC_repeatable
        self.navigationController?.popToViewController(rootVC, animated: true)
    }
    
}
