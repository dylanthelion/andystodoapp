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
    let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    
    // Model values
    
    var startTime : Float?
    var endTime : Float?
    let taskDTO = TaskDTO.globalManager
    //var startTxtFieldIsSelected = false
    
    // Picker views
    
    let pickerView = UIPickerView()
    var timePickerDelegate : TimePickerViewDelegate?
    let timePickerDataSource : TimePickerViewDataSource = TimePickerViewDataSource()
    
    
    @IBOutlet weak var name_txtField: UITextField!
    @IBOutlet weak var start_txtField: UITextField!
    @IBOutlet weak var end_txtField: UITextField!
    @IBOutlet weak var description_txtView: UITextView!
    
    override func viewDidLoad() {
        setupPickerDelegation()
        setupTextFieldDelegation()
        setupTextFieldInput()
        addTextViewBorder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taskDTO.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        taskDTO.delegate = nil
    }
    
    // View setup
    
    func setupTextFieldDelegation(){
        name_txtField.delegate = self
        start_txtField.delegate = self
        end_txtField.delegate = self
        description_txtView.delegate = self
    }
    
    func setupPickerDelegation() {
        timePickerDelegate = TimePickerViewDelegate(_delegate: self)
        pickerView.delegate = timePickerDelegate!
        pickerView.dataSource = timePickerDataSource
    }
    
    func setupTextFieldInput() {
        self.start_txtField.inputView = pickerView
        self.end_txtField.inputView = pickerView
    }
    
    func addTextViewBorder() {
        description_txtView.layer.borderWidth = 2.0
        description_txtView.layer.borderColor = UIColor.gray.cgColor
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
    
    // TimePickerViewDelegateViewDelegate
    
    func handleDidSelect(hours: String, minutes: String, meridian: String, fullTime: String) {
        var time : Float = Float(hours)! + (Float(minutes)! / 60.0)
        if meridian == "PM" {
            time += 12.0
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
            let alertController = UIAlertController(title: "Failed", message: "Please include a name, description, and a full time window", preferredStyle: .alert)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func validateAndSubmitTimecat() -> Bool {
        if taskDTO.createNewTimeCategory(_category: TimeCategory(_name: name_txtField.text!, _description: description_txtView.text, _start: startTime!, _end: endTime!)) {
            let alertController = UIAlertController(title: "Success", message: "Category created", preferredStyle: .alert)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            DispatchQueue.main.async {
                self.start_txtField.text = ""
                self.end_txtField.text = ""
                self.name_txtField.text = ""
                self.description_txtView.text = ""
            }
            return true
        } else {
            let alertController = UIAlertController(title: "Failed", message: "That name is already taken", preferredStyle: .alert)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }

    }
    
}
