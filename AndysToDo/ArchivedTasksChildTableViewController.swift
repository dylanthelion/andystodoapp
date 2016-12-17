//
//  ArchivedTasksChildTableViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/19/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private var taskHandle : UInt8 = 0

class ArchivedTasksChildTableViewController : UITableViewController {
    
    // View Model
    
    let viewModel = ArchivedTaskChildrenViewModel()
    
    // Table view
    
    var dataSource : ArchivedTaskChildTableViewDataSource?
    var delegate : ArchivedTaskChildTableViewDelegate?
    
    override func viewDidLoad() {
        modelBond.bind(dynamic: viewModel.tasksToPopulate!)
        setupTableView()
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
    
    // Setup
    
    func setupTableView() {
        dataSource = ArchivedTaskChildTableViewDataSource(viewModel: viewModel)
        delegate = ArchivedTaskChildTableViewDelegate(viewModel: viewModel, delegate : self)
        self.tableView.dataSource = dataSource
        self.tableView.delegate = delegate
    }
    
    // View presentation
    
    func presentArchivedTask(at index : Int) {
        let taskVC : DisplayArchivedTaskViewController = Constants.main_storyboard.instantiateViewController(withIdentifier: "displayArchiveVC") as! DisplayArchivedTaskViewController
        taskVC.viewModel.setTask(newTask: viewModel.tasksToPopulate!.value[index].value)
        self.navigationController?.pushViewController(taskVC, animated: true)
    }
}
