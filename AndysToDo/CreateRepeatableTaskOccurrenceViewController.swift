//
//  CreateRepeatableTaskOccurrenceViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/23/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateRepeatableTaskOccurrenceViewController : UIViewController, TaskDTODelegate, UITextFieldDelegate,  DatePickerViewDelegateViewDelegate, TimePickerViewDelegateViewDelegate, DayOfWeekPickerDelegateViewDelegate, UnitOfTimePickerDelegateViewDelegate {
    
    // DatePickerViewDelegateViewDelegate
    
    var startMonth: String?
    var startDay: String?
    
    // UI
    
    var textFieldSelected : Int = 0
    var validRepeatableSubmitted = false
    var top_y_coord : CGFloat = Constants.createRepeatableVC_starting_checkboxes_y_coord
    var labelsToAdd : [UILabel] = [UILabel]()
    var checkboxesToAdd : [CheckboxButton] = [CheckboxButton]()
    
    // Model values
    
    var _timeOfDay : Float?
    var _dayOfWeek : DayOfWeek?
    var daysOfWeek : [DayOfWeek]?
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
        setupTextFieldInput()
        daysOfWeek = [DayOfWeek]()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !validRepeatableSubmitted {
            let rootVC = self.navigationController?.viewControllers[0] as! CreateTaskParentViewController
            rootVC.repeatableDetails = nil
            rootVC.multipleRepeatables = nil
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
    
    func handleDidSelect(day : String, enumValue : DayOfWeek?) {
        self.dayOfWeek_txtField.text = day
        if let _ = enumValue {
            self._dayOfWeek = enumValue
            if !CollectionHelper.IsNilOrEmpty(_coll: labelsToAdd) {
                removeCheckboxesFromView()
                self.daysOfWeek?.removeAll()
            }
        } else {
            addDayOfWeekCheckBoxes()
        }
        
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
    
    // Day of week checkboxes
    
    func toggleDidSelectDate(sender: CheckboxButton) {
        if sender.checked {
            let index = self.daysOfWeek!.index(of: Constants.dayOfWeek_all[sender.tag])!
            self.daysOfWeek!.remove(at: index)
        } else {
            self.daysOfWeek!.append(Constants.dayOfWeek_all[sender.tag])
        }
        
        sender.toggleChecked()
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        if !validateForSubmit() {
            return
        }
        let repeatables = createRepeatable()
        if CollectionHelper.IsNilOrEmpty(_coll: repeatables) {
            return
        }
        var areValid = true
        for repeatable in repeatables! {
            if(!repeatable.isValid()) {
                areValid = false
                break
            }
        }
        if !areValid {
            let alertController = UIAlertController(title: Constants.standard_alert_error_title, message: Constants.createRepeatableVC_alert_invalid_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        validRepeatableSubmitted = true
        unwindToTaskCreate(date: date!, repeatable: repeatables!)
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
    
    func createRepeatable() -> [RepeatableTaskOccurrence]? {
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
        let taskDate = formatter.date(from: "\(startMonth!) \(startDay!) \(startHours!) \(year)")! as NSDate
        if self.dayOfWeek_txtField.text! == Constants.days_of_week_as_strings[7] {
            let dayOfWeek = Int(Calendar(identifier: .gregorian).component(.weekday, from: taskDate as Date)) - 1
            var repeatablesToReturn = [RepeatableTaskOccurrence]()
            for _checkbox in checkboxesToAdd {
                if _checkbox.checked {
                    let daysToAdd = abs(_checkbox.tag - dayOfWeek) * Constants.seconds_per_day
                    if self.date == nil {
                        self.date = taskDate.addingTimeInterval(TimeInterval(daysToAdd))
                    }
                    let newRepeatable = RepeatableTaskOccurrence(_unit: _unitOfTime!, _unitCount: _numberOfUnits!, _time: _timeOfDay, _firstOccurrence: taskDate.addingTimeInterval(TimeInterval(daysToAdd)) , _dayOfWeek: Constants.dayOfWeek_all[_checkbox.tag])
                    repeatablesToReturn.append(newRepeatable)
                }
            }
            return repeatablesToReturn
        } else {
            let repeatable = RepeatableTaskOccurrence(_unit: _unitOfTime!, _unitCount: _numberOfUnits!, _time: _timeOfDay, _firstOccurrence: taskDate, _dayOfWeek: self._dayOfWeek)
            self.date = taskDate
            return [repeatable]
        }
        
    }
    
    func unwindToTaskCreate(date : NSDate, repeatable : [RepeatableTaskOccurrence]) {
        let rootVC = self.navigationController?.viewControllers[Constants.main_storyboard_create_tasks_VC_index] as! CreateTaskParentViewController
        if repeatable.count > 1 {
            rootVC.multipleRepeatables = repeatable
        } else {
            rootVC.repeatableDetails = repeatable[0]
        }
        
        rootVC.startTime = date
        
        self.navigationController?.popToViewController(rootVC, animated: true)
    }
    
}
