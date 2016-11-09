//
//  MainTasksViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class MainTasksViewController : TaskDisplayViewController {
    
    // Model values
    
    var isSorted = false
    var totalTasks = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskDTO.sortDisplayedTasks(forWindow: Constants.mainTaskVC_upper_limit_calendar_unit, units: Constants.mainTaskVC_upper_limit_number_of_units)
        isSorted = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if totalTasks != taskDTO.AllTasks!.count {
            taskDTO.loadTasks()
            taskDTO.sortDisplayedTasks(forWindow: Constants.mainTaskVC_upper_limit_calendar_unit, units: Constants.mainTaskVC_upper_limit_number_of_units)
        }
        if(!CollectionHelper.IsNilOrEmpty(_coll: categoryFilters) || !CollectionHelper.IsNilOrEmpty(_coll: timeCategoryFilters)) {
            applyFilter()
        }
        if !isSorted {
            taskDTO.sortDisplayedTasks(forWindow: Constants.mainTaskVC_upper_limit_calendar_unit, units: Constants.mainTaskVC_upper_limit_number_of_units)
            isSorted = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isSorted = false
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
        let cell : TaskTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.task_table_view_cell_id) as! TaskTableViewCell
        let cellTask : Task = AllTasks![indexPath.row]
        cell.setTask(_task: cellTask)
        switch cellTask.inProgress {
        case true :
            cell.onItState = OnItButtonState.Active
            cell.onItButton.alpha = Constants.alpha_solid
        case false :
            cell.onItState = OnItButtonState.Inactive
        }
        cell.taskTitleLabel.text = cellTask.Name!
        if let _ = cellTask.StartTime {
            cell.timeLabel.text = TimeConverter.dateToTimeConverter(_time: cellTask.StartTime!)
        }
        if let _ = cellTask.TimeCategory?.color {
            cell.backgroundColor = UIColor(cgColor: cellTask.TimeCategory!.color!)
        } else {
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    // Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if AllTasks![indexPath.row].inProgress {
            let displayActiveTaskVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_activeTask_VC_id) as! DisplayActiveTaskViewController
            displayActiveTaskVC.task = AllTasks![indexPath.row]
            self.navigationController?.pushViewController(displayActiveTaskVC, animated: true)
        } else {
            let displayInactiveTaskVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_inactiveTask_VC_id) as! DisplayInactiveTaskViewController
            displayInactiveTaskVC.task = AllTasks![indexPath.row]
            self.navigationController?.pushViewController(displayInactiveTaskVC, animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if AllTasks!.count == taskDTO.tasksToPopulate!.count {
                taskDTO.tasksToPopulate!.remove(at: indexPath.row)
            }
            AllTasks!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // TaskDTODelegate
    
    override func handleModelUpdate() {
        AllTasks = taskDTO.tasksToPopulate!
        totalTasks = taskDTO.AllTasks!.count
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func taskDidUpdate(_task: Task) {
        _ = taskDTO.updateTask(_task: _task)
    }
    
    // Filtering
    
    func applyFilter() {
        taskDTO.applyFilter(categories: categoryFilters, timeCategories: timeCategoryFilters)
    }
}
