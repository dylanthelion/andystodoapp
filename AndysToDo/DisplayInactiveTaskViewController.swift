//
//  DisplayInactiveTask.swift
//  AndysToDo
//
//  Created by dillion on 11/2/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private var taskHandle : UInt8 = 0
private var timecatHandle : UInt8 = 0

class DisplayInactiveTaskViewController : UIViewController, CreateTaskParentViewController, TimecatPickerDelegateViewDelegate, TimePickerViewDelegateViewDelegate, DatePickerViewDelegateViewDelegate, PickerViewViewDelegate, AlertPresenter {
    
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
    
    var textFieldDelegate : DisplayInactiveTaskTextFieldDelegate?
    var textViewDelegate : PickerViewDelegateTextViewDelegate?
    
    // Alert Presenter
    
    var completionHandlers : [() -> Void] = [() -> Void]()
    var alertIsVisible = false
    
    // Outlets
    
    @IBOutlet weak var name_txtField: UITextField!
    @IBOutlet weak var start_txtField: UITextField!
    @IBOutlet weak var timeCat_txtField: UITextField!
    @IBOutlet weak var description_txtView: BorderedTextView!
    @IBOutlet weak var startDateTextView: UITextField!
    @IBOutlet weak var expectedTime_lbl: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewModel = DisplayInactiveTaskViewModel()
        timecatDTOBond.bind(dynamic: (viewModel! as! DisplayInactiveTaskViewModel).allTimeCategories!)
    }
    
    override func viewDidLoad() {
        setupPickerDelegation()
        setupTextFieldInput()
        populateTaskInfo()
        setupTextFields()
    }
    
    // View setup
    
    func setupPickerDelegation() {
        timeCatDelegate = TimecatPickerDelegate(_categories: viewModel!.allTimeCategories!.value, _delegate: self)
        timeCatPickerDataSource = TimecatPickerDataSource(_categories: viewModel!.allTimeCategories!.value)
        timePickerDelegate = TimePickerViewDelegate(_delegate: self)
        pickerView.delegate = timePickerDelegate!
        pickerView.dataSource = timePickerDataSource
        timeCatPickerView.dataSource = timeCatPickerDataSource
        timeCatPickerView.delegate = timeCatDelegate!
        datePickerDelegate = DatePickerViewDelegate(_delegate: self)
        datePickerView.delegate = datePickerDelegate
        datePickerView.dataSource = datePickerDataSource
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
    
    // Setup
    
    func setupTextFieldInput() {
        start_txtField.inputView = pickerView
        timeCat_txtField.inputView = timeCatPickerView
        startDateTextView.inputView = datePickerView
    }
    
    func populateTaskInfo() {
        self.name_txtField.text = viewModel!.task!.value.Name!
        self.start_txtField.text = TimeConverter.dateToTimeWithMeridianConverter(_time: viewModel!.task!.value.StartTime!)
        self.startDateTextView.text = TimeConverter.dateToShortDateConverter(_time: viewModel!.task!.value.StartTime!)
        self.description_txtView.text = viewModel!.task!.value.Description!
        if let _ = viewModel!.task!.value.TimeCategory {
            self.timeCat_txtField.text = viewModel!.task!.value.TimeCategory!.Name!
            if let _ = viewModel!.task!.value.TimeCategory?.color {
                self.view.backgroundColor = UIColor(cgColor: viewModel!.task!.value.TimeCategory!.color!)
            }
        }
        if viewModel!.task!.value.expectedTimeRequirement.unit == nil {
            return
        }
        self.expectedTime_lbl.text = "\(viewModel!.task!.value.expectedTimeRequirement.numberOfUnits!) \(Constants.expectedUnitsOfTimeAsString[Constants.expectedUnitOfTime_All.index(of: viewModel!.task!.value.expectedTimeRequirement.unit!)!])"
    }
    
    func setupTextFields() {
        textFieldDelegate = DisplayInactiveTaskTextFieldDelegate(viewModel: viewModel! as! DisplayInactiveTaskViewModel, delegate: self)
        textViewDelegate = PickerViewDelegateTextViewDelegate(viewModel: viewModel!, delegate: self)
        name_txtField.delegate = textFieldDelegate
        start_txtField.delegate = textFieldDelegate
        timeCat_txtField.delegate = textFieldDelegate
        description_txtView.delegate = textViewDelegate
        startDateTextView.delegate = textFieldDelegate
    }
    
    // Reset
    
    func resetForSuccessfulSubmit() {
        let closure = {
            if let _ = self.viewModel!.task!.value.TimeCategory?.color {
                DispatchQueue.main.async {
                    self.view.backgroundColor = UIColor(cgColor: self.viewModel!.task!.value.TimeCategory!.color!)
                }
            } else {
                DispatchQueue.main.async {
                    self.view.backgroundColor = UIColor.white
                }
            }
        }
        if alertIsVisible {
            completionHandlers.append(closure)
        } else {
            closure()
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
        viewModel!.startHours = fullTime
        start_txtField.text = fullTime
    }
    
    // TimecatPickerDelegateViewDelegate
    
    func handleDidSelect(timecat : TimeCategory, name : String) {
        self.timeCat_txtField.text = name
        self.viewModel!.timeCategory = timecat
    }
    
    // Alert Presenter
    
    func handleWillDisappear() {
        for f in completionHandlers {
            f()
        }
        completionHandlers.removeAll()
    }
    
    // IBActions
    
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
        let displayInactiveTaskVM = viewModel! as! DisplayInactiveTaskViewModel
        let check = displayInactiveTaskVM.submit()
        let alertController = AlertHelper.PresentAlertController(sender: self, title: check.1, message: check.2, actions: [Constants.standard_ok_alert_action])
        self.present(alertController, animated: true, completion: nil)
        if check.0 {
            resetForSuccessfulSubmit()
        }
    }
    
    
    @IBAction func postpone(_ sender: AnyObject) {
        let displayInactiveTaskVM = viewModel! as! DisplayInactiveTaskViewModel
        if displayInactiveTaskVM.postpone() {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    // Validation
    
    func validateForSubmit() -> Bool {
        if name_txtField.text! == "" || description_txtView.text == "" || start_txtField.text! == "" && startDateTextView.text! == "" {
            let alertController = AlertHelper.PresentAlertController(sender: self, title: Constants.standard_alert_fail_title, message: Constants.createTaskVC_alert_no_name_description_or_time_failure_message, actions: [Constants.standard_ok_alert_action])
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
}
