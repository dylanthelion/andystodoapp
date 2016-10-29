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
    
    let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    
    // Model values
    
    let taskDTO = TaskDTO.globalManager
    
    // Outlets
    
    @IBOutlet weak var name_txtField: UITextField!
    @IBOutlet weak var description_txtView: UITextView!
    
    override func viewDidLoad() {
        setupTextFieldDelegation()
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
        description_txtView.delegate = self
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
            return
        }
    }
    
    // Validations
    
    func validateForSubmit() -> Bool {
        if name_txtField.text! == "" || description_txtView.text == "" {
            let alertController = UIAlertController(title: "Failed", message: "Please include a name and decsription", preferredStyle: .alert)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func validateAndSubmitCategory() -> Bool {
        if taskDTO.createNewCategory(_category: Category(_name: name_txtField.text!, _description: description_txtView.text)) {
            let alertController = UIAlertController(title: "Success", message: "Category created", preferredStyle: .alert)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            return true
        } else {
            let alertController = UIAlertController(title: "Failed", message: "That name is already taken", preferredStyle: .alert)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
    }
}
