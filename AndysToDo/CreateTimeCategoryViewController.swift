//
//  CreateTimeCategoryViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/22/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateTimeCategoryViewController : UIViewController, TaskDTODelegate, UITextFieldDelegate, UITextViewDelegate, TimePickerViewDelegateViewDelegate {
    
    // UI
    
    var textFieldSelected : Int = 0
    var lastColorSelected : ColorPickerButton?
    
    // Model values
    
    var startTime : Float?
    var startHours: String?
    var endTime : Float?
    var color : CGColor?
    let timecatDTO = TimeCategoryDTO.shared
    var timecat : TimeCategory?
    
    // Picker views
    
    let pickerView = UIPickerView()
    var timePickerDelegate : TimePickerViewDelegate?
    let timePickerDataSource : TimePickerViewDataSource = TimePickerViewDataSource()
    
    
    @IBOutlet weak var name_txtField: UITextField!
    @IBOutlet weak var start_txtField: UITextField!
    @IBOutlet weak var end_txtField: UITextField!
    @IBOutlet weak var description_txtView: BorderedTextView!
    
    override func viewDidLoad() {
        setupPickerDelegation()
        setupTextFieldInput()
        addColorPicker()
        populateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timecatDTO.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timecatDTO.delegate = nil
    }
    
    // View setup
    
    func setupPickerDelegation() {
        timePickerDelegate = TimePickerViewDelegate(_delegate: self)
        pickerView.delegate = timePickerDelegate!
        pickerView.dataSource = timePickerDataSource
    }
    
    func setupTextFieldInput() {
        self.start_txtField.inputView = pickerView
        self.end_txtField.inputView = pickerView
    }
    
    func addColorPicker() {
        let buttonsToAdd = ColorPickerHelper.colorPicker(viewWidth : self.view.frame.width)
        for btn in buttonsToAdd {
            btn.addTarget(self, action: #selector(selectColor(sender:)), for: .touchUpInside)
        }
        
        DispatchQueue.main.async {
            for button in buttonsToAdd {
                self.view.addSubview(button)
            }
        }
    }
    
    func populateViews() {
        if let _ = timecat {
            name_txtField.text = timecat!.Name!
            description_txtView.text = timecat!.Description
            start_txtField.text = TimeConverter.convertFloatToTimeString(_time: timecat!.StartOfTimeWindow!)
            end_txtField.text = TimeConverter.convertFloatToTimeString(_time: timecat!.EndOfTimeWindow!)
            self.startTime = timecat?.StartOfTimeWindow
            self.endTime = timecat?.EndOfTimeWindow
            if let _ = timecat!.color {
                DispatchQueue.main.async {
                    self.view.backgroundColor = UIColor(cgColor: self.timecat!.color!)
                    if let _ = self.lastColorSelected {
                        self.lastColorSelected!.deselect()
                        self.lastColorSelected = nil
                    }
                }
                self.color = timecat?.color
            }
        }
    }
    
    func resetAfterSuccessfulSubmit() {
        DispatchQueue.main.async {
            self.start_txtField.text = ""
            self.end_txtField.text = ""
            self.name_txtField.text = ""
            self.description_txtView.text = ""
            if let _ = self.lastColorSelected {
                self.lastColorSelected!.deselect()
                self.lastColorSelected = nil
            }
        }
    }
    
    // TaskDTODelegate
    
    func handleModelUpdate() {
        
    }
    
    func taskDidUpdate(_task: Task) {
        
    }
    
    // Text Delegate
    
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
        default:
            print("Invalid text field tag")
            return false
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textFieldSelected = 0
        return true
    }
    
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
        case 1:
            start_txtField.resignFirstResponder()
        case 2:
            end_txtField.resignFirstResponder()
        default :
            // Do nothing
            print("No picker selected")
        }
        self.navigationItem.rightBarButtonItem = nil
    }
    
    // Color picker
    
    func selectColor(sender : ColorPickerButton) {
        color = sender.backgroundColor!.cgColor
        if let _ = self.lastColorSelected {
            self.lastColorSelected?.deselect()
        }
        sender.select()
        self.lastColorSelected = sender
    }
    
    // TimePickerViewDelegateViewDelegate
    
    func handleDidSelect(hours: String, minutes: String, meridian: String, fullTime: String) {
        var time : Float = Float(hours)! + (Float(minutes)! / Constants.seconds_per_minute)
        if meridian == Constants.meridian_pm && hours != "12" {
            time += Constants.hours_per_meridian
        }
        if textFieldSelected == 1 {
            start_txtField.text = fullTime
            startTime = time
        } else {
            end_txtField.text = fullTime
            endTime = time
        }
    }
    
    // IBActions
    
    @IBAction func submit(_ sender: AnyObject) {
        if !validateForSubmit() {
            return
        }
        if !validateAndSubmitTimecat() {
            return
        } else {
            return
        }
    }
    
    // Validation
    
    func validateForSubmit() -> Bool {
        
        if name_txtField.text! == "" || description_txtView.text == "" || start_txtField.text == "" || end_txtField.text == "" {
            let alertController = UIAlertController(title: Constants.standard_alert_fail_title, message: Constants.timecatVC_alert_no_name_description_or_window_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func validateAndSubmitTimecat() -> Bool {
        if let _ = timecat {
            if timecatDTO.updateTimeCategory(_oldCategory: timecat!, _category: TimeCategory(_name: self.name_txtField.text!, _description: self.description_txtView.text, _start: startTime!, _end: endTime!, _color: color)) {
                let alertController = UIAlertController(title: Constants.standard_alert_ok_title, message: Constants.createCatVC_alert_success_message, preferredStyle: .alert)
                alertController.addAction(Constants.standard_ok_alert_action)
                self.present(alertController, animated: true, completion: nil)
                self.populateViews()
                return true
            } else {
                let alertController = UIAlertController(title: Constants.standard_alert_fail_title, message: Constants.createCatVC_alert_name_uniqueness_failure_message, preferredStyle: .alert)
                alertController.addAction(Constants.standard_ok_alert_action)
                self.present(alertController, animated: true, completion: nil)
                return false
            }
        }
        if timecatDTO.createNewTimeCategory(_category: TimeCategory(_name: name_txtField.text!, _description: description_txtView.text, _start: startTime!, _end: endTime!, _color: self.color)) {
            let alertController = UIAlertController(title: Constants.standard_alert_ok_title, message: Constants.timecatVC_alert_success_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            resetAfterSuccessfulSubmit()
            return true
        } else {
            let alertController = UIAlertController(title: Constants.standard_alert_fail_title, message: Constants.timecatVC_alert_name_uniqueness_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return false
        }

    }
    
}
