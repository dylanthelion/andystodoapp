//
//  AllCategoriesTableViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/6/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class AllCategoriesTableViewController : UITableViewController, TaskDTODelegate {
    
    let categoryDTO = CategoryDTO.shared
    let timecatDTO = TimeCategoryDTO.shared
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categoryDTO.delegate = self
        timecatDTO.delegate = self
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        categoryDTO.delegate = nil
        timecatDTO.delegate = nil
    }
    
    // UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return categoryDTO.AllCategories!.count
        case 1:
            return timecatDTO.AllTimeCategories!.count
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
            cell.textLabel?.text = categoryDTO.AllCategories![indexPath.row].Name!
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.main_storyboard_timecat_table_view_cell_id, for: indexPath) as! TimecatTableViewCell
            cell.name_lbl.text = timecatDTO.AllTimeCategories![indexPath.row].Name!
            cell.time_lbl.text = "\(TimeConverter.convertFloatToTimeString(_time: timecatDTO.AllTimeCategories![indexPath.row].StartOfTimeWindow!))-\(TimeConverter.convertFloatToTimeStringWithMeridian(_time: timecatDTO.AllTimeCategories![indexPath.row].EndOfTimeWindow!))"
            if let _ = timecatDTO.AllTimeCategories![indexPath.row].color {
                cell.backgroundColor = UIColor(cgColor: timecatDTO.AllTimeCategories![indexPath.row].color!)
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
            createCatVC.category = categoryDTO.AllCategories![indexPath.row]
            self.navigationController?.pushViewController(createCatVC, animated: true)
        case 1:
            let createTimecatVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_create_timecat_VC_id) as! CreateTimeCategoryViewController
            createTimecatVC.timecat = timecatDTO.AllTimeCategories![indexPath.row]
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
