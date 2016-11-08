//
//  AllTasksIndividualTaskViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/4/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class AllTasksIndividualTaskViewController : CreateTaskParentViewController, UITextFieldDelegate, UITextViewDelegate, DatePickerViewDelegateViewDelegate, TimePickerViewDelegateViewDelegate, TimecatPickerDelegateViewDelegate {
    
    // Model values
    
    var task : Task?
    
    // Outlets
    
    @IBOutlet weak var repeatable_lbl: UILabel!
    @IBOutlet weak var name_txtField: UITextField!
    @IBOutlet weak var start_txtField: UITextField!
    @IBOutlet weak var repeatable_btn: CheckboxButton!
    @IBOutlet weak var timeCat_txtField: UITextField!
    @IBOutlet weak var description_txtView: UITextView!
    @IBOutlet weak var startDateTextView: UITextField!
    @IBOutlet weak var generateNewTask_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerDelegation()
        setupTextFieldDelegation()
        setupTextFieldInput()
        addTextViewBorder()
        populateTaskInfo()
    }
    
    // View setup
    
    func setupTextFieldDelegation(){
        name_txtField.delegate = self
        start_txtField.delegate = self
        timeCat_txtField.delegate = self
        description_txtView.delegate = self
        startDateTextView.delegate = self
    }
    
    func setupPickerDelegation() {
        timeCatDelegate = TimecatPickerDelegate(_categories: allTimeCategories!, _delegate: self)
        timeCatPickerDataSource = TimecatPickerDataSource(_categories: allTimeCategories!)
        timePickerDelegate = TimePickerViewDelegate(_delegate: self)
        pickerView.delegate = timePickerDelegate!
        pickerView.dataSource = timePickerDataSource
        timeCatPickerView.dataSource = timeCatPickerDataSource
        timeCatPickerView.delegate = timeCatDelegate!
        datePickerDelegate = DatePickerViewDelegate(_delegate: self)
        datePickerView.delegate = datePickerDelegate
        datePickerView.dataSource = datePickerDataSource
    }
    
    func setupTextFieldInput() {
        start_txtField.inputView = pickerView
        timeCat_txtField.inputView = timeCatPickerView
        startDateTextView.inputView = datePickerView
    }
    
    func addTextViewBorder() {
        description_txtView.layer.borderWidth = Constants.text_view_border_width
        description_txtView.layer.borderColor = Constants.text_view_border_color
    }
    
    func setupRepeatable() {
        self.repeatable_btn.isUserInteractionEnabled = false
        if self.task!.isRepeatable() {
            start_txtField.text! = Constants.createTaskVC_repeatable
            startDateTextView.text! = Constants.createTaskVC_repeatable
            repeatable = true
            self.repeatableDetails = task?.RepeatableTask
            self.generateNewTask_btn.setTitle(Constants.allTasksIndividualTaskVC_btn_title_child_task, for: .normal)
            self.repeatable_btn.setImage(UIImage(named: Constants.img_checkbox_checked), for: .normal)
        } else {
            self.startDateTextView.text = TimeConverter.dateToShortDateConverter(_time: task!.StartTime!)
            self.start_txtField.text = TimeConverter.dateToTimeWithMeridianConverter(_time: task!.StartTime!)
            self.repeatable_lbl.isHidden = true
            self.repeatable_btn.isHidden = true
            self.generateNewTask_btn.setTitle(Constants.allTasksIndividualTaskVC_btn_title_temp_copy, for: .normal)
        }
        self.startTime = task?.StartTime
        self.allCategories = task?.Categories
        self.chosenTimeCategory = task?.TimeCategory
    }
    
    func populateTaskInfo() {
        if task == nil {
            print("No task")
            return
        }
        setupRepeatable()
        self.name_txtField.text = task!.Name!
        self.startHours = TimeConverter.dateToTimeWithMeridianConverter(_time: task!.StartTime!)
        
        self.startMonth = TimeConverter.dateToMonthConverter(_time: task!.StartTime!)
        self.startDay = TimeConverter.dateToDateOfMonthConverter(_time: task!.StartTime!)
        self.description_txtView.text = task!.Description!
        if let _ = task?.Categories {
            allCategories = task!.Categories!
        }
        if let _ = task?.TimeCategory {
            chosenTimeCategory = task!.TimeCategory!
            if let _ = task?.TimeCategory?.color {
                self.view.backgroundColor = UIColor(cgColor: task!.TimeCategory!.color!)
            }
        }
        
    }
    
    func resetAfterSuccessfulSubmit() {
        DispatchQueue.main.async {
            self.name_txtField.text = self.task!.Name!
            
            self.description_txtView.text = self.task!.Description!
            if !self.repeatable {
                self.startDateTextView.text = TimeConverter.dateToShortDateConverter(_time: self.startTime!)
                self.start_txtField.text = TimeConverter.dateToTimeConverter(_time: self.startTime!)
            } else {
                self.startDateTextView.text = Constants.createTaskVC_repeatable
                self.start_txtField.text = Constants.createTaskVC_repeatable
            }
            self.timeCat_txtField.text = ""
            
        }
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
        default:
            print("Invalid text field tag")
            return false
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textFieldSelected == 0 {
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
        default:
            print("Invalid text field tag assigned")
        }
        self.navigationItem.rightBarButtonItem = nil
    }
    
    // DatePickerViewDelegateViewDelegate
    
    func handleDidSelect(months: String, days: String, fulldate: String) {
        startMonth = months
        startDay = days
        startDateTextView.text = fulldate
    }
    
    // TimePickerViewDelegateViewDelegate
    
    func handleDidSelect(hours: String, minutes: String, meridian: String, fullTime: String) {
        startHours = fullTime
        start_txtField.text = fullTime
    }
    
    // TimecatPickerDelegateViewDelegate
    
    func handleDidSelect(timecat : TimeCategory, name : String) {
        self.chosenTimeCategory = timecat
        self.timeCat_txtField.text = name
    }
    
    // IBActions
    
    
    @IBAction func toggleRepeatable(_ sender: AnyObject) {
        
    }
    
    @IBAction func modifyCategories(_ sender: AnyObject) {
        let modifyVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_add_category_VC_id) as! AddCategoriesViewController
        modifyVC.selectedCategories = self.allCategories
        modifyVC.taskDelegate = self
        self.navigationController?.pushViewController(modifyVC, animated: true)
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        
        if !validateForSubmit() {
            return
        }
        
        if repeatable {
            if !validateRepeatable() {
                return
            } else {
                resetAfterSuccessfulSubmit()
                return
            }
        } else {
            if !validateNonRepeatableTask() {
                return
            } else {
                resetAfterSuccessfulSubmit()
                return
            }
        }
    }
    
    
    @IBAction func generateNewTask(_ sender: AnyObject) {
        if task!.isRepeatable() {
            if validateForSubmit() && validateRepeatableChildforSubmit() {
                if validateNewRepeatableInstance() {
                    resetAfterSuccessfulSubmit()
                    return
                } else {
                    return
                }
            }
        } else {
            if validateForSubmit() {
                if validateNewInstance() {
                    resetAfterSuccessfulSubmit()
                    return
                } else {
                    return
                }
            }
        }
    }
    
    // Validation
    
    func validateForSubmit() -> Bool {
        
        if name_txtField.text! == "" || description_txtView.text == "" || start_txtField.text! == "" && startDateTextView.text! == "" {
            let alertController = UIAlertController(title: Constants.standard_alert_fail_title, message: Constants.createTaskVC_alert_no_name_description_or_time_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        if !repeatable && (startDateTextView.text! == Constants.createTaskVC_repeatable || start_txtField.text! == Constants.createTaskVC_repeatable) {
            let alertController = UIAlertController(title: Constants.standard_alert_fail_title, message: Constants.createTaskVC_alert_invalid_repeatables_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func validateRepeatableChildforSubmit() -> Bool {
        if (startDateTextView.text! == Constants.createTaskVC_repeatable || startDateTextView.text! == "" || start_txtField.text! == Constants.createTaskVC_repeatable || start_txtField.text! == "") {
            let alertController = UIAlertController(title: Constants.standard_alert_fail_title, message: Constants.allTasksIndividualTaskVC_alert_message_missing_child_details, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func validateRepeatable() -> Bool {
        self.task!.Name = name_txtField.text!
        self.task!.Description = description_txtView.text
        self.task!.StartTime = self.startTime
        self.task!.FinishTime = nil
        self.task!.Categories = self.allCategories
        self.task!.TimeCategory = chosenTimeCategory
        self.task!.RepeatableTask = repeatableDetails
        if taskDTO.updateTask(_task: self.task!) {
            let alertController = UIAlertController(title: Constants.standard_alert_ok_title, message: Constants.createTaskVC_alert_success_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
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
        let year : String = formatter.getNextMonthOccurrence(startMonth: startMonth!, startDay: startDay!)
        //print("\(startMonth!) \(startDay!) \(startHours!) \(year)")
        let date = formatter.date(from: "\(startMonth!) \(startDay!) \(startHours!) \(year)")! as NSDate
        self.task!.Name = name_txtField.text!
        self.task!.Description = description_txtView.text
        self.task!.StartTime = date
        self.task!.FinishTime = nil
        self.task!.Categories = self.allCategories
        self.task!.TimeCategory = chosenTimeCategory
        self.task!.RepeatableTask = nil
        if taskDTO.updateTask(_task: self.task!) {
            let alertController = UIAlertController(title: Constants.standard_alert_ok_title, message: Constants.createTaskVC_alert_success_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return true
        } else {
            let alertController = UIAlertController(title: Constants.standard_alert_fail_title, message: Constants.createTaskVC_alert_invalid_nonrepeatable_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
    }
    
    func validateNewInstance() -> Bool {
        let formatter = StandardDateFormatter()
        let df = DateFormatter()
        df.dateFormat = Constants.standard_month_format
        let year : String = formatter.getNextMonthOccurrence(startMonth: startMonth!, startDay: startDay!)
        //print("\(startMonth!) \(startDay!) \(startHours!) \(year)")
        let date = formatter.date(from: "\(startMonth!) \(startDay!) \(startHours!) \(year)")! as NSDate
        let newTask = Task(_name: "Temp \(self.task!.Name!)", _description: self.task!.Description!, _start: date, _finish: nil, _category: self.task!.Categories, _timeCategory: self.task!.TimeCategory, _repeatable: nil)
        newTask.parentID = self.task!.ID!
        if taskDTO.createNewTask(_task: newTask) {
            let alertController = UIAlertController(title: Constants.standard_alert_ok_title, message: Constants.createTaskVC_alert_success_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return true
        } else {
            let alertController = UIAlertController(title: Constants.standard_alert_fail_title, message: Constants.createTaskVC_alert_invalid_nonrepeatable_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
    }
    
    func validateNewRepeatableInstance() -> Bool {
        let formatter = StandardDateFormatter()
        let df = DateFormatter()
        df.dateFormat = Constants.standard_month_format
        let year : String = formatter.getNextMonthOccurrence(startMonth: startMonth!, startDay: startDay!)
        //print("\(startMonth!) \(startDay!) \(startHours!) \(year)")
        let date = formatter.date(from: "\(startMonth!) \(startDay!) \(startHours!) \(year)")! as NSDate
        let newTask = Task(_name: "Temp \(self.task!.Name!) instance", _description: self.task!.Description!, _start: date, _finish: nil, _category: self.task!.Categories, _timeCategory: self.task!.TimeCategory, _repeatable: nil)
        newTask.parentID = self.task!.ID!
        if taskDTO.createNewTempRepeatableTask(_task: newTask) {
            let alertController = UIAlertController(title: Constants.standard_alert_ok_title, message: Constants.createTaskVC_alert_success_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return true
        } else {
            let alertController = UIAlertController(title: Constants.standard_alert_fail_title, message: Constants.createTaskVC_alert_invalid_repeatable_information_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
    }
}
