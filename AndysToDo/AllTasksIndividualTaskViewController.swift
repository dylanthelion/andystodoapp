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

class AllTasksIndividualTaskViewController : UIViewController, CreateTaskParentViewController,  DatePickerViewDelegateViewDelegate, TimePickerViewDelegateViewDelegate, TimecatPickerDelegateViewDelegate, ExpectedUnitOfTimePickerDelegateViewDelegate, PickerViewViewDelegate, AlertPresenter {
    
    // UI
    
    var textFieldSelected = 0
    
    // View Model
    
    var viewModel : TaskCRUDViewModel?
    
    // Picker views
    
    var pickerView = UIPickerView()
    var timeCatPickerView = UIPickerView()
    var datePickerView = UIPickerView()
    var expectedUnitOfTimePickerView = UIPickerView()
    var timePickerDelegate : TimePickerViewDelegate?
    var timePickerDataSource = TimePickerViewDataSource()
    var timeCatPickerDataSource : TimecatPickerDataSource?
    var timeCatDelegate : TimecatPickerDelegate?
    var datePickerDelegate : DatePickerViewDelegate?
    var datePickerDataSource = DatePickerDataSource()
    var expectedPickerDataSource = ExpectedUnitOfTimePickerDataSource()
    var expectedPickerDelegate : ExpectedUnitOfTimePickerDelegate?
    
    // Text Fields
    
    var textFieldDelegate : CreateTaskTextFieldDelegate?
    var textViewDelegate : PickerViewDelegateTextViewDelegate?
    
    // Alert Presenter
    
