//
//  AllTasksViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/3/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private var taskHandle : UInt8 = 0
private var filteredHandle : UInt8 = 0

class AllTasksViewController : TaskDisplayViewController {
    
    // UI
    
    //var tasksLoaded = false
    
    // View Model
    
    let viewModel = AllTasksViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelBond.bind(dynamic: viewModel.tasksToPopulate)
        filterBond.bind(dynamic: viewModel.filteredTasks!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // Binding
    
    var modelBond: Bond<[Dynamic<Task>]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &taskHandle) as AnyObject? {
            return b as! Bond<[Dynamic<Task>]>
        } else {
            let b = Bond<[Dynamic<Task>]>() { [unowned self] v in
                DispatchQueue.main.async {
                    //print("Update all in view")
                    self.tableView.reloadData()
                }
            }
            objc_setAssociatedObject(self, &taskHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
        let cell : AllTasksTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.main_storyboard_display_task_table_view_cell_id) as! AllTasksTableViewCell
        let cellTask : Task = viewModel.tasksToPopulate.value[indexPath.row].value
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.viewModel.deleteAt(index: indexPath.row)
        }
        delete.backgroundColor = UIColor.red
        let move = UITableViewRowAction(style: .normal, title: "Re-add") { action, index in
            self.viewModel.moveTaskToDayPlanner(index: indexPath.row)
            DispatchQueue.main.async {
                self.tabBarController?.selectedIndex = 0
            }
        }
        move.backgroundColor = UIColor.green
        return [move, delete]
    }
    
    // Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let displayTaskVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_all_tasks_individuAL_VC_ID) as! AllTasksIndividualTaskViewController
        displayTaskVC.viewModel.setTask(newTask: viewModel.tasksToPopulate.value[indexPath.row].value) 
        self.navigationController?.pushViewController(displayTaskVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
}
