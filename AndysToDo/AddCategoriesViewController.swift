//
//  AddCategoriesViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/22/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class AddCategoriesViewController: UIViewController, TaskDTODelegate {
    
    // Model
    
    var allCategories : [Category]?
    var selectedCategories : [Category]?
    let categoryDTO = CategoryDTO.shared
    let timecatDTO = TimeCategoryDTO.shared
    
    // UI values
    
    var top_y_coord : CGFloat?
    
    // Task VC
    
    var taskDelegate : UIViewController?
    
    override func viewDidLoad() {
        top_y_coord = Constants.addCatVC_starting_y_coord
        self.allCategories = categoryDTO.AllCategories
        addCategoryButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categoryDTO.delegate = self
        timecatDTO.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        categoryDTO.delegate = nil
        timecatDTO.delegate = nil
    }
    
    // TaskDTODelegate
    
    func handleModelUpdate() {
        
    }
    
    func taskDidUpdate(_task: Task) {
        
    }
    
    func addCategoryButtons() {
        if self.allCategories == nil {
            return
        }
        let checkboxesAndLabels = CheckboxesHelper.generateCheckboxesAndLabels(titles: self.allCategories!.map({ $0.Name! }), cols: 2, viewWidth: self.view.frame.width, top_y_coord: top_y_coord!)
        for (index, checkbox) in checkboxesAndLabels.0.enumerated() {
            checkbox.addTarget(self, action: #selector(toggle_category(sender:)), for: .touchUpInside)
            if !CollectionHelper.IsNilOrEmpty(_coll: selectedCategories) {
                for _cat in self.selectedCategories! {
                    if self.allCategories![index] == _cat {
                        checkbox.setImage(UIImage(named: Constants.img_checkbox_checked), for: .normal)
                        checkbox.checked = true
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.view.addSubview(checkbox)
            }
        }
        
        for lbl in checkboxesAndLabels.1 {
            DispatchQueue.main.async {
                self.view.addSubview(lbl)
            }
        }
    }
    
    func toggle_category(sender : CheckboxButton) {
        if let rootVC = taskDelegate! as? CreateTaskParentViewController {
            if sender.checked {
                rootVC.removeCategory(_category: self.allCategories![sender.tag])
            } else {
                rootVC.addCategory(_category: self.allCategories![sender.tag])
            }
            sender.toggleChecked()
        } else if let rootVC = taskDelegate! as? DisplayInactiveTaskViewController {
            if sender.checked {
                rootVC.removeCategory(_category: self.allCategories![sender.tag])
            } else {
                rootVC.addCategory(_category: self.allCategories![sender.tag])
            }
            sender.toggleChecked()
        } else {
            print("Problem casting parent view controller")
        }
        
    }
}
