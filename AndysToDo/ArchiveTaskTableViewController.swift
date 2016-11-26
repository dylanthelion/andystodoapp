//
//  ArchiveTaskTableViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/19/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private var taskHandle : UInt8 = 0
private var filteredHandle : UInt8 = 0

class ArchiveTaskTableViewController : TaskDisplayViewController {
    
    
    // View Model
    
    let viewModel = ArchiveTaskViewModel()
    
    // Outlets
    @IBOutlet weak var sort_btn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelBond.bind(dynamic: viewModel.tasksToPopulate)
        filterBond.bind(dynamic: viewModel.filteredTasks!)
        sort_btn.title = "DATE"
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
                    //print("Apply filter in view")
                    switch self.viewModel.sortParam {
                    case .Date :
                        self.sort_btn.title = "DATE"
                    case .Name:
                        self.sort_btn.title = "NAME"
                    }
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
                    switch self.viewModel.sortParam {
                        case .Date :
                            self.sort_btn.title = "DATE"
                        case .Name:
                            self.sort_btn.title = "NAME"
                    }
                    self.tableView.reloadData()
                }
            }
            objc_setAssociatedObject(self, &filteredHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasksToPopulate.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allTasksArchiveTableViewCell", for: indexPath) as! ArchivedTasksTableViewCells
        //cell.setTask(_task: AllTasks![indexPath.row])
        cell.name_lbl.text = viewModel.tasksToPopulate.value[indexPath.row].value.Name!
        cell.time_lbl.text = TimeConverter.dateToShortDateConverter(_time: viewModel.tasksToPopulate.value[indexPath.row].value.FinishTime!)
        if let _ = viewModel.tasksToPopulate.value[indexPath.row].value.TimeCategory?.color {
            cell.backgroundColor = UIColor(cgColor: viewModel.tasksToPopulate.value[indexPath.row].value.TimeCategory!.color!)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.viewModel.deleteAt(index: indexPath.row)
        }
        
        delete.backgroundColor = UIColor.red
        
        let move = UITableViewRowAction(style: .normal, title: "Re-add") { action, index in
            self.viewModel.deArchive(index: indexPath.row)
        }
        move.backgroundColor = UIColor.green
        return [move, delete]
    }
    
    // Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenTask = viewModel.tasksToPopulate.value[indexPath.row]
        if CollectionHelper.IsNilOrEmpty(_coll: chosenTask.value.unwrappedRepeatables) {
            pushTaskInfoView(_task: chosenTask.value)
            return
        }
        var childTasksToDisplay = [Task]()
        for _child in viewModel.childTasks! {
            if _child.parentID! == chosenTask.value.ID! {
                childTasksToDisplay.append(_child)
            }
        }
        if childTasksToDisplay.count > 0 {
            pushChildrenTableView(_tasks: childTasksToDisplay)
            return
        } else {
            pushTaskInfoView(_task: chosenTask.value)
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    // Present didselect view
    
    func pushChildrenTableView(_tasks : [Task]) {
        let childVC : ArchivedTasksChildTableViewController = Constants.main_storyboard.instantiateViewController(withIdentifier: "archivedTasksChildVC") as! ArchivedTasksChildTableViewController
        childVC.viewModel.setTasks(tasks: Dynamic.wrapArray(array: _tasks))
        self.navigationController?.pushViewController(childVC, animated: true)
    }
    
    func pushTaskInfoView(_task : Task) {
        let taskVC : DisplayArchivedTaskViewController = Constants.main_storyboard.instantiateViewController(withIdentifier: "displayArchiveVC") as! DisplayArchivedTaskViewController
        taskVC.viewModel.setTask(newTask: _task)
        self.navigationController?.pushViewController(taskVC, animated: true)
    }
    
    
    
    // IB Actions
    
    @IBAction func sort(_ sender: AnyObject) {
        viewModel.sortBy()
    }
    
}

enum TaskSortParameter {
    case Name
    case Date
}
