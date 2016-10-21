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
    
    override func viewDidLoad() {
        self.title = "YOUR TASKS"
        taskDTO.delegate = self
        taskDTO.loadTasks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taskDTO.delegate = self
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
        AllTasks = taskDTO.AllTasks
        self.tableView.reloadData()
    }
    
    func taskDidUpdate(_task: Task) {
        _ = taskDTO.updateTask(_task: _task)
    }
}
