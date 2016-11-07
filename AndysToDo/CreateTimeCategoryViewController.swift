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
    var endTime : Float?
    var color : CGColor?
    let taskDTO = TaskDTO.globalManager
    var timecat : TimeCategory?
    
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
        addColorPicker()
        populateViews()
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
        description_txtView.layer.borderWidth = Constants.text_view_border_width
        description_txtView.layer.borderColor = Constants.text_view_border_color
    }
    
    func addColorPicker() {
        let width = self.view.frame.width
        var buttonWidth : CGFloat = 0.0
        var marginWidth : CGFloat = 0.0
        var xCoord : CGFloat = 0.0
        var numberOfElementsPerRow : Int = 0
        var yCoord : CGFloat = 0.0
        for i in 10...20 {
            if (Int(Float(width)) % i) == 0 {
                buttonWidth = CGFloat(i)
                marginWidth = CGFloat(i) * Constants.timecatVC_color_picker_units_in_margins
                xCoord = marginWidth
                numberOfElementsPerRow = Int(Float(width / buttonWidth)) - Int(Constants.timecatVC_color_picker_units_in_margins * 2.0)
                yCoord = Constants.timecatVC_color_label_bottom_y_coord + Constants.timecatVC_standard_view_padding
                break
            }
        }
        
        if numberOfElementsPerRow == 0 {
            print("No effective modulus")
            return
        }
        
        var buttonsToAdd : [ColorPickerButton] = [ColorPickerButton]()
        let maxButtons = numberOfElementsPerRow * Constants.timecatVC_color_picker_column_size
        
        let currentDenominator = Int(floor(pow(Double(maxButtons), 1/3)))
        var totalButtons = 0
        for outerIndex in 1...currentDenominator {
            for innerIndex in 1...currentDenominator {
                for cubicIndex in 1...currentDenominator {
                    let totalIndex = (outerIndex - 1) * Int(pow(Double(currentDenominator), 2.0)) + (innerIndex - 1) * currentDenominator + cubicIndex - 1
                    let button = ColorPickerButton(frame: CGRect(x: xCoord + (buttonWidth * CGFloat(totalIndex % numberOfElementsPerRow)), y: yCoord + (buttonWidth * CGFloat(totalIndex / numberOfElementsPerRow)), width: buttonWidth, height: buttonWidth), _r: 1.0 / Float(outerIndex), _g: 1.0 / Float(innerIndex), _b: 1.0 / Float(cubicIndex))
                    button.addTarget(self, action: #selector(selectColor(sender:)), for: .touchUpInside)
                    buttonsToAdd.append(button)
                    totalButtons += 1
                }
            }
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
            start_txtField.text = String(timecat!.StartOfTimeWindow!)
            end_txtField.text = String(timecat!.EndOfTimeWindow!)
            if let _ = timecat!.color {
                self.view.backgroundColor = UIColor(cgColor: timecat!.color!)
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
        DispatchQueue.main.async {
            if let _ = self.lastColorSelected {
                self.lastColorSelected?.layer.borderWidth = Constants.timecatVC_color_picker_deselected_border_width
                self.lastColorSelected?.layer.borderColor = Constants.timecatVC_color_picker_deselected_border_color
            }
            sender.layer.borderWidth = Constants.timecatVC_color_picker_selected_border_width
            sender.layer.borderColor = Constants.timecatVC_color_picker_selected_border_color
            self.lastColorSelected = sender
        }
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
        if let _ = timecat {
            // update timecat info
            return
        }
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
        if taskDTO.createNewTimeCategory(_category: TimeCategory(_name: name_txtField.text!, _description: description_txtView.text, _start: startTime!, _end: endTime!, _color: self.color)) {
            let alertController = UIAlertController(title: Constants.standard_alert_ok_title, message: Constants.timecatVC_alert_success_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            DispatchQueue.main.async {
                self.start_txtField.text = ""
                self.end_txtField.text = ""
                self.name_txtField.text = ""
                self.description_txtView.text = ""
            }
            return true
        } else {
            let alertController = UIAlertController(title: Constants.standard_alert_fail_title, message: Constants.timecatVC_alert_name_uniqueness_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return false
        }

    }
    
}
