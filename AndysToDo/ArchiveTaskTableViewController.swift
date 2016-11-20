//
//  ArchiveTaskTableViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/19/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class ArchiveTaskTableViewController : TaskDisplayViewController {
    
    // UI
    
    var sorted = false
    var sortParam : TaskSortParameter = .Date
    
    // Model values
    
    var childTasks : [Task]?
    
    // Outlets
    @IBOutlet weak var sort_btn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadArchivedTasks()
        sorted = true
        sort_btn.title = "Sort Date"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !sorted {
            loadArchivedTasks()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        if categoryFilters != nil || timeCategoryFilters != nil {
            AllTasks = taskDTO.applyFilterToTasks(_tasks : AllTasks!, categories : categoryFilters, timeCategories : timeCategoryFilters)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sorted = false
    }
    
    // Load tasks
    
    func loadArchivedTasks() {
        taskDTO.sortArchivedTasks()
        AllTasks = taskDTO.archivedTasks
        removeChildren()
    }
    
    // Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllTasks!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allTasksArchiveTableViewCell", for: indexPath) as! ArchivedTasksTableViewCells
        cell.setTask(_task: AllTasks![indexPath.row])
        cell.name_lbl.text = AllTasks![indexPath.row].Name!
        cell.time_lbl.text = TimeConverter.dateToShortDateConverter(_time: AllTasks![indexPath.row].FinishTime!)
        if let _ = AllTasks![indexPath.row].TimeCategory?.color {
            cell.backgroundColor = UIColor(cgColor: AllTasks![indexPath.row].TimeCategory!.color!)
        }
        return cell
    }
    
    // Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenTask = AllTasks![indexPath.row]
        if CollectionHelper.IsNilOrEmpty(_coll: chosenTask.unwrappedRepeatables) {
            pushTaskInfoView(_task: chosenTask)
            return
        }
        var childTasksToDisplay = [Task]()
        for _child in childTasks! {
            if _child.parentID! == chosenTask.ID! {
                childTasksToDisplay.append(_child)
            }
        }
        if childTasksToDisplay.count > 0 {
            pushChildrenTableView(_tasks: childTasksToDisplay)
            return
        } else {
            pushTaskInfoView(_task: chosenTask)
            return
        }
    }
    
    // Present didselect view
    
    func pushChildrenTableView(_tasks : [Task]) {
        let childVC : ArchivedTasksChildTableViewController = Constants.main_storyboard.instantiateViewController(withIdentifier: "archivedTasksChildVC") as! ArchivedTasksChildTableViewController
        childVC.AllTasks = _tasks
        self.navigationController?.pushViewController(childVC, animated: true)
    }
    
    func pushTaskInfoView(_task : Task) {
        let taskVC : DisplayArchivedTaskViewController = Constants.main_storyboard.instantiateViewController(withIdentifier: "displayArchiveVC") as! DisplayArchivedTaskViewController
        taskVC.task = _task
        self.navigationController?.pushViewController(taskVC, animated: true)
    }
    
    // Filter children from model
    
    func removeChildren() {
        if childTasks == nil {
            childTasks = [Task]()
        }
        for _parent in AllTasks! {
            for _child in AllTasks! {
                if _child.parentID == nil {
                    continue
                }
                if _parent.ID! == _child.parentID! && childTasks!.index(of: _child) == nil {
                    childTasks!.append(_child)
                }
            }
        }
        for _task in childTasks! {
            AllTasks!.remove(at: AllTasks!.index(of: _task)!)
        }
    }
    
    // IB Actions
    
    @IBAction func sort(_ sender: AnyObject) {
        switch sortParam {
        case .Date:
            sortParam = .Name
            sort_btn.title = "Sort Name"
            AllTasks!.sort(by: {
                return $0.Name! < $1.Name!
            })
        case .Name:
            sortParam = .Date
            sort_btn.title = "Sort Date"
            AllTasks!.sort(by: {
                return ($0.FinishTime! as Date) < ($1.FinishTime! as Date)
            })
        }
        print("Sorted")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

enum TaskSortParameter {
    case Name
    case Date
}