    var completionHandlers : [() -> Void] = [() -> Void]()
    var alertIsVisible = false
    
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewModel = AllTasksIndividualTaskViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerDelegation()
        setupTextFieldInput()
        populateTaskInfo()
        timecatDTOBond.bind(dynamic: (viewModel?.allTimeCategories!)!)
        taskDTOBond.bind(dynamic: (viewModel?.task!)!)
        setupTextFields()
    }
    
    // Binding
    
    var timecatDTOBond: Bond<[TimeCategory]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &timecatHandle) as AnyObject? {
            return b as! Bond<[TimeCategory]>
        } else {
            let b = Bond<[TimeCategory]>() { [unowned self] v in
                //print("Update timecats in view")
                let closure = {
                    DispatchQueue.main.async {
                        self.timeCatPickerDataSource!.allTimeCategories = self.viewModel!.allTimeCategories!.value
                        self.timeCatDelegate!.allTimeCategories = self.viewModel!.allTimeCategories!.value
                        self.timeCatPickerView.reloadAllComponents()
                    }
                }
                if self.alertIsVisible {
                    self.completionHandlers.append(closure)
                } else {
                    closure()
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
                let closure = {
                    DispatchQueue.main.async {
                        self.populateTaskInfo()
                    }
                }
                if self.alertIsVisible {
                    self.completionHandlers.append(closure)
                } else {
                    closure()
                }
            }
            objc_setAssociatedObject(self, &taskHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // View setup
    
    func setupPickerDelegation() {
        timeCatDelegate = TimecatPickerDelegate(_categories: viewModel?.allTimeCategories!.value, _delegate: self)
        timeCatPickerDataSource = TimecatPickerDataSource(_categories: viewModel?.allTimeCategories!.value)
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
        self.repeatable_btn.isUserInteractionEnabled = false
        if viewModel!.task!.value.isRepeatable() {
            resetRepeatableTextFields()
            self.generateNewTask_btn.setTitle(Constants.allTasksIndividualTaskVC_btn_title_child_task, for: .normal)
            self.repeatable_btn.setImage(UIImage(named: Constants.img_checkbox_checked), for: .normal)
        } else {
            self.startDateTextView.text = TimeConverter.dateToShortDateConverter((viewModel?.task!.value.startTime!)!)
            self.start_txtField.text = TimeConverter.dateToTimeWithMeridianConverter((viewModel?.task!.value.startTime!)!)
            self.repeatable_lbl.isHidden = true
            self.repeatable_btn.isHidden = true
            self.generateNewTask_btn.setTitle(Constants.allTasksIndividualTaskVC_btn_title_temp_copy, for: .normal)
        }
        if let _ = viewModel!.task!.value.timeCategory {
            self.timeCat_txtField.text = viewModel!.task!.value.timeCategory!.name!
        } else {
            self.timeCat_txtField.text = ""
        }
        guard let check = viewModel!.task!.value.expectedTimeRequirement.unit else {
            return
        }
        self.expectedUnitOfTime_txtField.text = "\(Constants.expectedUnitsOfTimeAsString[Constants.expectedUnitOfTime_All.index(of: check)!])"
        self.expectedTotalUnits_txtField.text = String(viewModel!.task!.value.expectedTimeRequirement.numberOfUnits!)
    }
    
    func populateTaskInfo() {
        setupRepeatable()
        populateNonRepeatableData()
    }
    
    func populateNonRepeatableData() {
        self.name_txtField.text = viewModel?.task!.value.name!
        self.description_txtView.text = viewModel!.task!.value.description!
        if let _ = viewModel!.task!.value.timeCategory?.color {
            self.view.backgroundColor = UIColor(cgColor: (viewModel!.task!.value.timeCategory!.color!))
        } else {
            self.view.backgroundColor = UIColor.white
        }
    }
    
    func setupTextFields() {
        textFieldDelegate = CreateTaskTextFieldDelegate(viewModel: viewModel! as! AllTasksIndividualTaskViewModel, delegate: self)
        name_txtField.delegate = textFieldDelegate
        start_txtField.delegate = textFieldDelegate
        startDateTextView.delegate = textFieldDelegate
        expectedTotalUnits_txtField.delegate = textFieldDelegate
        expectedUnitOfTime_txtField.delegate = textFieldDelegate
        timeCat_txtField.delegate = textFieldDelegate
        textViewDelegate = PickerViewDelegateTextViewDelegate(viewModel: viewModel! as! AllTasksIndividualTaskViewModel, delegate: self)
        description_txtView.delegate = textViewDelegate
    }
    
    // Reset
    
    func resetRepeatableTextFields() {
        start_txtField.text! = Constants.createTaskVC_repeatable
        startDateTextView.text! = Constants.createTaskVC_repeatable
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
        case 0,4:
            print("Do nothing")
        case 1:
            start_txtField.resignFirstResponder()
        case 2:
            timeCat_txtField.resignFirstResponder()
        case 3:
            startDateTextView.resignFirstResponder()
        case 5:
            expectedUnitOfTime_txtField.resignFirstResponder()
        default:
            print("Invalid text field tag assigned")
        }
        removePickerViewDoneButton()
    }
    
    // DatePickerViewDelegateViewDelegate
    
    func handleDidSelect(months: String, days: String, fulldate: String) {
        viewModel!.startMonth = months
        viewModel!.startDay = days
        startDateTextView.text = fulldate
    }
    
    // TimePickerViewDelegateViewDelegate
    
    func handleDidSelect(hours: String, minutes: String, meridian: String, fullTime: String) {
        start_txtField.text = fullTime
        viewModel?.startHours = fullTime
    }
    
    // TimecatPickerDelegateViewDelegate
    
    func handleDidSelect(timecat : TimeCategory, name : String) {
        viewModel!.timeCategory = timecat
        self.timeCat_txtField.text = name
    }
    
    // ExpectedUnitOfTimePickerDelegateViewDelegate
    
    func handleDidSelect(unit: UnitOfTime, text: String) {
        viewModel!.expectedTimeRequirement.update(unit, viewModel!.expectedTimeRequirement.numberOfUnits)
        expectedUnitOfTime_txtField.text = text
    }
    
    // Alert Presenter
    
    func handleWillDisappear() {
        for f in completionHandlers {
            f()
        }
        completionHandlers.removeAll()
    }
    
    // IBActions
    
    @IBAction func toggleRepeatable(_ sender: AnyObject) {
        // Not yet actionable
    }
    
    @IBAction func modifyCategories(_ sender: AnyObject) {
        let modifyVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_add_category_VC_id) as! AddCategoriesViewController
        modifyVC.viewModel.selectedCategories = Dynamic(viewModel!.categories!.map({ Dynamic($0) }))
        modifyVC.taskDelegate = self
        self.navigationController?.pushViewController(modifyVC, animated: true)
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        if !validateForSubmit() {
            return
        }
        if viewModel!.task!.value.isRepeatable() && !validateRepeatableChildforSubmit() {
            return
        }
        let allTasksIndividualVM = viewModel! as! AllTasksIndividualTaskViewModel
        let check = allTasksIndividualVM.submit()
        let alertController = AlertHelper.presentAlertController(self, title: check.1, message: check.2, actions: [Constants.standard_ok_alert_action])
        self.present(alertController, animated: true, completion: nil)
        if check.0 {
            // handle success
            if viewModel!.task!.value.isRepeatable() {
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
        let allTasksIndividualVM = viewModel! as! AllTasksIndividualTaskViewModel
        let check = allTasksIndividualVM.generateNewTask()
        let alertController = AlertHelper.presentAlertController(self, title: check.1, message: check.2, actions: [Constants.standard_ok_alert_action])
        self.present(alertController, animated: true, completion: nil)
        if check.0 {
            if viewModel!.task!.value.isRepeatable() {
                resetRepeatableTextFields()
            }
        }
    }
    
    // Validation
    
    func validateForSubmit() -> Bool {
        
        if name_txtField.text! == "" || description_txtView.text == "" || start_txtField.text! == "" || startDateTextView.text! == "" {
            let alertController = AlertHelper.presentAlertController(self, title: Constants.standard_alert_fail_title, message: Constants.createTaskVC_alert_no_name_description_or_time_failure_message, actions: [Constants.standard_ok_alert_action])
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        if !(viewModel?.task!.value.isRepeatable())! && (startDateTextView.text! == Constants.createTaskVC_repeatable || start_txtField.text! == Constants.createTaskVC_repeatable) {
            let alertController = AlertHelper.presentAlertController(self, title: Constants.standard_alert_fail_title, message: Constants.createTaskVC_alert_invalid_repeatables_failure_message, actions: [Constants.standard_ok_alert_action])
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func validateRepeatableChildforSubmit() -> Bool {
        if (startDateTextView.text! == Constants.createTaskVC_repeatable || startDateTextView.text! == "" || start_txtField.text! == Constants.createTaskVC_repeatable || start_txtField.text! == "") {
            let alertController = AlertHelper.presentAlertController(self, title: Constants.standard_alert_fail_title, message: Constants.allTasksIndividualTaskVC_alert_message_missing_child_details, actions: [Constants.standard_ok_alert_action])
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
}
