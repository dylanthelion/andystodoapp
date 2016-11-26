//
//  AllTasksIndividualTaskViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/4/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private var taskHandle : UInt8 = 0
private var timecatHandle : UInt8 = 0

class AllTasksIndividualTaskViewController : CreateTaskParentViewController, UITextFieldDelegate, UITextViewDelegate, DatePickerViewDelegateViewDelegate, TimePickerViewDelegateViewDelegate, TimecatPickerDelegateViewDelegate, ExpectedUnitOfTimePickerDelegateViewDelegate {
    
    // View Model
    
    let viewModel = AllTasksIndividualTaskViewModel()
    
    // Outlets
    
    @IBOutlet weak var repeatable_lbl: UILabel!
    @IBOutlet weak var name_txtField: UITextField!
    @IBOutlet weak var start_txtField: UITextField!
    @IBOutlet weak var repeatable_btn: CheckboxButton!
    @IBOutlet weak var timeCat_txtField: UITextField!
    @IBOutlet weak var description_txtView: BorderedTextView!
    @IBOutlet weak var startDateTextView: UITextField!
    @IBOutlet weak var generateNewTask_btn: UIButton!
    @IBOutlet weak var expectedTotalUnits_txtField: UITextField!
    @IBOutlet weak var expectedUnitOfTime_txtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerDelegation()
        setupTextFieldInput()
        populateTaskInfo()
        timecatDTOBond.bind(dynamic: viewModel.AllTimeCategories!)
        taskDTOBond.bind(dynamic: viewModel.task!)
    }
    
    // Binding
    
    var timecatDTOBond: Bond<[TimeCategory]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &timecatHandle) as AnyObject? {
            return b as! Bond<[TimeCategory]>
        } else {
            let b = Bond<[TimeCategory]>() { [unowned self] v in
                //print("Update timecats in view")
                DispatchQueue.main.async {
                    self.timeCatPickerView.reloadAllComponents()
                }
                
            }
            objc_setAssociatedObject(self, &timecatHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    var taskDTOBond: Bond<Task> {
        if let b: AnyObject = objc_getAssociatedObject(self, &taskHandle) as AnyObject? {
            return b as! Bond<Task>
        } else {
            let b = Bond<Task>() { [unowned self] v in
                //print("Update task in view")
                DispatchQueue.main.async {
                    self.populateTaskInfo()
                }
            }
            objc_setAssociatedObject(self, &taskHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // View setup
    
    func setupPickerDelegation() {
        timeCatDelegate = TimecatPickerDelegate(_categories: viewModel.AllTimeCategories!.value, _delegate: self)
        timeCatPickerDataSource = TimecatPickerDataSource(_categories: viewModel.AllTimeCategories!.value)
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
    
    func setupTextFieldInput() {
        start_txtField.inputView = pickerView
        timeCat_txtField.inputView = timeCatPickerView
        startDateTextView.inputView = datePickerView
        expectedUnitOfTime_txtField.inputView = expectedUnitOfTimePickerView
    }
    
    func setupRepeatable() {
        viewModel.setup()
        self.repeatable_btn.isUserInteractionEnabled = false
        if viewModel.task!.value.isRepeatable() {
            resetRepeatableTextFields()
            self.generateNewTask_btn.setTitle(Constants.allTasksIndividualTaskVC_btn_title_child_task, for: .normal)
            self.repeatable_btn.setImage(UIImage(named: Constants.img_checkbox_checked), for: .normal)
        } else {
            self.startDateTextView.text = TimeConverter.dateToShortDateConverter(_time: viewModel.task!.value.StartTime!)
            self.start_txtField.text = TimeConverter.dateToTimeWithMeridianConverter(_time: viewModel.task!.value.StartTime!)
            self.repeatable_lbl.isHidden = true
            self.repeatable_btn.isHidden = true
            self.generateNewTask_btn.setTitle(Constants.allTasksIndividualTaskVC_btn_title_temp_copy, for: .normal)
        }
        if let _ = viewModel.task!.value.TimeCategory {
            self.timeCat_txtField.text = viewModel.task!.value.TimeCategory!.Name!
        } else {
            self.timeCat_txtField.text = ""
        }
        if let _ = viewModel.task!.value.expectedTimeRequirement {
            self.expectedUnitOfTime_txtField.text = "\(Constants.expectedUnitsOfTimeAsString[Constants.expectedUnitOfTime_All.index(of: viewModel.task!.value.expectedTimeRequirement!.0)!])"
            self.expectedTotalUnits_txtField.text = String(viewModel.task!.value.expectedTimeRequirement!.1)
        }
    }
    
    func resetRepeatableTextFields() {
        start_txtField.text! = Constants.createTaskVC_repeatable
        startDateTextView.text! = Constants.createTaskVC_repeatable
    }
    
    func populateTaskInfo() {
        setupRepeatable()
        populateNonRepeatableData()
    }
    
    func populateNonRepeatableData() {
        self.name_txtField.text = viewModel.task!.value.Name!
        self.description_txtView.text = viewModel.task!.value.Description!
        if let _ = viewModel.task?.value.TimeCategory?.color {
            self.view.backgroundColor = UIColor(cgColor: viewModel.task!.value.TimeCategory!.color!)
        } else {
            self.view.backgroundColor = UIColor.white
        }
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
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textFieldSelected == 0 || textFieldSelected == 4 {
            self.navigationItem.rightBarButtonItem = nil
        }
        return true
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
        if let _ = viewModel.expectedTimeRequirement {
            viewModel.expectedTimeRequirement = (unit, viewModel.expectedTimeRequirement!.1)
        }
        expectedUnitOfTime_txtField.text = text
    }
    
    // IBActions
    
    
    @IBAction func toggleRepeatable(_ sender: AnyObject) {
        
    }
    
    @IBAction func modifyCategories(_ sender: AnyObject) {
        let modifyVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_add_category_VC_id) as! AddCategoriesViewController
        modifyVC.viewModel.selectedCategories = Dynamic(viewModel.AllCategories!.map({ Dynamic($0) }))
        modifyVC.taskDelegate = self
        self.navigationController?.pushViewController(modifyVC, animated: true)
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        
        if !validateForSubmit() {
            return
        }
        
        if viewModel.task!.value.isRepeatable() && !validateRepeatableChildforSubmit() {
            return
        }
        let check = viewModel.submit()
        AlertHelper.PresentAlertController(sender: self, title: check.1, message: check.2, actions: [Constants.standard_ok_alert_action])
        if check.0 {
            // handle success
            if viewModel.task!.value.isRepeatable() {
                resetRepeatableTextFields()
            }
        } else {
            // handle failure
        }
    }
    
    
    @IBAction func generateNewTask(_ sender: AnyObject) {
        if !validateForSubmit() {
            return
        }
        let check = viewModel.generateNewTask()
        AlertHelper.PresentAlertController(sender: self, title: check.1, message: check.2, actions: [Constants.standard_ok_alert_action])
        if check.0 {
            // handle success
            if viewModel.task!.value.isRepeatable() {
                resetRepeatableTextFields()
            }
        } else {
            // handle failure
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
        
        if !viewModel.task!.value.isRepeatable() && (startDateTextView.text! == Constants.createTaskVC_repeatable || start_txtField.text! == Constants.createTaskVC_repeatable) {
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
}
