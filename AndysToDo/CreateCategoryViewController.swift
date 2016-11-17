//
//  CreateCategoryViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/22/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateCategoryViewController : UIViewController, TaskDTODelegate, UITextFieldDelegate, UITextViewDelegate {
    
    // UI
    
    // Model values
    
    let categoryDTO = CategoryDTO.shared
    var category: Category?
    
    // Outlets
    
    @IBOutlet weak var name_txtField: UITextField!
    @IBOutlet weak var description_txtView: BorderedTextView!
    
    override func viewDidLoad() {
        populateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categoryDTO.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        categoryDTO.delegate = nil
    }
    
    // View setup
    
    func populateViews() {
        if let _ = category {
            name_txtField.text = category!.Name!
            description_txtView.text = category!.Description!
        }
    }
    
    func resetAfterSuccessfulSubmit() {
        DispatchQueue.main.async {
            self.name_txtField.text = ""
            self.description_txtView.text = ""
        }
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
    
    // IBActions
    
    @IBAction func submit(_ sender: AnyObject) {
        if !validateForSubmit() {
            return
        }
        
        if !validateAndSubmitCategory() {
            return
        } else {
            if category == nil {
                resetAfterSuccessfulSubmit()
            }
            return
        }
    }
    
    // Validations
    
    func validateForSubmit() -> Bool {
        if name_txtField.text! == "" || description_txtView.text == "" {
            let alertController = UIAlertController(title: Constants.standard_alert_fail_title, message: Constants.createCatVC_alert_no_name_or_description_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func validateAndSubmitCategory() -> Bool {
        if let _ = category {
            if categoryDTO.updateCategory(_oldCategory: category!, _category: Category(_name: self.name_txtField.text!, _description: self.description_txtView.text)) {
                let alertController = UIAlertController(title: Constants.standard_alert_ok_title, message: Constants.createCatVC_alert_success_message, preferredStyle: .alert)
                alertController.addAction(Constants.standard_ok_alert_action)
                self.present(alertController, animated: true, completion: nil)
                return true
            } else {
                let alertController = UIAlertController(title: Constants.standard_alert_fail_title, message: Constants.createCatVC_alert_name_uniqueness_failure_message, preferredStyle: .alert)
                alertController.addAction(Constants.standard_ok_alert_action)
                self.present(alertController, animated: true, completion: nil)
                return false
            }
        }
        if categoryDTO.createNewCategory(_category: Category(_name: name_txtField.text!, _description: description_txtView.text)) {
            let alertController = UIAlertController(title: Constants.standard_alert_ok_title, message: Constants.createCatVC_alert_success_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return true
        } else {
            let alertController = UIAlertController(title: Constants.standard_alert_fail_title, message: Constants.createCatVC_alert_name_uniqueness_failure_message, preferredStyle: .alert)
            alertController.addAction(Constants.standard_ok_alert_action)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
    }
}
