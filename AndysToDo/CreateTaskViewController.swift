//
//  CreateTaskViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/22/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private var repeatableHandle : UInt8 = 0

class CreateTaskViewController: CreateTaskParentViewController,  DatePickerViewDelegateViewDelegate, TimePickerViewDelegateViewDelegate, TimecatPickerDelegateViewDelegate, ExpectedUnitOfTimePickerDelegateViewDelegate, PickerViewViewDelegate {
    
    // Text Fields
    
    var textFieldDelegate : CreateTaskTextFieldDelegate?
    var textViewDelegate : PickerViewDelegateTextViewDelegate?
    
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
        viewModel = CreateTaskViewModel()
        repeatableBond.bind(dynamic: viewModel!.repeatable)
        setupPickerDelegation()
        setupTextFieldInput()
        datePickerDelegate!.setStartingDate(datePickerView)
        populateTask()
        setupTextFields()
    }
    
    // Binding
    
    var repeatableBond: Bond<Bool> {
        if let b: AnyObject = objc_getAssociatedObject(self, &repeatableHandle) as AnyObject? {
            return b as! Bond<Bool>
        } else {
            let b = Bond<Bool>() { [unowned self] v in
                DispatchQueue.main.async {
                    //print("Update all in view")
                    if self.viewModel!.repeatableTask != nil || !CollectionHelper.IsNilOrEmpty(_coll: self.viewModel!.multipleRepeatables) {
                        self.startDateTextView.text = Constants.createRepeatableVC_repeatable
                        self.start_txtField.text = Constants.createRepeatableVC_repeatable
                        self.startDateTextView.isUserInteractionEnabled = false
                        self.start_txtField.isUserInteractionEnabled = false
                    } else {
                        self.datePickerDelegate!.setStartingDate(self.datePickerView)
                        self.start_txtField.text = ""
                        self.startDateTextView.isUserInteractionEnabled = true
                        self.start_txtField.isUserInteractionEnabled = true
                    }
                }
            }
            objc_setAssociatedObject(self, &repeatableHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // Setup
    
    func populateTask() {
        if viewModel?.repeatableTask == nil && CollectionHelper.IsNilOrEmpty(_coll: viewModel?.multipleRepeatables) {
            repeatable_btn.setImage(UIImage(named: Constants.img_checkbox_unchecked), for: .normal)
            repeatable_btn.checked = false
            viewModel!.repeatable.value = false
        } else {
            self.startDateTextView.text = Constants.createRepeatableVC_repeatable
            self.start_txtField.text = Constants.createRepeatableVC_repeatable
            self.startDateTextView.isUserInteractionEnabled = false
            self.start_txtField.isUserInteractionEnabled = false
        }
    }
    
    func setupPickerDelegation() {
        timeCatDelegate = TimecatPickerDelegate(_categories: viewModel?.allTimeCategories.map({ $0.value }), _delegate: self)
        timeCatPickerDataSource = TimecatPickerDataSource(_categories: viewModel?.allTimeCategories.map({ $0.value }))
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
    
    func setupTextFields() {
        textFieldDelegate = CreateTaskTextFieldDelegate(viewModel: viewModel! as! CreateTaskViewModel, delegate: self)
        name_txtField.delegate = textFieldDelegate
        start_txtField.delegate = textFieldDelegate
        startDateTextView.delegate = textFieldDelegate
        expectedTotalUnits_txtField.delegate = textFieldDelegate
        expectedUnitOfTime_txtField.delegate = textFieldDelegate
        timeCat_txtField.delegate = textFieldDelegate
        textViewDelegate = PickerViewDelegateTextViewDelegate(viewModel: viewModel! as! CreateTaskViewModel, delegate: self)
        description_txtView.delegate = textViewDelegate
    }
    
    // Reset
    
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
            self.datePickerDelegate!.setStartingDate(self.datePickerView)
        }
        viewModel?.resetModel()
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
        case 1:
            start_txtField.resignFirstResponder()
        case 2:
            timeCat_txtField.resignFirstResponder()
        case 3:
            startDateTextView.resignFirstResponder()
        case 5:
            expectedUnitOfTime_txtField.resignFirstResponder()
        default:
            print("Do nothing")
        }
        removePickerViewDoneButton()
    }
    
    // DatePickerViewDelegateViewDelegate
    
    func handleDidSelect(months: String, days: String, fulldate: String) {
        viewModel?.startMonth = months
        viewModel?.startDay = days
        startDateTextView.text = fulldate
    }
    
    // TimePickerViewDelegateViewDelegate
    
    func handleDidSelect(hours: String, minutes: String, meridian: String, fullTime: String) {
        start_txtField.text = fullTime
        viewModel?.startHours = fullTime
    }
    
    // TimecatPickerDelegateViewDelegate
    
    func handleDidSelect(timecat : TimeCategory, name : String) {
        viewModel?.timeCategory = timecat
        self.timeCat_txtField.text = name
    }
    
    // ExpectedUnitOfTimePickerDelegateViewDelegate
    
    func handleDidSelect(unit: UnitOfTime, text: String) {
        viewModel?.expectedTimeRequirement.update(newUnitOfTime: unit, newValue: viewModel?.expectedTimeRequirement.numberOfUnits)
        expectedUnitOfTime_txtField.text = text
    }
    
    // IBActions
    
    @IBAction func toggleRepeatable(_ sender: AnyObject) {
        repeatable_btn.toggleChecked()
        switch viewModel!.repeatable.value {
        case true:
            viewModel?.repeatableTask = nil
            viewModel?.repeatable.value = false
            DispatchQueue.main.async {
                self.start_txtField.text = ""
                self.startDateTextView.text = ""
            }
        case false:
            let nextViewController = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.create_repeatable_task_VC_id) as! CreateRepeatableTaskOccurrenceViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            viewModel?.repeatable.value = true
        }
    }
    
    @IBAction func modifyCategories(_ sender: AnyObject) {
        let modifyVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_add_category_VC_id) as! AddCategoriesViewController
        modifyVC.viewModel.selectedCategories = Dynamic(self.viewModel!.categories!.map({ Dynamic($0) }))
        modifyVC.taskDelegate = self
        self.navigationController?.pushViewController(modifyVC, animated: true)
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        
        if !validateForSubmit() {
            return
        }
        let createTaskVM = viewModel! as! CreateTaskViewModel
        let check = createTaskVM.submit()
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
        
        if !viewModel!.repeatable.value && (startDateTextView.text! == Constants.createTaskVC_repeatable || start_txtField.text! == Constants.createTaskVC_repeatable) {
            AlertHelper.PresentAlertController(sender: self, title: Constants.standard_alert_fail_title, message: Constants.createTaskVC_alert_invalid_repeatables_failure_message, actions: [Constants.standard_ok_alert_action])
            return false
        }
        return true
    }
}
