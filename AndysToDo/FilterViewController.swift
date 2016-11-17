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
    
    var top_y_coord : CGFloat?
    
    // Model values
    
    var categories : [Category]?
    var timeCategories : [TimeCategory]?
    var AllTasks : TaskDTO = TaskDTO.globalManager
    let categoryDTO = CategoryDTO.shared
    let timecatDTO = TimeCategoryDTO.shared
    
    override func viewDidLoad() {
        top_y_coord = Constants.filterVC_starting_y_coord
        AllTasks.delegate = self
        categoryDTO.loadCategories()
        timecatDTO.loadTimeCategories()
        self.handleModelUpdate()
        addCategoryFilterViews()
        addTimecatFilterViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AllTasks.delegate = nil
        categoryDTO.delegate = nil
        timecatDTO.delegate = nil
    }
    
    func loadCategories() {
        
    }
    
    // Add filter UI
    
    func addCategoryFilterViews() {
        if CollectionHelper.IsNilOrEmpty(_coll: self.categories) {
            return
        }
        let checkboxesAndLabels = CheckboxesHelper.generateCheckboxesAndLabels(titles: self.categories!.map({ $0.Name! }), cols: 2, viewWidth: self.view.frame.width, top_y_coord: top_y_coord!)
        for btn in checkboxesAndLabels.0 {
            btn.addTarget(self, action: #selector(toggleFilter(sender:)), for: .touchUpInside)
            DispatchQueue.main.async {
                self.view.addSubview(btn)
            }
        }
        for lbl in checkboxesAndLabels.1 {
            DispatchQueue.main.async {
                self.view.addSubview(lbl)
            }
        }
        top_y_coord! += (Constants.filterVC_full_row_offset * (CGFloat((categories?.count)! / 2)))
        top_y_coord! += (Constants.filterVC_full_row_offset * CGFloat((categories?.count)! % 2))
    }
    
    func addTimecatFilterViews() {
        if CollectionHelper.IsNilOrEmpty(_coll: self.timeCategories) {
            return
        }
        
        addTimeCategoriesHeader(y_coord: top_y_coord!)
        
        top_y_coord! += Constants.filterVC_full_header_offset
        let startingIndex : Int
        if let _ = categories {
            startingIndex = categories!.count
        } else {
            startingIndex = 0
        }
        let checkboxesAndLabels = CheckboxesHelper.generateCheckboxesAndLabels(titles: self.timeCategories!.map({ $0.Name! }), cols: 2, viewWidth: self.view.frame.width, top_y_coord: top_y_coord!, startingIndex: startingIndex)
        for btn in checkboxesAndLabels.0 {
            btn.addTarget(self, action: #selector(toggleFilter(sender:)), for: .touchUpInside)
            DispatchQueue.main.async {
                self.view.addSubview(btn)
            }
        }
        for lbl in checkboxesAndLabels.1 {
            DispatchQueue.main.async {
                self.view.addSubview(lbl)
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
        if let _ = categoryDTO.AllCategories {
            self.categories = categoryDTO.AllCategories!
        }
        if let _ = timecatDTO.AllTimeCategories {
            self.timeCategories = timecatDTO.AllTimeCategories!
        }
    }
}
