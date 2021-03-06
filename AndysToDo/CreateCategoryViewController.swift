//
//  CreateCategoryViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/22/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateCategoryViewController : UIViewController, AlertPresenter {
    
    // View Model
    
    let viewModel = CreateCategoryViewModel()
    
    // Text Fields
    
    var textFieldDelegate : CreateCategoryTextFieldDelegate?
    var textViewDelegate : CreateCategoryTextViewDelegate?
    
    // Alert Presenter
    
    var completionHandlers : [() -> Void] = [() -> Void]()
    var alertIsVisible = false
    
    // Outlets
    
    @IBOutlet weak var name_txtField: UITextField!
    @IBOutlet weak var description_txtView: BorderedTextView!
    
    override func viewDidLoad() {
        populateViews()
        setupTextFields()
    }
    
    // View setup
    
    func populateViews() {
        if let _ = viewModel.category {
            name_txtField.text = viewModel.category!.name!
            description_txtView.text = viewModel.category!.description!
        }
    }
    
    func setupTextFields() {
        textFieldDelegate = CreateCategoryTextFieldDelegate(viewModel: viewModel)
        name_txtField.delegate = textFieldDelegate
        textViewDelegate = CreateCategoryTextViewDelegate(viewModel: viewModel)
        description_txtView.delegate = textViewDelegate
    }
    
    // Reset
    
    func resetAfterSuccessfulSubmit() {
        let closure = {
            DispatchQueue.main.async {
                self.name_txtField.text = ""
                self.description_txtView.text = ""
            }
        }
        if alertIsVisible {
            completionHandlers.append(closure)
        } else {
            closure()
        }
    }
    
    // Alert Presenter
    
    func handleWillDisappear() {
        for f in completionHandlers {
            f()
        }
        completionHandlers.removeAll()
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
            let alertController = AlertHelper.presentAlertController(self, title: Constants.standard_alert_fail_title, message: Constants.createCatVC_alert_no_name_or_description_failure_message, actions: [Constants.standard_ok_alert_action])
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func validateAndSubmitCategory() -> Bool {
        if viewModel.validateAndSubmitCategory() {
            let alertController = AlertHelper.presentAlertController(self, title: Constants.standard_alert_ok_title, message: Constants.createCatVC_alert_success_message, actions: [Constants.standard_ok_alert_action])
            self.present(alertController, animated: true, completion: nil)
            return true
        } else {
            let alertController = AlertHelper.presentAlertController(self, title: Constants.standard_alert_fail_title, message: Constants.createCatVC_alert_name_uniqueness_failure_message, actions: [Constants.standard_ok_alert_action])
            self.present(alertController, animated: true, completion: nil)
            return false
        }
    }
}
