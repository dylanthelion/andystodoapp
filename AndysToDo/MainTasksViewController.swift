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
        taskDTO.sortDisplayedTasks(forWindow: .day, units: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taskDTO.delegate = self
        applyFilter()
        taskDTO.sortDisplayedTasks(forWindow: .day, units: 1)
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
            //print("Tasks: \(AllTasks!.count)")
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
        print("Handle")
        AllTasks = taskDTO.tasksToPopulate!
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
    
    // Generate repeatable tasks
    
    func populateRepeatables() {
        if AllTasks == nil {
            return
        }
        let tempTasks = taskDTO.tasksToPopulate!
        for _task in tempTasks {
            if _task.isRepeatable() {
                let indexOf = taskDTO.tasksToPopulate!.index(of: _task)
                
                taskDTO.tasksToPopulate!.remove(at: indexOf!)
                for i in 0...3 {
                    var units = i
                    let component : Calendar.Component
                    if _task.RepeatableTask!.UnitOfTime! == .Daily {
                        component = .day
                    } else if _task.RepeatableTask!.UnitOfTime! == .Hourly {
                        component = .hour
                    } else {
                        component = .day
                        units *= 7
                    }
                    let taskToAdd = Task(_name: "\(_task.Name!)\(i)", _description: _task.Description!, _start: (NSCalendar.current.date(byAdding: component, value: units, to: _task.StartTime! as Date)! as NSDate), _finish: nil, _category: _task.Categories, _timeCategory: _task.TimeCategory, _repeatable: nil)
                    taskToAdd.ID = Int(NSDate().timeIntervalSince1970) + Int(_task.StartTime!.timeIntervalSince1970)
                    taskDTO.tasksToPopulate!.append(taskToAdd)
                }
            }
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
