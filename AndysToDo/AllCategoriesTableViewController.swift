//
//  AllCategoriesTableViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/6/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class AllCategoriesTableViewController : UITableViewController, TaskDTODelegate {
    
    var taskDTO = TaskDTO.globalManager
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taskDTO.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        taskDTO.delegate = nil
    }
    
    // UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return taskDTO.AllCategories!.count
        case 1:
            return taskDTO.AllTimeCategories!.count
        case 2:
            return 2
            
        default:
            print("Somethign went wrong in number of sections")
            return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableViewCell", for: indexPath) as! CategoryTableViewCell
            cell.textLabel?.text = taskDTO.AllCategories![indexPath.row].Name!
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "timecatTableViewCell", for: indexPath) as! TimecatTableViewCell
            cell.name_lbl.text = taskDTO.AllTimeCategories![indexPath.row].Name!
            cell.time_lbl.text = "\(TimeConverter.convertFloatToTimeString(_time: taskDTO.AllTimeCategories![indexPath.row].StartOfTimeWindow!))-\(TimeConverter.convertFloatToTimeStringWithMeridian(_time: taskDTO.AllTimeCategories![indexPath.row].EndOfTimeWindow!))"
            return cell
        case 2:
            switch indexPath.row {
                case 0:
                    let cell = UITableViewCell()
                    cell.textLabel?.text = "Category"
                    return cell
                case 1:
                    let cell = UITableViewCell()
                    cell.textLabel?.text = "Timecat"
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
            return "Categories"
        case 1:
            return "Timecats"
        case 2:
            return "Create:"
        default:
            print("Something went wrong in title for header")
            return ""
        }
    }
    
    // UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: Constants.main_storyboard_id, bundle:nil)
        switch indexPath.section {
        case 0:
            let createCatVC = storyBoard.instantiateViewController(withIdentifier: "createCategoryViewController") as! CreateCategoryViewController
            createCatVC.category = taskDTO.AllCategories![indexPath.row]
            self.navigationController?.pushViewController(createCatVC, animated: true)
        case 1:
            let createTimecatVC = storyBoard.instantiateViewController(withIdentifier: "createTimecatVC") as! CreateTimeCategoryViewController
            createTimecatVC.timecat = taskDTO.AllTimeCategories![indexPath.row]
            self.navigationController?.pushViewController(createTimecatVC, animated: true)
            
        case 2:
            switch indexPath.row {
                case 0:
                    let createCatVC = storyBoard.instantiateViewController(withIdentifier: "createCategoryViewController") as! CreateCategoryViewController
                    self.navigationController?.pushViewController(createCatVC, animated: true)
                case 1:
                    let createTimecatVC = storyBoard.instantiateViewController(withIdentifier: "createTimecatVC") as! CreateTimeCategoryViewController
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
