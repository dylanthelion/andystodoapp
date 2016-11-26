//
//  CreateCategoryViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/22/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateCategoryViewController : UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    // View Model
    
    let viewModel = CreateCategoryViewModel()
    
    // Outlets
    
    @IBOutlet weak var name_txtField: UITextField!
    @IBOutlet weak var description_txtView: BorderedTextView!
    
    override func viewDidLoad() {
        populateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    // View setup
    
    func populateViews() {
        if let _ = viewModel.category {
            name_txtField.text = viewModel.category!.Name!
            description_txtView.text = viewModel.category!.Description!
        }
    }
    
    func resetAfterSuccessfulSubmit() {
        DispatchQueue.main.async {
            self.name_txtField.text = ""
            self.description_txtView.text = ""
        }
    }
    
    // Text Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.name = textField.text!
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        viewModel.name = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        viewModel.description = (textView.text as NSString).replacingCharacters(in: range, with: text)
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
        } else if viewModel.category == nil {
            resetAfterSuccessfulSubmit()
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
        if viewModel.validateAndSubmitCategory() {
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
