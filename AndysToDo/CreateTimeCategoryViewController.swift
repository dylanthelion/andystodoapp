//
//  CreateTimeCategoryViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/22/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateTimeCategoryViewController : UIViewController, PickerViewViewDelegate, TimePickerViewDelegateViewDelegate {
    
    // UI
    
    var textFieldSelected : Int = 0
    var lastColorSelected : ColorPickerButton?
    
    // View Model
    
    let viewModel = CreateTimeCategoryViewModel()
    
    // Text Fields
    
    var textFieldDelegate : CreateTimecatTextFieldDelegate?
    var textViewDelegate : PickerViewDelegateTextViewDelegate?
    
    // Picker views
    
    let pickerView = UIPickerView()
    var timePickerDelegate : TimePickerViewDelegate?
    let timePickerDataSource : TimePickerViewDataSource = TimePickerViewDataSource()
    
    // Outlets
    
    @IBOutlet weak var name_txtField: UITextField!
    @IBOutlet weak var start_txtField: UITextField!
    @IBOutlet weak var end_txtField: UITextField!
    @IBOutlet weak var description_txtView: BorderedTextView!
    
    override func viewDidLoad() {
        setupPickerDelegation()
        setupTextFieldInput()
        addColorPicker()
        populateViews()
        setupTextFields()
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
        if let timecat = viewModel.timeCategory {
            name_txtField.text = timecat.Name!
            description_txtView.text = timecat.Description
            start_txtField.text = TimeConverter.convertFloatToTimeString(_time: timecat.StartOfTimeWindow!)
            end_txtField.text = TimeConverter.convertFloatToTimeString(_time: timecat.EndOfTimeWindow!)
            if let _ = timecat.color {
                DispatchQueue.main.async {
                    self.view.backgroundColor = UIColor(cgColor: self.viewModel.timeCategory!.color!)
                }
            }
        }
    }
    
    func setupTextFields() {
        textFieldDelegate = CreateTimecatTextFieldDelegate(viewModel: viewModel, delegate: self)
        name_txtField.delegate = textFieldDelegate
        start_txtField.delegate = textFieldDelegate
        end_txtField.delegate = textFieldDelegate
        textViewDelegate = PickerViewDelegateTextViewDelegate(viewModel: viewModel, delegate: self)
        description_txtView.delegate = textViewDelegate
    }
    
    // Reset
    
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
            end_txtField.resignFirstResponder()
        default :
            // Do nothing
            print("No picker selected")
        }
        removePickerViewDoneButton()
    }
    
    // Color picker
    
    func selectColor(sender : ColorPickerButton) {
        viewModel.color = sender.backgroundColor!.cgColor
        if let _ = self.lastColorSelected {
            self.lastColorSelected?.deselect()
        }
        sender.select()
        self.lastColorSelected = sender
    }
    
    // TimePickerViewDelegateViewDelegate
    
    func handleDidSelect(hours: String, minutes: String, meridian: String, fullTime: String) {
        let time = TimeConverter.hoursMinutesAndMeridianToTimeAsFloat(hours: hours, minutes: minutes, meridian: meridian)
        if textFieldSelected == 1 {
            start_txtField.text = fullTime
            viewModel.startOfTimeWindow = time
        } else {
            end_txtField.text = fullTime
            viewModel.endOfTimeWindow = time
        }
    }
    
    // IBActions
    
    @IBAction func submit(_ sender: AnyObject) {
        if !validateForSubmit() {
            return
        }
        
        if !validateAndSubmitTimecat() {
            return
        } else if viewModel.timeCategory == nil {
            resetAfterSuccessfulSubmit()
        } else if let _ = viewModel.timeCategory!.color {
            DispatchQueue.main.async {
                self.view.backgroundColor = UIColor(cgColor: self.viewModel.timeCategory!.color!)
            }
        }
    }
    
    // Validation
    
    func validateForSubmit() -> Bool {
        if name_txtField.text! == "" || description_txtView.text == "" || start_txtField.text == "" || end_txtField.text == "" {
            AlertHelper.PresentAlertController(sender: self, title: Constants.standard_alert_fail_title, message: Constants.timecatVC_alert_no_name_description_or_window_failure_message, actions: [Constants.standard_ok_alert_action])
            return false
        }
        return true
    }
    
    func validateAndSubmitTimecat() -> Bool {
        if viewModel.validateAndSubmitCategory() {
            AlertHelper.PresentAlertController(sender: self, title: Constants.standard_alert_ok_title, message: Constants.createCatVC_alert_success_message, actions: [Constants.standard_ok_alert_action])
            return true
        } else {
            AlertHelper.PresentAlertController(sender: self, title: Constants.standard_alert_fail_title, message: Constants.createCatVC_alert_name_uniqueness_failure_message, actions: [Constants.standard_ok_alert_action])
            return false
        }
    }
}
