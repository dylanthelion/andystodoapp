//
//  AllTasksViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/3/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class AllTasksViewController : TaskDisplayViewController {
    
    // UI
    
    var tasksLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AllTasks = taskDTO.AllTasks
        tasksLoaded = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !tasksLoaded {
            AllTasks = taskDTO.AllTasks
            tasksLoaded = true
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        if categoryFilters != nil || timeCategoryFilters != nil {
            applyFilter()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        let cell : AllTasksTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.main_storyboard_display_task_table_view_cell_id) as! AllTasksTableViewCell
        let cellTask : Task = AllTasks![indexPath.row]
        cell.setTask(_task: cellTask)
        cell.name_lbl.text = cellTask.Name!
        if cellTask.isRepeatable() {
            cell.time_lbl.text = Constants.displayAllTasksVC_string_repeatable
        } else if let _ = cellTask.StartTime {
            cell.time_lbl.text = TimeConverter.dateToShortDateConverter(_time: cellTask.StartTime!)
        } else {
            cell.time_lbl.text = Constants.displayAllTasksVC_string_no_time
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
        let displayTaskVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_all_tasks_individuAL_VC_ID) as! AllTasksIndividualTaskViewController
        displayTaskVC.task = AllTasks![indexPath.row]
        self.navigationController?.pushViewController(displayTaskVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if AllTasks!.count == taskDTO.AllTasks!.count {
                taskDTO.AllTasks!.remove(at: indexPath.row)
            }
            let taskToDelete = AllTasks![indexPath.row]
            AllTasks!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            taskDTO.deleteTask(_task: taskToDelete)
            
        }
    }
    
    // TaskDTODelegate
    
    override func handleModelUpdate() {
        AllTasks = taskDTO.AllTasks!
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func taskDidUpdate(_task: Task) {
        _ = taskDTO.updateTask(_task: _task)
    }
    
    // Filtering
    
    func applyFilter() {
        self.AllTasks = taskDTO.applyFilterToAllTasks(categories: categoryFilters, timeCategories: timeCategoryFilters)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
