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
    let taskDTO = TaskDTO.globalManager
    
    // UI values
    
    var top_y_coord : CGFloat?
    var currentTag : Int = 0
    
    // Task VC
    
    var taskDelegate : UIViewController?
    
    override func viewDidLoad() {
        top_y_coord = Constants.addCatVC_starting_y_coord
        self.view.backgroundColor = UIColor.white
        self.allCategories = taskDTO.AllCategories
        addCategoryButtons()
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
    
    func addCategoryButtons() {
        if self.allCategories == nil {
            return
        }
        
        
        for _category in self.allCategories! {
            let checkbox = CheckboxButton(frame: CGRect(x: Constants.addCatVC_button_x_coord, y: top_y_coord!, width: Constants.addCatVC_button_width, height: Constants.addCatVC_item_height))
            checkbox.tag = currentTag
            checkbox.addTarget(self, action: #selector(toggle_category(sender:)), for: .touchUpInside)
            checkbox.setImage(UIImage(named: "checkbox_unchecked"), for: .normal)
            if let _ = self.selectedCategories {
                for _cat in self.selectedCategories! {
                    if _category == _cat {
                        checkbox.setImage(UIImage(named: "checkbox_checked"), for: .normal)
                        checkbox.checked = true
                    }
                }
            }
            let name_label = UILabel(frame: CGRect(x: Constants.addCatVC_label_x_coord, y: top_y_coord!, width: Constants.addCatVC_label_width, height: Constants.addCatVC_item_height))
            name_label.text = _category.Name!
            top_y_coord! += Constants.addCatVC_row_diff
            currentTag += 1
            DispatchQueue.main.async {
                self.view.addSubview(checkbox)
                self.view.addSubview(name_label)
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
