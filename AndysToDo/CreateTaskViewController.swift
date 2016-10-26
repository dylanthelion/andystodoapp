//
//  CreateTaskViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/22/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController, TaskDTODelegate, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let taskDTO = TaskDTO.globalManager
    var allCategories : [Category]?
    var allTimeCategories : [TimeCategory]?
    var chosenTimeCategory: TimeCategory? = nil
    var startTime : NSDate?
    var startMonth : String?
    var startDay : String?
    var startHours : String?
    var repeatable : Bool = false
    let hours : [Int] = [1,2,3,4,5,6,7,8,9,10,11,12]
    let minutes : [Int] = [00,05,10,15,20,25,30,35,40,45,50,55]
    let meridians : [String] = ["AM", "PM"]
    var textFieldSelected = 0
    var repeatableDetails : RepeatableTaskOccurrence?
    let pickerView = UIPickerView()
    let timeCatPickerView = UIPickerView()
    var datePickerView = UIPickerView()
    var timeCatPickerDataSource : TimeCategoryPickerDataSource?
    var timeCatDelegate : TimeCategoryPickerDelegate?
    var datePickerDelegate : TaskDatePickerViewDelegate?
    let datePickerDataSource = TaskDatePickerViewDataSource()
    
    
    @IBOutlet weak var name_txtField: UITextField!
    @IBOutlet weak var start_txtField: UITextField!
    @IBOutlet weak var repeatable_btn: CheckboxButton!
    @IBOutlet weak var timeCat_txtField: UITextField!
    @IBOutlet weak var description_txtView: UITextView!
    @IBOutlet weak var startDateTextView: UITextField!
    
    override func viewDidLoad() {
        allTimeCategories = taskDTO.AllTimeCategories
        timeCatDelegate = TimeCategoryPickerDelegate(_categories: allTimeCategories, _delegate: self)
        timeCatPickerDataSource = TimeCategoryPickerDataSource(_categories: allTimeCategories)
        name_txtField.delegate = self
        start_txtField.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        timeCatPickerView.dataSource = timeCatPickerDataSource
        timeCatPickerView.delegate = timeCatDelegate
        start_txtField.inputView = pickerView
        timeCat_txtField.delegate = self
        timeCat_txtField.inputView = timeCatPickerView
        description_txtView.delegate = self
        description_txtView.layer.borderWidth = 2.0
        description_txtView.layer.borderColor = UIColor.gray.cgColor
        repeatable_btn.setImage(UIImage(named: "checkbox_unchecked"), for: .normal)
        startDateTextView.delegate = self
        datePickerDelegate = TaskDatePickerViewDelegate(_delegate: self)
        datePickerView.delegate = datePickerDelegate
        datePickerView.dataSource = datePickerDataSource
        startDateTextView.inputView = datePickerView
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
    
    // Picker view delegate/datasource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
            switch component {
            case 0:
                return 12
            case 1:
                return 12
            case 2:
                return 2
            default:
                print("Something went wrong picker view number of rows")
                return 0
            }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
            case 0:
                return String(hours[row])
            case 1:
                return String(format: "%02d", minutes[row])
            case 2:
                return meridians[row]
            default:
                print("Problem with pickerView titleForRow")
                return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let hours : String = String(self.hours[pickerView.selectedRow(inComponent: 0)])
        let minutes : String = String(format: "%02d", self.minutes[pickerView.selectedRow(inComponent: 1)])
        let meridian : String = meridians[pickerView.selectedRow(inComponent: 2)]
        start_txtField.text = "\(hours):\(minutes) \(meridian)"
        //let paddedHours = String(format: "%02d",Int(hours)!)
        startHours = "\(hours):\(minutes) \(meridian)"
    }
    
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
    
    // TaskDTODelegate
    
    func handleModelUpdate() {
        
    }
    
    func taskDidUpdate(_task: Task) {
        
    }
    
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
    
    
    @IBAction func toggleRepeatable(_ sender: AnyObject) {
        repeatable_btn.toggleChecked()
        switch repeatable {
        case true:
            repeatableDetails = nil
            repeatable = false
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
        var alertController : UIAlertController
        if name_txtField.text! != "" && description_txtView.text != "" && start_txtField.text! != "" && startDateTextView.text! != ""  {
            if repeatable {
                let task = Task(_name: name_txtField.text!, _description: description_txtView.text, _start: self.startTime, _finish: nil, _category: self.allCategories, _timeCategory: chosenTimeCategory, _repeatable: self.repeatableDetails)
                if taskDTO.createNewTask(_task: task) {
                    alertController = UIAlertController(title: "Success", message: "Task created!", preferredStyle: .alert)
                } else {
                    alertController = UIAlertController(title: "Failed", message: "Your repeatable information is invalid. Something went wrong.", preferredStyle: .alert)
                }
            } else if startDateTextView.text! != "Repeatable" && start_txtField.text! != "Repeatable" {
                // calculate start date
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM DD HH:mm a YYYY"
                let df = DateFormatter()
                df.dateFormat = "MMM"
                let year : String
                let currentMonth = Calendar.current.component(.month, from: Date())
                let scheduledMonth = Calendar.current.component(.month, from: df.date(from: startMonth!)!)
                if currentMonth < scheduledMonth {
                    year = String(Calendar.current.component(.year, from: Date()))
                } else if currentMonth == scheduledMonth {
                    let currentDay = Calendar.current.component(.day, from: Date())
                    let scheduledDay = Int(startDay!)
                    if currentDay <= scheduledDay! {
                        year = String(Calendar.current.component(.year, from: Date()))
                    } else {
                        year = String(Calendar.current.component(.year, from: Date()) + 1)
                    }
                } else {
                    year = String(Calendar.current.component(.year, from: Date()) + 1)
                }
                //print("\(startMonth!) \(startDay!) \(startHours!) \(year)")
                let date = formatter.date(from: "\(startMonth!) \(startDay!) \(startHours!) \(year)")! as NSDate
                let task = Task(_name: name_txtField.text!, _description: description_txtView.text, _start: date, _finish: nil, _category: self.allCategories, _timeCategory: chosenTimeCategory, _repeatable: nil)
                if taskDTO.createNewTask(_task: task) {
                    alertController = UIAlertController(title: "Success", message: "Task created!", preferredStyle: .alert)
                } else {
                    alertController = UIAlertController(title: "Failed", message: "Your normal information is invalid. Something went wrong.", preferredStyle: .alert)
                }
            } else {
                alertController = UIAlertController(title: "Failed", message: "Your information is invalid. Something went wrong with repeatables.", preferredStyle: .alert)
            }
        } else {
            alertController = UIAlertController(title: "Failed", message: "Please include a name, decsription, and all time information", preferredStyle: .alert)
        }
        
        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

class TimeCategoryPickerDataSource : NSObject, UIPickerViewDataSource {
    
    var allTimeCategories : [TimeCategory]?
    
    convenience init(_categories : [TimeCategory]?) {
        self.init()
        allTimeCategories = _categories
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.allTimeCategories == nil {
            return 0
        }
        return self.allTimeCategories!.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

class TimeCategoryPickerDelegate : NSObject, UIPickerViewDelegate {
    
    var allTimeCategories : [TimeCategory]?
    var delegate : CreateTaskViewController?
    
    convenience init(_categories : [TimeCategory]?, _delegate : CreateTaskViewController) {
        self.init()
        allTimeCategories = _categories
        delegate = _delegate
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.allTimeCategories![row].Name!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.timeCat_txtField.text = allTimeCategories![row].Name!
        delegate?.chosenTimeCategory = allTimeCategories![row]
    }
}

class TaskDatePickerViewDelegate : NSObject, UIPickerViewDelegate {
    
    var delegate : CreateTaskViewController?
    
    let months = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"]
    let days = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
    
    convenience init(_delegate : CreateTaskViewController) {
        self.init()
        delegate = _delegate
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            return months[row]
        case 1:
            return days[row]
        default:
            print("Something went wrong with date title for row")
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.startDateTextView.text = "\(months[pickerView.selectedRow(inComponent: 0)]) \(days[pickerView.selectedRow(inComponent: 1)])"
        //delegate?.startDay = String(format: "%02d", Int(days[pickerView.selectedRow(inComponent: 1)])!)
        delegate?.startDay = days[pickerView.selectedRow(inComponent: 1)]
        
        delegate?.startMonth = months[pickerView.selectedRow(inComponent: 0)].substring(to: months[pickerView.selectedRow(inComponent: 0)].index(months[pickerView.selectedRow(inComponent: 0)].startIndex, offsetBy: 3))
        
    }
}

class TaskDatePickerViewDataSource : NSObject, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 12
        case 1:
            return 31
        default:
            print("Something went wrong with date picker view data source")
            return 0
        }
    }
}
