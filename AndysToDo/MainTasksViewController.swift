//
//  MainTasksViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private var handle: UInt8 = 0
private var filteredHandle : UInt8 = 0

class MainTasksViewController : TaskDisplayViewController {
    
    // View Model
    
    let viewModel = PopulatedTasksVM()
    
    // Model values
    
    //var isSorted = false
    //var filtered = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modelBond.bind(dynamic: viewModel.tasksToPopulate)
        self.filterBond.bind(dynamic: viewModel.filteredTasks!)
        for _task in viewModel.tasksToPopulate.value {
            if _task.value.inProgress {
                self.presentActiveTaskController(_task: _task.value)
                break
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // Bonding
    
    var modelBond: Bond<[Dynamic<Task>]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as! Bond<[Dynamic<Task>]>
        } else {
            let b = Bond<[Dynamic<Task>]>() { [unowned self] v in
                DispatchQueue.main.async {
                    //print("Update all in view")
                    self.tableView.reloadData()
                }
            }
            objc_setAssociatedObject(self, &handle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    var filterBond: Bond<[Dynamic<Task>]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &filteredHandle) as AnyObject? {
            return b as! Bond<[Dynamic<Task>]>
        } else {
            let b = Bond<[Dynamic<Task>]>() { [unowned self] v in
                DispatchQueue.main.async {
                    //print("Apply filter in view")
                    self.tableView.reloadData()
                }
            }
            objc_setAssociatedObject(self, &filteredHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // Table View datasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasksToPopulate.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TaskTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.task_table_view_cell_id) as! TaskTableViewCell
        let cellTask : Task = viewModel.tasksToPopulate.value[indexPath.row].value
        cell.setTask(_task: cellTask)
        switch cellTask.inProgress {
        case true :
            cell.onItButton.alpha = Constants.alpha_solid
        case false :
            cell.onItButton.alpha = Constants.alpha_faded
        }
        cell.taskTitleLabel.text = cellTask.Name!
        if let _ = cellTask.StartTime {
            cell.timeLabel.text = TimeConverter.dateToTimeWithMeridianConverter(_time: cellTask.StartTime!)
        }
        if let _ = cellTask.FinishTime {
            cell.onItButton.setTitle(Constants.taskTableViewCell_done, for: .normal)
        } else {
            cell.onItButton.setTitle(Constants.taskTableViewCell_onIt, for: .normal)
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
        if viewModel.tasksToPopulate.value[indexPath.row].value.inProgress {
            self.presentActiveTaskController(_task: viewModel.tasksToPopulate.value[indexPath.row].value)
        } else {
            self.presentInactiveTaskController(_task: viewModel.tasksToPopulate.value[indexPath.row].value)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteAt(index: indexPath.row)
        }
    }
    
    // Filtering
    
    /*func applyFilter() {
        viewModel.applyFilter()
    }
    
    func clearFilter() {
        viewModel.clearFilter()
    }*/
    
    // Present task
    
    func presentActiveTaskController(_task : Task) {
        let displayActiveTaskVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_activeTask_VC_id) as! DisplayActiveTaskViewController
        displayActiveTaskVC.viewModel.task = Dynamic(_task)
        self.navigationController?.pushViewController(displayActiveTaskVC, animated: true)
    }
    
    func presentInactiveTaskController(_task : Task) {
        let displayInactiveTaskVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_inactiveTask_VC_id) as! DisplayInactiveTaskViewController
        displayInactiveTaskVC.viewModel.setTask(newTask: _task)
        self.navigationController?.pushViewController(displayInactiveTaskVC, animated: true)
    }}
