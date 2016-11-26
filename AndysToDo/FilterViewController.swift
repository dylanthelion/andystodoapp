

//
//  FilterViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/21/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private var catHandle: UInt8 = 0
private var timecatHandle : UInt8 = 0

class FilterViewController : UIViewController {
    
    // UI
    
    var top_y_coord : CGFloat?
    var allLabels : [UILabel]?
    var allCheckboxes : [CheckboxButton]?
    
    // ViewModel
    
    var viewModel = FilterViewModel()
    
    override func viewDidLoad() {
        top_y_coord = Constants.filterVC_starting_y_coord
        categoryModelBond.bind(dynamic: viewModel.categories!)
        timecatModelBond.bind(dynamic: viewModel.timeCategories!)
        addCategoryFilterViews()
        addTimecatFilterViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let rootVC = self.navigationController?.viewControllers[Constants.main_storyboard_main_tasks_VC_index] as? TaskFilterableViewController {
            rootVC.viewModel?.clearFilter()
        }
    }
    
    // Binding
    
    var categoryModelBond: Bond<[Dynamic<Category>]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &catHandle) as AnyObject? {
            return b as! Bond<[Dynamic<Category>]>
        } else {
            let b = Bond<[Dynamic<Category>]>() { [unowned self] v in
                //print("Update cat in view")
                DispatchQueue.main.async {
                    self.refreshView()
                    self.top_y_coord = Constants.filterVC_starting_y_coord
                    self.addCategoryFilterViews()
                    self.addTimecatFilterViews()
                }
            }
            objc_setAssociatedObject(self, &catHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    var timecatModelBond: Bond<[Dynamic<TimeCategory>]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &timecatHandle) as AnyObject? {
            return b as! Bond<[Dynamic<TimeCategory>]>
        } else {
            let b = Bond<[Dynamic<TimeCategory>]>() { [unowned self] v in
                //print("Update timecat in view")
                self.refreshView()
                self.top_y_coord = Constants.filterVC_starting_y_coord
                self.addCategoryFilterViews()
                self.addTimecatFilterViews()
            }
            objc_setAssociatedObject(self, &timecatHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // Add filter UI
    
    func addCategoryFilterViews() {
        if CollectionHelper.IsNilOrEmpty(_coll: viewModel.categories?.value) {
            allLabels = [UILabel]()
            allCheckboxes = [CheckboxButton]()
            return
        }
        let checkboxesAndLabels = CheckboxesHelper.generateCheckboxesAndLabels(titles: self.viewModel.categories!.value.map({ $0.value.Name! }), cols: 2, viewWidth: self.view.frame.width, top_y_coord: top_y_coord!)
        for btn in checkboxesAndLabels.0 {
            btn.addTarget(self, action: #selector(toggleFilter(sender:)), for: .touchUpInside)
            self.view.addSubview(btn)
        }
        for lbl in checkboxesAndLabels.1 {
            self.view.addSubview(lbl)
        }
        top_y_coord! += (Constants.filterVC_full_row_offset * (CGFloat((viewModel.categories?.value.count)! / 2)))
        top_y_coord! += (Constants.filterVC_full_row_offset * CGFloat((viewModel.categories?.value.count)! % 2))
        allLabels = checkboxesAndLabels.1
        allCheckboxes = checkboxesAndLabels.0
    }
    
    func addTimecatFilterViews() {
        if CollectionHelper.IsNilOrEmpty(_coll: viewModel.timeCategories?.value) {
            return
        }
        addTimeCategoriesHeader(y_coord: top_y_coord!)
        
        top_y_coord! += Constants.filterVC_full_header_offset
        let startingIndex : Int
        if let _ = viewModel.categories {
            startingIndex = viewModel.categories!.value.count
        } else {
            startingIndex = 0
        }
        let checkboxesAndLabels = CheckboxesHelper.generateCheckboxesAndLabels(titles: self.viewModel.timeCategories!.value.map({ $0.value.Name! }), cols: 2, viewWidth: self.view.frame.width, top_y_coord: top_y_coord!, startingIndex: startingIndex)
        for btn in checkboxesAndLabels.0 {
            btn.addTarget(self, action: #selector(toggleFilter(sender:)), for: .touchUpInside)
            self.view.addSubview(btn)
        }
        for lbl in checkboxesAndLabels.1 {
            self.view.addSubview(lbl)
        }
        self.allLabels!.append(contentsOf: checkboxesAndLabels.1)
        self.allCheckboxes!.append(contentsOf: checkboxesAndLabels.0)
    }
    
    func refreshView() {
        for lbl in self.allLabels! {
            lbl.removeFromSuperview()
        }
        self.allLabels!.removeAll()
        for chkbx in self.allCheckboxes! {
            chkbx.removeFromSuperview()
        }
        self.allCheckboxes!.removeAll()
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
        self.view.addSubview(header)
        self.allLabels!.append(header)
    }
    
    // Handle checkboxes
    
    func toggleFilter(sender : CheckboxButton) {
        
        if let rootVC = self.navigationController?.viewControllers[Constants.main_storyboard_main_tasks_VC_index] as? TaskFilterableViewController {
            if !CollectionHelper.IsNilOrEmpty(_coll: viewModel.categories?.value) {
                if sender.tag > (viewModel.categories!.value.count - 1) {
                    if sender.checked {
                        rootVC.viewModel?.removeTimeCategoryFilter(_category: viewModel.timeCategories!.value[sender.tag - viewModel.categories!.value.count].value)
                    } else {
                        rootVC.viewModel?.addTimeCategoryFilter(_category: viewModel.timeCategories!.value[sender.tag - viewModel.categories!.value.count].value)
                    }
                    
                } else {
                    if sender.checked {
                        rootVC.viewModel?.removeCategoryFilter(_category: viewModel.categories!.value[sender.tag].value)
                    } else {
                        rootVC.viewModel?.addCategoryFilter(_category: viewModel.categories!.value[sender.tag].value)
                    }
                    
                }
            } else {
                if(sender.checked) {
                    rootVC.viewModel?.removeTimeCategoryFilter(_category: viewModel.timeCategories!.value[sender.tag].value)
                } else {
                    rootVC.viewModel?.addTimeCategoryFilter(_category: viewModel.timeCategories!.value[sender.tag].value)
                }
                
            }
        }
        sender.toggleChecked()
    }
}
