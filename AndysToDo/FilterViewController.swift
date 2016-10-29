//
//  FilterViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/21/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class FilterViewController : UIViewController, TaskDTODelegate {
    
    // UI
    
    let x_checkbox_coord : CGFloat =  10.0
    var top_y_coord : CGFloat = 132.0
    let rowOffset : CGFloat = 40.0
    let checkbox_height : CGFloat = 30.0
    let header_offset : CGFloat = 44.0
    var width : CGFloat?
    var label_width : CGFloat?
    
    // Model values
    
    var categories : [Category]?
    var timeCategories : [TimeCategory]?
    var AllTasks : TaskDTO = TaskDTO.globalManager
    
    @IBOutlet weak var categoriesLabel: UILabel!
    
    override func viewDidLoad() {
        width = self.view.frame.width / 2.0
        label_width = width! - (checkbox_height + 20.0)
        AllTasks.delegate = self
        AllTasks.loadCategories()
        AllTasks.loadTimeCategories()
        self.handleModelUpdate()
        addCategoryFilterViews()
        addTimecatFilterViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AllTasks.delegate = nil
    }
    
    func loadCategories() {
        
    }
    
    // Add filter UI
    
    func addCategoryFilterViews() {
        if CollectionHelper.IsNilOrEmpty(_coll: self.categories) {
            return
        }
        for (index, _category) in self.categories!.enumerated() {
            let index_offset : CGFloat = CGFloat(index % 2)
            let btn_add_filter = CheckboxButton(frame: CGRect(x: (x_checkbox_coord + (width! * index_offset)), y: top_y_coord, width: checkbox_height, height: checkbox_height))
            
            btn_add_filter.setImage(UIImage(named: "checkbox_unchecked"), for: .normal)
            btn_add_filter.addTarget(self, action: #selector(toggleFilter(sender:)), for: .touchUpInside)
            btn_add_filter.tag = index
            let label_add_filter = UILabel(frame: CGRect(x: ((x_checkbox_coord + checkbox_height + 10.0) + (width! * index_offset)), y: top_y_coord, width: label_width!, height: checkbox_height))
            label_add_filter.text = _category.Name!
            if index % 2 == 1 {
                top_y_coord += rowOffset
            }
            DispatchQueue.main.async {
                self.view.addSubview(btn_add_filter)
                self.view.addSubview(label_add_filter)
            }
        }
        if (self.categories!.count % 2 == 1) {
            top_y_coord += rowOffset
        }
    }
    
    func addTimecatFilterViews() {
        if CollectionHelper.IsNilOrEmpty(_coll: self.timeCategories) {
            return
        }
        
        addTimeCategoriesHeader(y_coord: top_y_coord)
        top_y_coord += header_offset
        for (index, _category) in self.timeCategories!.enumerated() {
            let index_offset : CGFloat = CGFloat(index % 2)
            let btn_add_filter = CheckboxButton(frame: CGRect(x: (x_checkbox_coord + (width! * index_offset)), y: top_y_coord, width: checkbox_height, height: checkbox_height))
            btn_add_filter.setImage(UIImage(named: "checkbox_unchecked"), for: .normal)
            btn_add_filter.addTarget(self, action: #selector(toggleFilter(sender:)), for: .touchUpInside)
            if let _ = self.categories {
                btn_add_filter.tag = index + self.categories!.count
            } else {
                btn_add_filter.tag = index
            }
            let label_add_filter = UILabel(frame: CGRect(x: ((x_checkbox_coord + checkbox_height + 10.0) + (width! * index_offset)), y: top_y_coord, width: label_width!, height: checkbox_height))
            label_add_filter.text = _category.Name!
            if index % 2 == 1 {
                top_y_coord += rowOffset
            }
            DispatchQueue.main.async {
                self.view.addSubview(btn_add_filter)
                self.view.addSubview(label_add_filter)
            }
        }
    }
    
    func addTimeCategoriesHeader(y_coord : CGFloat) {
        let header_height : CGFloat = 34.0
        let header_font_size : CGFloat = 22.0
        let header_x_coord : CGFloat = 40.0
        let header_width : CGFloat = self.view.frame.width - 80.0
        let header = UILabel(frame: CGRect(x: header_x_coord, y: y_coord, width: header_width, height: header_height))
        header.font = UIFont(name: "Arial", size: header_font_size)
        header.textColor = UIColor.green
        header.text = "Time Categories"
        header.textAlignment = .center
        DispatchQueue.main.async {
            self.view.addSubview(header)
        }
    }
    
    // Handle checkboxes
    
    func toggleFilter(sender : CheckboxButton) {
        
        let rootVC = self.navigationController?.viewControllers[0] as! MainTasksViewController
        if !CollectionHelper.IsNilOrEmpty(_coll: self.categories) {
            if sender.tag > (self.categories!.count - 1) {
                if sender.checked {
                    rootVC.removeTimeCategoryFilter(_category: self.timeCategories![sender.tag - self.categories!.count])
                } else {
                    rootVC.addTimeCategoryFilter(_category: self.timeCategories![sender.tag - self.categories!.count])
                }
                
            } else {
                if sender.checked {
                    rootVC.removeCategoryFilter(_category: self.categories![sender.tag])
                } else {
                    rootVC.addCategoryFilter(_category: self.categories![sender.tag])
                }
                
            }
        } else {
            if(sender.checked) {
                rootVC.removeTimeCategoryFilter(_category: self.timeCategories![sender.tag])
            } else {
                rootVC.addTimeCategoryFilter(_category: self.timeCategories![sender.tag])
            }
            
        }
        sender.toggleChecked()
    }
    
    // TaskDTODelegate
    
    func taskDidUpdate(_task: Task) {
        
    }
    
    func handleModelUpdate() {
        if let _ = AllTasks.AllCategories {
            self.categories = AllTasks.AllCategories!
        }
        if let _ = AllTasks.AllTimeCategories {
            self.timeCategories = AllTasks.AllTimeCategories!
        }
    }
}
