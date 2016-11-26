//
//  DisplayInactiveTask.swift
//  AndysToDo
//
//  Created by dillion on 11/2/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private var taskHandle : UInt8 = 0

class DisplayInactiveTaskViewController : UIViewController, UITextFieldDelegate, UITextViewDelegate, TimecatPickerDelegateViewDelegate, TimePickerViewDelegateViewDelegate, DatePickerViewDelegateViewDelegate {
    
    // UI
    
    var textFieldSelected = 0
    
    // View Model
    
    let viewModel = DisplayInactiveTaskViewModel()
    
    // Picker views
    
    let pickerView = UIPickerView()
    let timeCatPickerView = UIPickerView()
    var datePickerView = UIPickerView()
    var timePickerDelegate : TimePickerViewDelegate?
    let timePickerDataSource : TimePickerViewDataSource = TimePickerViewDataSource()
    var timeCatPickerDataSource : TimecatPickerDataSource?
    var timeCatDelegate : TimecatPickerDelegate?
    var datePickerDelegate : DatePickerViewDelegate?
    let datePickerDataSource = DatePickerDataSource()
    
    
    // Outlets
    
    @IBOutlet weak var name_txtField: UITextField!
    @IBOutlet weak var start_txtField: UITextField!
    @IBOutlet weak var timeCat_txtField: UITextField!
    @IBOutlet weak var description_txtView: BorderedTextView!
    @IBOutlet weak var startDateTextView: UITextField!
    @IBOutlet weak var expectedTime_lbl: UILabel!
    
    override func viewDidLoad() {
        setupPickerDelegation()
        setupTextFieldInput()
        populateTaskInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //populateTaskInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    // View setup
    
    func setupPickerDelegation() {
        timeCatDelegate = TimecatPickerDelegate(_categories: viewModel.AllTimeCategories!, _delegate: self)
        timeCatPickerDataSource = TimecatPickerDataSource(_categories: viewModel.AllTimeCategories!)
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
    
    func populateTaskInfo() {
        self.name_txtField.text = viewModel.task!.value.Name!
        self.start_txtField.text = TimeConverter.dateToTimeWithMeridianConverter(_time: viewModel.task!.value.StartTime!)
        self.startDateTextView.text = TimeConverter.dateToShortDateConverter(_time: viewModel.task!.value.StartTime!)
        self.description_txtView.text = viewModel.task!.value.Description!
        if let _ = viewModel.task!.value.TimeCategory {
            self.timeCat_txtField.text = viewModel.task!.value.TimeCategory!.Name!
            if let _ = viewModel.task!.value.TimeCategory?.color {
                self.view.backgroundColor = UIColor(cgColor: viewModel.task!.value.TimeCategory!.color!)
            }
        }
        if let _ = viewModel.task!.value.expectedTimeRequirement {
            self.expectedTime_lbl.text = "\(viewModel.task!.value.expectedTimeRequirement!.1) \(Constants.expectedUnitsOfTimeAsString[Constants.expectedUnitOfTime_All.index(of: viewModel.task!.value.expectedTimeRequirement!.0)!])"
        }
    }
    
    func updateForSuccessfulSubmit() {
        if let _ = viewModel.task!.value.TimeCategory?.color {
            DispatchQueue.main.async {
                self.view.backgroundColor = UIColor(cgColor: self.viewModel.task!.value.TimeCategory!.color!)
            }
        } else {
            DispatchQueue.main.async {
                self.view.backgroundColor = UIColor.white
            }
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
        viewModel.startHours = fullTime
        start_txtField.text = fullTime
    }
    
    // TimecatPickerDelegateViewDelegate
    
    func handleDidSelect(timecat : TimeCategory, name : String) {
        self.timeCat_txtField.text = name
        self.viewModel.TimeCategory = timecat
    }
    
    // IBActions
    
    @IBAction func modifyCategories(_ sender: AnyObject) {
        let modifyVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_add_category_VC_id) as! AddCategoriesViewController
        if let _ = viewModel.Categories {
            modifyVC.viewModel.selectedCategories = Dynamic(self.viewModel.Categories!.map({ Dynamic($0) }))
        } else {
            modifyVC.viewModel.selectedCategories = Dynamic([Dynamic<Category>]())
        }
        
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
            // handle success
        }
    }
    
    
    @IBAction func postpone(_ sender: AnyObject) {
        if viewModel.postpone() {
            self.navigationController?.popViewController(animated: true)
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
        return true
    }
}
