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
    
    var width : CGFloat?
    var label_width : CGFloat?
    var top_y_coord : CGFloat?
    
    // Model values
    
    var categories : [Category]?
    var timeCategories : [TimeCategory]?
    var AllTasks : TaskDTO = TaskDTO.globalManager
    
    @IBOutlet weak var categoriesLabel: UILabel!
    
    override func viewDidLoad() {
        width = self.view.frame.width / 2.0
        top_y_coord = Constants.filterVC_starting_y_coord
        label_width = width! - (Constants.filterVC_checkbox_height_and_width + Constants.filterVC_label_right_margin)
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
            let btn_add_filter = CheckboxButton(frame: CGRect(x: (Constants.filterVC_checkbox_x_coord + (width! * index_offset)), y: top_y_coord!, width: Constants.filterVC_checkbox_height_and_width, height: Constants.filterVC_checkbox_height_and_width))
            
            btn_add_filter.setImage(UIImage(named: "checkbox_unchecked"), for: .normal)
            btn_add_filter.addTarget(self, action: #selector(toggleFilter(sender:)), for: .touchUpInside)
            btn_add_filter.tag = index
            let label_add_filter = UILabel(frame: CGRect(x: ((Constants.filterVC_checkbox_x_coord + Constants.filterVC_checkbox_height_and_width
                + Constants.filterVC_label_bottom_margin) + (width! * index_offset)), y: top_y_coord!, width: label_width!, height: Constants.filterVC_checkbox_height_and_width))
            label_add_filter.text = _category.Name!
            if index % 2 == 1 {
                top_y_coord! += Constants.filterVC_full_row_offset
            }
            DispatchQueue.main.async {
                self.view.addSubview(btn_add_filter)
                self.view.addSubview(label_add_filter)
            }
        }
        if (self.categories!.count % 2 == 1) {
            top_y_coord! += Constants.filterVC_full_row_offset
        }
    }
    
    func addTimecatFilterViews() {
        if CollectionHelper.IsNilOrEmpty(_coll: self.timeCategories) {
            return
        }
        
        addTimeCategoriesHeader(y_coord: top_y_coord!)
        top_y_coord! += Constants.filterVC_full_header_offset
        for (index, _category) in self.timeCategories!.enumerated() {
            let index_offset : CGFloat = CGFloat(index % 2)
            let btn_add_filter = CheckboxButton(frame: CGRect(x: (Constants.filterVC_checkbox_x_coord + (width! * index_offset)), y: top_y_coord!, width: Constants.filterVC_checkbox_height_and_width, height: Constants.filterVC_checkbox_height_and_width))
            btn_add_filter.setImage(UIImage(named: "checkbox_unchecked"), for: .normal)
            btn_add_filter.addTarget(self, action: #selector(toggleFilter(sender:)), for: .touchUpInside)
            if let _ = self.categories {
                btn_add_filter.tag = index + self.categories!.count
            } else {
                btn_add_filter.tag = index
            }
            let label_add_filter = UILabel(frame: CGRect(x: ((Constants.filterVC_checkbox_x_coord + Constants.filterVC_checkbox_height_and_width + Constants.filterVC_label_bottom_margin) + (width! * index_offset)), y: top_y_coord!, width: label_width!, height: Constants.filterVC_checkbox_height_and_width))
            label_add_filter.text = _category.Name!
            if index % 2 == 1 {
                top_y_coord! += Constants.filterVC_full_row_offset
            }
            DispatchQueue.main.async {
                self.view.addSubview(btn_add_filter)
                self.view.addSubview(label_add_filter)
            }
        }
    }
    
    func addTimeCategoriesHeader(y_coord : CGFloat) {
        let header_height : CGFloat = Constants.filterVC_header_label_height
        let header_font_size : CGFloat = Constants.filterVC_header_font_size
        let header_x_coord : CGFloat = Constants.filterVC_header_x_coord
        let header_width : CGFloat = self.view.frame.width - (2.0 * Constants.filterVC_header_x_coord)
        let header = UILabel(frame: CGRect(x: header_x_coord, y: y_coord, width: header_width, height: header_height))
        header.font = UIFont(name: Constants.filterVC_header_font_name, size: header_font_size)
        header.textColor = Constants.filterVC_header_text_color
        header.text = Constants.filterVC_timecat_header_text
        header.textAlignment = .center
        DispatchQueue.main.async {
            self.view.addSubview(header)
        }
    }
    
    // Handle checkboxes
    
    func toggleFilter(sender : CheckboxButton) {
        
        let rootVC = self.navigationController?.viewControllers[Constants.main_storyboard_main_tasks_VC_index] as! TaskDisplayViewController
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
