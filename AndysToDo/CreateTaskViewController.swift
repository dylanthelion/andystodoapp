//
//  CreateTaskViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/22/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController, TaskDTODelegate, UITextFieldDelegate, UITextViewDelegate, DatePickerViewDelegateViewDelegate, TimePickerViewDelegateViewDelegate, TimecatPickerDelegateViewDelegate {
    
    // UI
    
    var textFieldSelected = 0
    let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    
    // Model values
    
    let taskDTO = TaskDTO.globalManager
    var allCategories : [Category]?
    var allTimeCategories : [TimeCategory]?
    var chosenTimeCategory: TimeCategory? = nil
    var startTime : NSDate?
    var startMonth : String?
    var startDay : String?
    var startHours : String?
    var repeatable : Bool = false
    var repeatableDetails : RepeatableTaskOccurrence?
    
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
    @IBOutlet weak var repeatable_btn: CheckboxButton!
    @IBOutlet weak var timeCat_txtField: UITextField!
    @IBOutlet weak var description_txtView: UITextView!
    @IBOutlet weak var startDateTextView: UITextField!
    
    override func viewDidLoad() {
        allTimeCategories = taskDTO.AllTimeCategories
        setupPickerDelegation()
        setupTextFieldDelegation()
        setupTextFieldInput()
        addTextViewBorder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taskDTO.delegate = self
        if repeatableDetails == nil {
            repeatable_btn.setImage(UIImage(named: "checkbox_unchecked"), for: .normal)
            repeatable_btn.checked = false
            repeatable = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        taskDTO.delegate = nil
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
        description_txtView.layer.borderWidth = 2.0
        description_txtView.layer.borderColor = UIColor.gray.cgColor
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
    
    // TaskDTODelegate
    
    func handleModelUpdate() {
        
    }
    
    func taskDidUpdate(_task: Task) {
        
    }
    
    // Categories
    
    func addCategory(_category : Category) {
        if let _ = self.allCategories {
            self.allCategories!.append(_category)
        } else {
            self.allCategories = [_category]
        }
    }
    
    func removeCategory(_category : Category) {
        let indexOf = self.allCategories?.index(of: _category)
        self.allCategories?.remove(at: indexOf!)
    }
    
    // IBActions
    
    
    @IBAction func toggleRepeatable(_ sender: AnyObject) {
        repeatable_btn.toggleChecked()
        switch repeatable {
        case true:
            repeatableDetails = nil
            repeatable = false
            DispatchQueue.main.async {
                self.start_txtField.text = ""
                self.startDateTextView.text = ""
            }
        case false:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "createRepeatableTaskVC") as! CreateRepeatableTaskOccurrenceViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            repeatable = true
        }
    }
    
    @IBAction func modifyCategories(_ sender: AnyObject) {
        let modifyVC = AddCategoriesViewController()
        modifyVC.selectedCategories = self.allCategories
        self.navigationController?.pushViewController(modifyVC, animated: true)
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        
        if !validateForSubmit() {
            return
        }
        
        if repeatable {
            if !validateRepeatable() {
                return
            }
        } else {
            if !validateNonRepeatableTask() {
                return
            }
        }
    }
    
    // Validation
    
    func validateForSubmit() -> Bool {
        
        if name_txtField.text! == "" || description_txtView.text == "" || start_txtField.text! == "" && startDateTextView.text! == "" {
            let alertController = UIAlertController(title: "Failed", message: "Please include a name, decsription, and all time information", preferredStyle: .alert)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        if !repeatable && (startDateTextView.text! == "Repeatable" || start_txtField.text! == "Repeatable") {
            let alertController = UIAlertController(title: "Failed", message: "Your information is invalid. Something went wrong with repeatables.", preferredStyle: .alert)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func validateRepeatable() -> Bool {
        let task = Task(_name: name_txtField.text!, _description: description_txtView.text, _start: self.startTime, _finish: nil, _category: self.allCategories, _timeCategory: chosenTimeCategory, _repeatable: self.repeatableDetails)
        if taskDTO.createNewTask(_task: task) {
            let alertController = UIAlertController(title: "Success", message: "Task created!", preferredStyle: .alert)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            DispatchQueue.main.async {
                self.name_txtField.text = ""
                self.start_txtField.text = ""
                self.description_txtView.text = ""
                self.timeCat_txtField.text = ""
                self.startDateTextView.text = ""
                if self.repeatable_btn.checked {
                    self.repeatable_btn.toggleChecked()
                }
            }
            return true
        } else {
            let alertController = UIAlertController(title: "Failed", message: "Your repeatable information is invalid. Something went wrong.", preferredStyle: .alert)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
    }
    
    func validateNonRepeatableTask() -> Bool {
        let formatter = StandardDateFormatter()
        let df = DateFormatter()
        df.dateFormat = "MMM"
        let year : String = formatter.getNextMonthOccurrence(startMonth: startMonth!, startDay: startDay!)
        print("\(startMonth!) \(startDay!) \(startHours!) \(year)")
        let date = formatter.date(from: "\(startMonth!) \(startDay!) \(startHours!) \(year)")! as NSDate
        let task = Task(_name: name_txtField.text!, _description: description_txtView.text, _start: date, _finish: nil, _category: self.allCategories, _timeCategory: chosenTimeCategory, _repeatable: nil)
        if taskDTO.createNewTask(_task: task) {
            let alertController = UIAlertController(title: "Success", message: "Task created!", preferredStyle: .alert)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            DispatchQueue.main.async {
                self.name_txtField.text = ""
                self.start_txtField.text = ""
                self.description_txtView.text = ""
                self.timeCat_txtField.text = ""
                self.startDateTextView.text = ""
                if self.repeatable_btn.checked {
                    self.repeatable_btn.toggleChecked()
                }
            }
            return true
        } else {
            let alertController = UIAlertController(title: "Failed", message: "Your normal information is invalid. Something went wrong.", preferredStyle: .alert)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
    }
    
}
