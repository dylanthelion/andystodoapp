//
//  MainTasksViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class MainTasksViewController : UITableViewController, TaskDTODelegate {
    
    var AllTasks : [Task]?
    let taskDTO = TaskDTO.globalManager
    var filterApplied = false
    var categoryFilters : [Category]?
    var timeCategoryFilters : [TimeCategory]?
    
    override func viewDidLoad() {
        self.title = "YOUR TASKS"
        taskDTO.delegate = self
        if taskDTO.AllTasks == nil {
            taskDTO.loadTasks()
        }
        
        if(!CollectionHelper.IsNilOrEmpty(_coll: categoryFilters) || !CollectionHelper.IsNilOrEmpty(_coll: timeCategoryFilters)) {
            applyFilter()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taskDTO.delegate = self
        applyFilter()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        taskDTO.delegate = nil
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
        let cell : TaskTableViewCell = tableView.dequeueReusableCell(withIdentifier: "taskTableViewCell") as! TaskTableViewCell
        let cellTask : Task = AllTasks![indexPath.row]
        cell.setTask(_task: cellTask)
        switch cellTask.inProgress {
        case true :
            cell.onItState = OnItButtonState.Active
            cell.onItButton.alpha = 1.0
        case false :
            cell.onItState = OnItButtonState.Inactive
        }
        cell.taskTitleLabel.text = cellTask.Name!
        if let _ = cellTask.StartTime {
            cell.timeLabel.text = TimeConverter.dateToTimeConverter(_time: cellTask.StartTime!)
        } else {
            cell.timeLabel.text = "No time"
        }
        
        return cell
    }
    
    // Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // TaskDTODelegate
    
    func handleModelUpdate() {
        AllTasks = taskDTO.filteredTasks
        self.tableView.reloadData()
    }
    
    func taskDidUpdate(_task: Task) {
        _ = taskDTO.updateTask(_task: _task)
    }
    
    // Filtering
    
    func applyFilter() {
        taskDTO.applyFilter(categories: categoryFilters, timeCategories: timeCategoryFilters)
    }
    
    func removeCategoryFilter(_category: Category) {
        let indexOf = self.categoryFilters?.index(of: _category)
        self.categoryFilters?.remove(at: indexOf!)
    }
    
    func removeTimeCategoryFilter(_category: TimeCategory) {
        let indexOf = self.timeCategoryFilters?.index(of: _category)
        self.timeCategoryFilters?.remove(at: indexOf!)
    }
    
    func addCategoryFilter(_category : Category) {
        if let _ = self.categoryFilters {
            self.categoryFilters?.append(_category)
        } else {
            self.categoryFilters = [_category]
        }
        
    }
    
    func addTimeCategoryFilter(_category: TimeCategory) {
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
