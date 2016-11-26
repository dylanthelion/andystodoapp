//
//  ArchivedTasksChildTableViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/19/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private var taskHandle : UInt8 = 0

class ArchivedTasksChildTableViewController: TaskDisplayViewController {
    
    // View Model
    
    let viewModel = ArchivedTaskChildrenViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelBond.bind(dynamic: viewModel.tasksToPopulate!)
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
                //print("Update tasks in view")
                if self.viewModel.emptied {
                    self.navigationController?.popViewController(animated: true)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            objc_setAssociatedObject(self, &taskHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasksToPopulate!.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "archiveTasksChildTableViewCell", for: indexPath) as! ArchivedTasksChildTableViewCell
        //cell.setTask(_task: AllTasks![indexPath.row])
        cell.name_lbl.text = viewModel.tasksToPopulate!.value[indexPath.row].value.Name!
        cell.time_lbl.text = TimeConverter.dateToShortDateConverter(_time: viewModel.tasksToPopulate!.value[indexPath.row].value.FinishTime!)
        return cell
    }
    
    // Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskVC : DisplayArchivedTaskViewController = Constants.main_storyboard.instantiateViewController(withIdentifier: "displayArchiveVC") as! DisplayArchivedTaskViewController
        taskVC.viewModel.setTask(newTask: viewModel.tasksToPopulate!.value[indexPath.row].value)
        self.navigationController?.pushViewController(taskVC, animated: true)
    }
}
