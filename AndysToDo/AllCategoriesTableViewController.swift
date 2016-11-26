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
    
    override func viewDidLoad() {
        categoryModelBond.bind(dynamic: viewModel.categories!)
        timecatModelBond.bind(dynamic: viewModel.timeCategories!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
    
    // UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.categories!.value.count
        case 1:
            return viewModel.timeCategories!.value.count
        case 2:
            return 2
            
        default:
            print("Something went wrong in number of sections")
            return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.main_storyboard_category_table_view_cell_id, for: indexPath) as! CategoryTableViewCell
            cell.textLabel?.text = viewModel.categories!.value[indexPath.row].value.Name!
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.main_storyboard_timecat_table_view_cell_id, for: indexPath) as! TimecatTableViewCell
            cell.name_lbl.text = viewModel.timeCategories!.value[indexPath.row].value.Name!
            cell.time_lbl.text = "\(TimeConverter.convertFloatToTimeString(_time: viewModel.timeCategories!.value[indexPath.row].value.StartOfTimeWindow!))-\(TimeConverter.convertFloatToTimeStringWithMeridian(_time: viewModel.timeCategories!.value[indexPath.row].value.EndOfTimeWindow!))"
            if let _ = viewModel.timeCategories!.value[indexPath.row].value.color {
                cell.backgroundColor = UIColor(cgColor: viewModel.timeCategories!.value[indexPath.row].value.color!)
            }
            return cell
        case 2:
            switch indexPath.row {
                case 0:
                    let cell = UITableViewCell()
                    cell.textLabel?.text = Constants.allCategoriesVC_category_cell_title
                    return cell
                case 1:
                    let cell = UITableViewCell()
                    cell.textLabel?.text = Constants.allCategoriesVC_timecat_cell_title
                    return cell
                default:
                print("Something went wrong in cell for row")
                return UITableViewCell()
            }
        default:
            print("Something went wrong in cell for row")
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return Constants.allCategoriesVC_category_table_header
        case 1:
            return Constants.allCategoriesVC_timecat_table_header
        case 2:
            return Constants.allCategoriesVC_create_table_header
        default:
            print("Something went wrong in title for header")
            return ""
        }
    }
    
    // UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let createCatVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_create_category_VC_id) as! CreateCategoryViewController
            createCatVC.viewModel.setCategory(cat: viewModel.categories!.value[indexPath.row].value)
            self.navigationController?.pushViewController(createCatVC, animated: true)
        case 1:
            let createTimecatVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_create_timecat_VC_id) as! CreateTimeCategoryViewController
            createTimecatVC.viewModel.setCategory(timecat: viewModel.timeCategories!.value[indexPath.row].value)
            self.navigationController?.pushViewController(createTimecatVC, animated: true)
            
        case 2:
            switch indexPath.row {
                case 0:
                    let createCatVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_create_category_VC_id) as! CreateCategoryViewController
                    self.navigationController?.pushViewController(createCatVC, animated: true)
                case 1:
                    let createTimecatVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_create_timecat_VC_id) as! CreateTimeCategoryViewController
                    self.navigationController?.pushViewController(createTimecatVC, animated: true)
                default:
                    print("Something went wrong in did select")
                return
            }
        default:
            print("Something went wrong in did select")
            return
        }
    }
    
    // TaskDTODelegate
    
    func handleModelUpdate() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func taskDidUpdate(_task: Task) {
        
    }
}
