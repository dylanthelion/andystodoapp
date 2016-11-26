//
//  AddCategoriesViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/22/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private var catHandle : UInt8 = 0

class AddCategoriesViewController: UIViewController {
    
    // View Model
    
    let viewModel = AddCategoriesViewModel()
    
    // UI values
    
    var top_y_coord : CGFloat?
    var visibleLabels : [UILabel] = [UILabel]()
    var visibleButtons : [CheckboxButton] = [CheckboxButton]()
    
    // Task VC
    
    var taskDelegate : UIViewController?
    
    override func viewDidLoad() {
        top_y_coord = Constants.addCatVC_starting_y_coord
        addCategoryButtons()
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
                    self.addCategoryButtons()
                }
            }
            objc_setAssociatedObject(self, &catHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // View setup
    
    func addCategoryButtons() {
        let checkboxesAndLabels = CheckboxesHelper.generateCheckboxesAndLabels(titles: viewModel.categories!.value.map({ $0.value.Name! }), cols: 2, viewWidth: self.view.frame.width, top_y_coord: top_y_coord!)
        for (index, checkbox) in checkboxesAndLabels.0.enumerated() {
            checkbox.addTarget(self, action: #selector(toggle_category(sender:)), for: .touchUpInside)
            for _cat in viewModel.selectedCategories!.value {
                if viewModel.categories!.value[index].value == _cat.value {
                    checkbox.setImage(UIImage(named: Constants.img_checkbox_checked), for: .normal)
                    checkbox.checked = true
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
        refreshLabelsAndButtons(checkboxesAndLabels: checkboxesAndLabels)
    }
    
    // View reset
    
    func refreshView() {
        for lbl in self.visibleLabels {
            lbl.removeFromSuperview()
        }
        self.visibleLabels.removeAll()
        for chkbx in self.visibleButtons {
            chkbx.removeFromSuperview()
        }
        self.visibleButtons.removeAll()
        self.top_y_coord = Constants.filterVC_starting_y_coord
    }
    
    func refreshLabelsAndButtons(checkboxesAndLabels : ([CheckboxButton], [UILabel])) {
        visibleButtons.removeAll()
        visibleButtons.append(contentsOf: checkboxesAndLabels.0)
        visibleLabels.removeAll()
        visibleLabels.append(contentsOf: checkboxesAndLabels.1)
    }
    
    // Handle checkboxes
    
    func toggle_category(sender : CheckboxButton) {
        if let rootVC = taskDelegate! as? CreateTaskParentViewController {
            if sender.checked {
                rootVC.viewModel?.removeCategory(_category: viewModel.categories!.value[sender.tag].value)
            } else {
                rootVC.viewModel?.addCategory(_category: viewModel.categories!.value[sender.tag].value)
            }
            sender.toggleChecked()
        }  else {
            print("Problem casting parent view controller")
        }
    }
}
