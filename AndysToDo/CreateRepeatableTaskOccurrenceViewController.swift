//
//  CreateRepeatableTaskOccurrenceViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/23/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateRepeatableTaskOccurrenceViewController : UIViewController, TaskDTODelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var textFieldSelected : Int = 0
    let unitsOfTime = ["Hourly", "Daily", "Weekly"]
    let days  = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var _timeOfDay : Float?
    var _dayOfWeek : DayOfWeek?
    
    var unitOfTimePickerView = UIPickerView()
    var timeOfDayPickerView = UIPickerView()
    var datePickerView = UIPickerView()
    var dayOfWeekPicker = UIPickerView()
    var timeOfDayDelegate : TimeOfDayPickerDelegate?
    let timeOfDayDataSource : TimeOfDayPickerDataSource = TimeOfDayPickerDataSource()
    var datePickerDelegate : DatePickerViewDelegate?
    var datePickerDataSource = DatePickerViewDataSource()
    var dayOfWeekDelegate : DayOfWeekPickerViewDelegate?
    var dayOfWeekDataSource = DayOfWeekPickerViewDataSource()
    
    @IBOutlet weak var unitOfTime_txtField: UITextField!
    @IBOutlet weak var unitsPerTask_txtField: UITextField!
    @IBOutlet weak var firstTimeOfDay_txtField: UITextField!
    @IBOutlet weak var firstDate_txtField: UITextField!
    @IBOutlet weak var dayOfWeek_label: UILabel!
    @IBOutlet weak var dayOfWeek_txtField: UITextField!
    
    override func viewDidLoad() {
        unitOfTimePickerView.delegate = self
        unitOfTimePickerView.dataSource = self
        unitOfTime_txtField.delegate = self
        unitOfTime_txtField.inputView = unitOfTimePickerView
        unitsPerTask_txtField.delegate = self
        firstTimeOfDay_txtField.delegate = self
        timeOfDayDelegate = TimeOfDayPickerDelegate(_delegate: self
        )
        timeOfDayPickerView.delegate = timeOfDayDelegate!
        timeOfDayPickerView.dataSource = timeOfDayDataSource
        firstTimeOfDay_txtField.inputView = timeOfDayPickerView
        firstDate_txtField.delegate = self
        datePickerDelegate = DatePickerViewDelegate(_delegate: self)
        datePickerView.delegate = datePickerDelegate
        datePickerView.dataSource = datePickerDataSource
        firstDate_txtField.inputView = datePickerView
        dayOfWeek_txtField.delegate = self
        dayOfWeekDelegate = DayOfWeekPickerViewDelegate(_delegate: self)
        dayOfWeekPicker.delegate = dayOfWeekDelegate
        dayOfWeekPicker.dataSource = dayOfWeekDataSource
        dayOfWeek_txtField.inputView = dayOfWeekPicker
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    // TaskDTODelegate
    
    func handleModelUpdate() {
        
    }
    
    func taskDidUpdate(_task: Task) {
        
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
            addPickerViewDoneButton()
            return true
        case 1:
            return true
        case 2:
            addPickerViewDoneButton()
            return true
        case 3:
            addPickerViewDoneButton()
            return true
        case 4:
            addPickerViewDoneButton()
            return true
        default:
            print("Invalid text field tag")
            return false
        }
    }
    
    // Picker view delegate/data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return unitsOfTime[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        unitOfTime_txtField.text = unitsOfTime[row]
        if row == 2 {
            dayOfWeek_txtField.isHidden = false
            dayOfWeek_txtField.isUserInteractionEnabled = true
            dayOfWeek_label.isHidden = false
        } else {
            dayOfWeek_txtField.isHidden = true
            dayOfWeek_txtField.isUserInteractionEnabled = false
            dayOfWeek_label.isHidden = true
        }
    }
    
    func addPickerViewDoneButton() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(dismissPickerView))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func dismissPickerView() {
        switch  textFieldSelected {
        case 0:
            unitOfTime_txtField.resignFirstResponder()
        case 2:
            firstTimeOfDay_txtField.resignFirstResponder()
        case 3:
            firstDate_txtField.resignFirstResponder()
        case 4:
            dayOfWeek_txtField.resignFirstResponder()
        default:
            print("Invalid value for selected text field")
        }
        self.navigationItem.rightBarButtonItem = nil
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        var _unitOfTime : RepetitionTimeCategory?
        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        switch unitOfTime_txtField.text! {
        case "Hourly":
            _unitOfTime = .Hourly
        case "Daily":
            _unitOfTime = .Daily
        case "Weekly":
            _unitOfTime = .Weekly
        default:
            _unitOfTime = nil
        }
        if _unitOfTime == nil {
            let alertController = UIAlertController(title: "Error", message: "Choose a unit of time.", preferredStyle: .alert)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        var _numberOfUnits : Int? = Int(unitsPerTask_txtField.text!)
        if _numberOfUnits == nil {
            let alertController = UIAlertController(title: "Error", message: "Please enter a number in units per task. This is the number of hours, days, or weeks, between scheduled tasks", preferredStyle: .alert)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        if(firstDate_txtField.text! == "" || firstTimeOfDay_txtField.text! == "" || (_unitOfTime! == .Weekly && dayOfWeek_txtField.text! == "")) {
            let alertController = UIAlertController(title: "Error", message: "Please fill out all visible fields", preferredStyle: .alert)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let hour = Calendar.current.component(.hour, from: Date())
        var firstOccurrenceTimeOfDay : Float
        if _timeOfDay! >= Float(hour) {
            firstOccurrenceTimeOfDay = 24.0 - (Float(hour) - _timeOfDay!)
        } else {
            firstOccurrenceTimeOfDay = _timeOfDay! - Float(hour)
        }
        var _firstOccurrence = (Calendar.current.date(byAdding: .second, value: Int(firstOccurrenceTimeOfDay * 3600.0), to: NSDate() as Date))
        let myCalendar = NSCalendar(calendarIdentifier: .gregorian)
        //let myComponents =
        if _unitOfTime == .Weekly {
            if dayOfWeek_txtField.text! == "" || self._dayOfWeek == nil {
                // Handle error
                return
            }
            while myCalendar!.components(.weekday, from: _firstOccurrence!).weekday! != (days.index(of: dayOfWeek_txtField.text!)! + 1) {
                _firstOccurrence = Calendar.current.date(byAdding: .second, value: 86400, to: _firstOccurrence!)
                print("Adding a day")
            }
        }
        let repeatable = RepeatableTaskOccurrence(_unit: _unitOfTime!, _unitCount: _numberOfUnits!, _time: _timeOfDay, _firstOccurrence: _firstOccurrence as NSDate?, _dayOfWeek: self._dayOfWeek)
        if(!repeatable.isValid()) {
            let alertController = UIAlertController(title: "Error", message: "Your ", preferredStyle: .alert)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let rootVC = self.navigationController?.viewControllers[1] as! CreateTaskViewController
        rootVC.repeatableDetails = repeatable
        rootVC.startTime = _firstOccurrence as NSDate?
        rootVC.startDateTextView.text = "Repeatable"
        rootVC.start_txtField.text = "Repeatable"
        self.navigationController?.popToViewController(rootVC, animated: true)
    }
    
}

class DayOfWeekPickerViewDelegate : NSObject, UIPickerViewDelegate {
    
    let days  = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    let daysOfWeek : [DayOfWeek] = [.Sunday, .Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday]
    
    var delegate : CreateRepeatableTaskOccurrenceViewController?
    
    convenience init(_delegate : CreateRepeatableTaskOccurrenceViewController) {
        self.init()
        delegate = _delegate
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return days[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.dayOfWeek_txtField.text = days[row]
        delegate?._dayOfWeek = daysOfWeek[row]
    }
}

class DayOfWeekPickerViewDataSource : NSObject, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

class DatePickerViewDelegate : NSObject, UIPickerViewDelegate {
    
    var delegate : CreateRepeatableTaskOccurrenceViewController?
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let days = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
    
    convenience init(_delegate : CreateRepeatableTaskOccurrenceViewController) {
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
        delegate?.firstDate_txtField.text = "\(months[pickerView.selectedRow(inComponent: 0)]) \(days[pickerView.selectedRow(inComponent: 1)])"
    }
}

class DatePickerViewDataSource : NSObject, UIPickerViewDataSource {
    
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

class TimeOfDayPickerDelegate : NSObject, UIPickerViewDelegate {
    
    var delegate : CreateRepeatableTaskOccurrenceViewController?
    let hours : [Int] = [1,2,3,4,5,6,7,8,9,10,11,12]
    let minutes : [Int] = [00,05,10,15,20,25,30,35,40,45,50,55]
    let meridians : [String] = ["AM", "PM"]
    
    convenience init(_delegate : CreateRepeatableTaskOccurrenceViewController) {
        self.init()
        delegate = _delegate
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
            print("something went wrong title for row")
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let hours : String = String(self.hours[pickerView.selectedRow(inComponent: 0)])
        let minutes : String = String(format: "%02d", self.minutes[pickerView.selectedRow(inComponent: 1)])
        let meridian : String = meridians[pickerView.selectedRow(inComponent: 2)]
        var floatToPass : Float = 0.0
        floatToPass += Float(self.hours[pickerView.selectedRow(inComponent: 0)])
        floatToPass += (Float(self.minutes[pickerView.selectedRow(inComponent: 1)])) / 60.0
        if pickerView.selectedRow(inComponent: 2) == 1 {
            floatToPass += 12.0
        }
        delegate?.firstTimeOfDay_txtField.text = "\(hours):\(minutes) \(meridian)"
        delegate?._timeOfDay = floatToPass
    }
}

class TimeOfDayPickerDataSource : NSObject, UIPickerViewDataSource {
    
    
    
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
}
