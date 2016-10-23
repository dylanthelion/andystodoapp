//
//  CreateCategoryViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/22/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateCategoryViewController : UIViewController, TaskDTODelegate, UITextFieldDelegate, UITextViewDelegate {
    
    let taskDTO = TaskDTO.globalManager
    
    @IBOutlet weak var name_txtField: UITextField!
    @IBOutlet weak var description_txtView: UITextView!
    
    override func viewDidLoad() {
        name_txtField.delegate = self
        description_txtView.delegate = self
        description_txtView.layer.borderWidth = 2.0
        description_txtView.layer.borderColor = UIColor.gray.cgColor
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
    
    // Submit button
    
    @IBAction func submit(_ sender: AnyObject) {
        var alertController : UIAlertController
        if name_txtField.text! != "" && description_txtView.text != "" {
            if taskDTO.createNewCategory(_category: Category(_name: name_txtField.text!, _description: description_txtView.text)) {
                // Handle success. Unwind?
                alertController = UIAlertController(title: "Success", message: "Category created", preferredStyle: .alert)
                print("Success")
            } else {
                // Handle uniquness failure
                alertController = UIAlertController(title: "Failed", message: "That name is already taken", preferredStyle: .alert)
                print("No unique name")
            }
        } else {
            alertController = UIAlertController(title: "Failed", message: "Please include a name and decsription", preferredStyle: .alert)
            print("A field is null")
            // Handle null data failure
        }
        
        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
