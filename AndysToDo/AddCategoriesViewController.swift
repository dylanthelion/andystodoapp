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
    
    var top_y_coord : CGFloat = 80.0
    let label_x_coord : CGFloat = 70.0
    let button_x_coord : CGFloat = 30.0
    let label_width : CGFloat = 200.0
    let button_width : CGFloat = 30.0
    let item_height : CGFloat = 30.0
    var currentTag : Int = 0
    let row_diff : CGFloat = 40.0
    
    
    
    override func viewDidLoad() {
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
            let checkbox = CheckboxButton(frame: CGRect(x: button_x_coord, y: top_y_coord, width: button_width, height: item_height))
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
            let name_label = UILabel(frame: CGRect(x: label_x_coord, y: top_y_coord, width: label_width, height: item_height))
            name_label.text = _category.Name!
            top_y_coord += row_diff
            currentTag += 1
            DispatchQueue.main.async {
                self.view.addSubview(checkbox)
                self.view.addSubview(name_label)
            }
        }
    }
    
    func toggle_category(sender : CheckboxButton) {
        let rootVC = self.navigationController?.viewControllers[1] as! CreateTaskViewController
        if sender.checked {
            rootVC.removeCategory(_category: self.allCategories![sender.tag])
        } else {
            rootVC.addCategory(_category: self.allCategories![sender.tag])
        }
        sender.toggleChecked()
    }
}
