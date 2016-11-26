//
//  CreateTaskViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/22/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateTaskViewController: CreateTaskParentViewController, UITextFieldDelegate, UITextViewDelegate, DatePickerViewDelegateViewDelegate, TimePickerViewDelegateViewDelegate, TimecatPickerDelegateViewDelegate, ExpectedUnitOfTimePickerDelegateViewDelegate {
    
    // View Model
    
    let viewModel = CreateTaskViewModel()
    
    // Outlets
    
    @IBOutlet weak var name_txtField: UITextField!
    @IBOutlet weak var start_txtField: UITextField!
    @IBOutlet weak var repeatable_btn: CheckboxButton!
    @IBOutlet weak var timeCat_txtField: UITextField!
    @IBOutlet weak var description_txtView: BorderedTextView!
    @IBOutlet weak var startDateTextView: UITextField!
    @IBOutlet weak var expectedTotalUnits_txtField: UITextField!
    @IBOutlet weak var expectedUnitOfTime_txtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerDelegation()
        setStartingDate()
        setupTextFieldInput()
        populateTask()
        //loaded = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if viewModel.RepeatableTask != nil || !CollectionHelper.IsNilOrEmpty(_coll: viewModel.multipleRepeatables) {
            self.startDateTextView.text = Constants.createRepeatableVC_repeatable
            self.start_txtField.text = Constants.createRepeatableVC_repeatable
        }
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // View setup
    
    func populateTask() {
        if viewModel.RepeatableTask == nil && CollectionHelper.IsNilOrEmpty(_coll: viewModel.multipleRepeatables) {
            repeatable_btn.setImage(UIImage(named: Constants.img_checkbox_unchecked), for: .normal)
            repeatable_btn.checked = false
            viewModel.repeatable = false
        } else {
            self.startDateTextView.text = Constants.createRepeatableVC_repeatable
            self.start_txtField.text = Constants.createRepeatableVC_repeatable
            self.startDateTextView.isUserInteractionEnabled = false
            self.start_txtField.isUserInteractionEnabled = false
        }
    }
    
    func setupPickerDelegation() {
        timeCatDelegate = TimecatPickerDelegate(_categories: viewModel.AllTimeCategories, _delegate: self)
        timeCatPickerDataSource = TimecatPickerDataSource(_categories: viewModel.AllTimeCategories)
        timePickerDelegate = TimePickerViewDelegate(_delegate: self)
        expectedPickerDelegate = ExpectedUnitOfTimePickerDelegate(_delegate: self)
        expectedUnitOfTimePickerView.delegate = expectedPickerDelegate
        expectedUnitOfTimePickerView.dataSource = expectedPickerDataSource
        pickerView.delegate = timePickerDelegate!
        pickerView.dataSource = timePickerDataSource
        timeCatPickerView.dataSource = timeCatPickerDataSource
        timeCatPickerView.delegate = timeCatDelegate!
        datePickerDelegate = DatePickerViewDelegate(_delegate: self)
        datePickerView.delegate = datePickerDelegate
        datePickerView.dataSource = datePickerDataSource
    }
    
    func setStartingDate() {
        let date = CalendarHelper.shortDateAsInt
        datePickerView.selectRow(date.0 - 1, inComponent: 0, animated: true)
        datePickerView.selectRow(date.1 - 1, inComponent: 1, animated: true)
        self.startDateTextView.text = TimeConverter.dateToShortDateConverter(_time: NSDate())
        viewModel.startDay = Constants.all_days_as_strings[date.1 - 1]
        viewModel.startMonth = Constants.all_months_as_strings[date.0 - 1]
    }
    
    func setupTextFieldInput() {
        start_txtField.inputView = pickerView
        timeCat_txtField.inputView = timeCatPickerView
        startDateTextView.inputView = datePickerView
        expectedUnitOfTime_txtField.inputView = expectedUnitOfTimePickerView
    }
    
    func resetAfterSuccessfulSubmit() {
        DispatchQueue.main.async {
            if self.repeatable_btn.checked {
                self.repeatable_btn.toggleChecked()
            }
            self.start_txtField.isUserInteractionEnabled = true
            self.startDateTextView.isUserInteractionEnabled = true
            self.name_txtField.text = ""
            self.start_txtField.text = ""
            self.description_txtView.text = ""
            self.timeCat_txtField.text = ""
            self.startDateTextView.text = ""
            self.expectedUnitOfTime_txtField.text = ""
            self.expectedTotalUnits_txtField.text = ""
            self.setStartingDate()
        }
        viewModel.resetModel()
    }
    
    // Text Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        viewModel.Description = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textFieldSelected = 0
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textFieldSelected = textField.tag
        switch textField.tag {
        case 0:
            return true
        case 1:
            addPickerViewDoneButton()
            return true
        case 2:
            addPickerViewDoneButton()
            return true
        case 3:
            addPickerViewDoneButton()
            return true
        case 4:
            return true
        case 5:
            addPickerViewDoneButton()
            return true
        default:
            print("Invalid text field tag")
            return false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textFieldSelected = textField.tag
        switch textField.tag {
        case 0:
            viewModel.Name = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            return true
        case 1:
            return true
        case 2:
            return true
        case 3:
            return true
        case 4:
            if let check = Int((textField.text! as NSString).replacingCharacters(in: range, with: string)) {
                viewModel.updateExpectedTimeRequirement(newUnitOfTime: nil, newValue: check)
            } else {
                viewModel.updateExpectedTimeRequirement(newUnitOfTime: nil, newValue: 0)
            }
            return true
        case 5:
            return true
        default:
            print("Invalid text field tag")
            return false
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textFieldSelected == 0 || textFieldSelected == 4 {
            self.navigationItem.rightBarButtonItem = nil
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textFieldSelected == 0 {
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
            print("Do nothing")
        case 1:
            start_txtField.resignFirstResponder()
        case 2:
            timeCat_txtField.resignFirstResponder()
        case 3:
            startDateTextView.resignFirstResponder()
        case 4:
            print("Do nothing")
        case 5:
            expectedUnitOfTime_txtField.resignFirstResponder()
        default:
            print("Invalid text field tag assigned")
        }
        self.navigationItem.rightBarButtonItem = nil
    }
    
    // DatePickerViewDelegateViewDelegate
    
    func handleDidSelect(months: String, days: String, fulldate: String) {
        viewModel.startMonth = months
        viewModel.startDay = days
        startDateTextView.text = fulldate
    }
    
    // TimePickerViewDelegateViewDelegate
    
    func handleDidSelect(hours: String, minutes: String, meridian: String, fullTime: String) {
        start_txtField.text = fullTime
        viewModel.startHours = fullTime
    }
    
    // TimecatPickerDelegateViewDelegate
    
    func handleDidSelect(timecat : TimeCategory, name : String) {
        viewModel.TimeCategory = timecat
        self.timeCat_txtField.text = name
    }
    
    // ExpectedUnitOfTimePickerDelegateViewDelegate
    
    func handleDidSelect(unit: UnitOfTime, text: String) {
        viewModel.expectedTimeRequirement = (unit, viewModel.expectedTimeRequirement!.1)
        expectedUnitOfTime_txtField.text = text
    }
    
    // IBActions
    
    
    @IBAction func toggleRepeatable(_ sender: AnyObject) {
        repeatable_btn.toggleChecked()
        switch viewModel.repeatable {
        case true:
            viewModel.RepeatableTask = nil
            viewModel.repeatable = false
            DispatchQueue.main.async {
                self.start_txtField.text = ""
                self.startDateTextView.text = ""
            }
        case false:
            let nextViewController = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.create_repeatable_task_VC_id) as! CreateRepeatableTaskOccurrenceViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            viewModel.repeatable = true
        }
    }
    
    @IBAction func modifyCategories(_ sender: AnyObject) {
        let modifyVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_add_category_VC_id) as! AddCategoriesViewController
        modifyVC.viewModel.selectedCategories = Dynamic(self.viewModel.Categories!.map({ Dynamic($0) }))
        modifyVC.taskDelegate = self
        self.navigationController?.pushViewController(modifyVC, animated: true)
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        
        if !validateForSubmit() {
            return
        }
        
        let check = viewModel.submit()
        AlertHelper.PresentAlertController(sender: self, title: check.1, message: check.2, actions: [Constants.standard_ok_alert_action])
        if !check.0 {
            // handle failure
        } else {
            resetAfterSuccessfulSubmit()
            // handle success
        }
    }
    
    // Validation
    
    func validateForSubmit() -> Bool {
        
        if name_txtField.text! == "" || description_txtView.text == "" || start_txtField.text! == "" && startDateTextView.text! == "" {
            AlertHelper.PresentAlertController(sender: self, title: Constants.standard_alert_fail_title, message: Constants.createTaskVC_alert_no_name_description_or_time_failure_message, actions: [Constants.standard_ok_alert_action])
            return false
        }
        
        if !viewModel.repeatable && (startDateTextView.text! == Constants.createTaskVC_repeatable || start_txtField.text! == Constants.createTaskVC_repeatable) {
            AlertHelper.PresentAlertController(sender: self, title: Constants.standard_alert_fail_title, message: Constants.createTaskVC_alert_invalid_repeatables_failure_message, actions: [Constants.standard_ok_alert_action])
            return false
        }
        return true
    }
    
    /*func validateRepeatable(_repeatable : RepeatableTaskOccurrence) -> Bool {
        let task = Task(_name: name_txtField.text!, _description: description_txtView.text, _start: _repeatable.FirstOccurrence! as NSDate? , _finish: nil, _category: viewModel.AllCategories, _timeCategory: viewModel.TimeCategory, _repeatable: _repeatable, _dueDate: nil, _parent: nil, _expectedUnitOfTime: viewModel.expectedTimeRequirement!.0, _expectedTotalUnits: Int(expectedTotalUnits_txtField.text!))
        if TaskDTO.globalManager.createNewTask(_task: task) {
            let alertController = UIAlertController(title: Constants.standard_alert_ok_title, message: Constants.createTaskVC_alert_success_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            resetAfterSuccessfulSubmit()
            return true
        } else {
            let alertController = UIAlertController(title: Constants.standard_alert_fail_title, message: Constants.createTaskVC_alert_invalid_repeatable_information_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
    }
    
    func validateMultipleRepeatables(_repeatables : [RepeatableTaskOccurrence]) -> Bool {
        var newTasks = [Task]()
        var areValid = true
        for (index, _repeatable) in _repeatables.enumerated() {
            let task = Task(_name: name_txtField.text!, _description: description_txtView.text, _start: _repeatable.FirstOccurrence!, _finish: nil, _category: viewModel.AllCategories, _timeCategory: viewModel.TimeCategory, _repeatable: _repeatable, _dueDate: nil, _parent: nil, _expectedUnitOfTime: viewModel.expectedTimeRequirement!.0, _expectedTotalUnits: Int(expectedTotalUnits_txtField.text!))
            if !task.isValidWithoutId() {
                areValid = false
                break
            }
            newTasks.append(task)
            if index != 0 {
                newTasks[0].siblingRepeatables!.append(task)
            }
        }
        
        if areValid {
            for _task in newTasks {
                let _ = TaskDTO.globalManager.createNewTask(_task: _task)
            }
            let alertController = UIAlertController(title: Constants.standard_alert_ok_title, message: Constants.createTaskVC_alert_success_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            resetAfterSuccessfulSubmit()
            return true
        } else {
            let alertController = UIAlertController(title: Constants.standard_alert_fail_title, message: Constants.createTaskVC_alert_invalid_repeatable_information_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
    }
    
    func validateNonRepeatableTask() -> Bool {
        let formatter = StandardDateFormatter()
        let df = DateFormatter()
        df.dateFormat = Constants.standard_month_format
        let year : String = formatter.getNextMonthOccurrence(startMonth: viewModel.startMonth!, startDay: viewModel.startDay!)
        let date = formatter.date(from: "\(viewModel.startMonth!) \(viewModel.startDay!) \(viewModel.startHours!) \(year)")! as NSDate
        let task = Task(_name: name_txtField.text!, _description: description_txtView.text, _start: date, _finish: nil, _category: viewModel.AllCategories, _timeCategory: viewModel.TimeCategory
            , _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: viewModel.expectedTimeRequirement!.0, _expectedTotalUnits: Int(expectedTotalUnits_txtField.text!))
        if TaskDTO.globalManager.createNewTask(_task: task) {
            let alertController = UIAlertController(title: Constants.standard_alert_ok_title, message: Constants.createTaskVC_alert_success_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            resetAfterSuccessfulSubmit()
            return true
        } else {
            let alertController = UIAlertController(title: Constants.standard_alert_fail_title, message: Constants.createTaskVC_alert_invalid_nonrepeatable_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
    }*/
    
}
