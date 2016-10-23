//
//  CreateTimeCategoryViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/22/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateTimeCategoryViewController : UIViewController, TaskDTODelegate, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let taskDTO = TaskDTO.globalManager
    let hours : [Int] = [1,2,3,4,5,6,7,8,9,10,11,12]
    let minutes : [Int] = [00,05,10,15,20,25,30,35,40,45,50,55]
    let meridians : [String] = ["AM", "PM"]
    var startTxtFieldIsSelected = false
    let pickerView = UIPickerView()
    
    @IBOutlet weak var name_txtField: UITextField!
    
    @IBOutlet weak var start_txtField: UITextField!
    
    @IBOutlet weak var end_txtField: UITextField!
    
    @IBOutlet weak var description_txtView: UITextView!
    
    override func viewDidLoad() {
        name_txtField.delegate = self
        start_txtField.delegate = self
        end_txtField.delegate = self
        description_txtView.delegate = self
        description_txtView.layer.borderWidth = 2.0
        description_txtView.layer.borderColor = UIColor.gray.cgColor
        pickerView.delegate = self
        pickerView.dataSource = self
        self.start_txtField.inputView = pickerView
        self.end_txtField.inputView = pickerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taskDTO.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        taskDTO.delegate = nil
    }
    
    // TaskDTODelegate
    
    func handleModelUpdate() {
        
    }
    
    func taskDidUpdate(_task: Task) {
        
    }
    
    // Text Delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            return true
        case 1:
            startTxtFieldIsSelected = true
            addPickerViewDoneButton()
            return true
        case 2:
            startTxtFieldIsSelected = false
            addPickerViewDoneButton()
            return true
        default:
            print("Invalid text field tag")
            return false
        }
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
            print("something went wrong title for row")
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let hours : String = String(self.hours[pickerView.selectedRow(inComponent: 0)])
        let minutes : String = String(format: "%02d", self.minutes[pickerView.selectedRow(inComponent: 1)])
        let meridian : String = meridians[pickerView.selectedRow(inComponent: 2)]
        switch startTxtFieldIsSelected {
        case true:
            start_txtField.text = "\(hours):\(minutes) \(meridian)"
        case false:
            end_txtField.text = "\(hours):\(minutes) \(meridian)"
        }
    }
    
    func addPickerViewDoneButton() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(dismissPickerView))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func dismissPickerView() {
        switch  startTxtFieldIsSelected {
        case true:
            start_txtField.resignFirstResponder()
        case false:
            end_txtField.resignFirstResponder()
        }
        self.navigationItem.rightBarButtonItem = nil
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        var alertController : UIAlertController
        if name_txtField.text! != "" && description_txtView.text != "" && start_txtField.text != "" && end_txtField.text != "" {
            if taskDTO.createNewCategory(_category: Category(_name: name_txtField.text!, _description: description_txtView.text)) {
                // Handle success. Unwind?
                alertController = UIAlertController(title: "Success", message: "Category created", preferredStyle: .alert)
            } else {
                // Handle uniquness failure
                alertController = UIAlertController(title: "Failed", message: "That name is already taken", preferredStyle: .alert)
            }
        } else {
            alertController = UIAlertController(title: "Failed", message: "Please include a name, decsription, and a full time window", preferredStyle: .alert)
            // Handle null data failure
        }
        
        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
