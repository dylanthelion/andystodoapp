//
//  AllCategoriesTableViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/6/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private var catHandle: UInt8 = 0
private var timecatHandle : UInt8 = 0

class AllCategoriesTableViewController : UITableViewController {
    
    // ViewModel
    
    var viewModel = AllCategoriesViewModel()
    
    // Table view
    
    var dataSource : AllCategoriesTableViewDataSource?
    var delegate : AllCategoriesTableViewDelegate?
    
    override func viewDidLoad() {
        categoryModelBond.bind(dynamic: viewModel.categories!)
        timecatModelBond.bind(dynamic: viewModel.timeCategories!)
        setupTableView()
    }
    
    // Binding
    
    var categoryModelBond: Bond<[Dynamic<Category>]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &catHandle) as AnyObject? {
            return b as! Bond<[Dynamic<Category>]>
        } else {
            let b = Bond<[Dynamic<Category>]>() { [unowned self] v in
                //print("Update cat in view")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            objc_setAssociatedObject(self, &timecatHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // Setup
    
    func setupTableView() {
        dataSource = AllCategoriesTableViewDataSource(viewModel: viewModel)
        delegate = AllCategoriesTableViewDelegate(viewModel: viewModel, delegate : self)
        self.tableView.dataSource = dataSource
        self.tableView.delegate = delegate
    }
    
    // View presentation
    
    func pushCategoryEditView(at index : Int) {
        let createCatVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_create_category_VC_id) as! CreateCategoryViewController
        createCatVC.viewModel.setCategory(cat: viewModel.categories!.value[index].value)
        self.navigationController?.pushViewController(createCatVC, animated: true)
    }
    
    func pushTimecatEdit(at index : Int) {
        let createTimecatVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_create_timecat_VC_id) as! CreateTimeCategoryViewController
        createTimecatVC.viewModel.setCategory(timecat: viewModel.timeCategories!.value[index].value)
        self.navigationController?.pushViewController(createTimecatVC, animated: true)
    }
    
    func pushCreateCategory() {
        let createCatVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_create_category_VC_id) as! CreateCategoryViewController
        self.navigationController?.pushViewController(createCatVC, animated: true)
    }
    
    func pushCreateTimecat() {
        let createTimecatVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_create_timecat_VC_id) as! CreateTimeCategoryViewController
        self.navigationController?.pushViewController(createTimecatVC, animated: true)
    }
}
