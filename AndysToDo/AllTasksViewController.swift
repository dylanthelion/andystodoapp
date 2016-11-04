//
//  AllTasksViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/3/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class AllTasksViewController : TaskDisplayViewController, TaskDTODelegate {
    
    // UI
    
    var filterApplied = false
    var tasksLoaded = false
    
    // Model values
    
    let taskDTO = TaskDTO.globalManager
    
    override func viewDidLoad() {
        self.title = Constants.mainTasksVCTitle
        taskDTO.delegate = self
        if taskDTO.AllTasks == nil {
            taskDTO.loadTasks()
        }
        AllTasks = taskDTO.AllTasks
        tasksLoaded = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taskDTO.delegate = self
        if !tasksLoaded {
            AllTasks = taskDTO.AllTasks
            tasksLoaded = true
        }
        if(!CollectionHelper.IsNilOrEmpty(_coll: categoryFilters) || !CollectionHelper.IsNilOrEmpty(_coll: timeCategoryFilters)) {
            applyFilter()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        taskDTO.delegate = nil
        categoryFilters = nil
        timeCategoryFilters = nil
        tasksLoaded = false
    }
    
    // Table View datasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = AllTasks {
            return AllTasks!.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : AllTasksTableViewCell = tableView.dequeueReusableCell(withIdentifier: "allTasksTableViewCell") as! AllTasksTableViewCell
        let cellTask : Task = AllTasks![indexPath.row]
        cell.setTask(_task: cellTask)
        cell.name_lbl.text = cellTask.Name!
        if cellTask.isRepeatable() {
            cell.time_lbl.text = "Repeatable"
        } else if let _ = cellTask.StartTime {
            cell.time_lbl.text = TimeConverter.dateToShortDateConverter(_time: cellTask.StartTime!)
        } else {
            cell.time_lbl.text = "No time"
        }
        if let _ = cellTask.TimeCategory?.color {
            cell.backgroundColor = UIColor.init(cgColor: (cellTask.TimeCategory?.color!)!)
        } else {
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    // Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: Constants.main_storyboard_id, bundle:nil)
        let displayTaskVC = storyBoard.instantiateViewController(withIdentifier: "allTasksIndividualVC") as! AllTasksIndividualTaskViewController
        displayTaskVC.task = AllTasks![indexPath.row]
        self.navigationController?.pushViewController(displayTaskVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if AllTasks!.count == taskDTO.AllTasks!.count {
                taskDTO.AllTasks!.remove(at: indexPath.row)
            }
            AllTasks!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // TaskDTODelegate
    
    func handleModelUpdate() {
        AllTasks = taskDTO.AllTasks!
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func taskDidUpdate(_task: Task) {
        _ = taskDTO.updateTask(_task: _task)
    }
    
    // Filtering
    
    func applyFilter() {
        self.AllTasks = taskDTO.applyFilterToAllTasks(categories: categoryFilters, timeCategories: timeCategoryFilters)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func removeCategoryFilter(_category: Category) {
        let indexOf = self.categoryFilters?.index(of: _category)
        self.categoryFilters?.remove(at: indexOf!)
    }
    
    override func removeTimeCategoryFilter(_category: TimeCategory) {
        let indexOf = self.timeCategoryFilters?.index(of: _category)
        self.timeCategoryFilters?.remove(at: indexOf!)
    }
    
    override func addCategoryFilter(_category : Category) {
        if let _ = self.categoryFilters {
            self.categoryFilters?.append(_category)
        } else {
            self.categoryFilters = [_category]
        }
    }
    
    override func addTimeCategoryFilter(_category: TimeCategory) {
        if let _ = self.timeCategoryFilters {
            self.timeCategoryFilters?.append(_category)
        } else {
            self.timeCategoryFilters = [_category]
        }
    }
    
    // Segues
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(true) {
            if let _ = self.categoryFilters {
                self.categoryFilters?.removeAll()
            }
            if let _ = self.timeCategoryFilters {
                self.timeCategoryFilters?.removeAll()
            }
        }
        
        return true
    }
}
