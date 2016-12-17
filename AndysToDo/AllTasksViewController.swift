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

class AllTasksViewController : TaskFilterableViewController {
    
    // Table view
    
    var dataSource : AllTasksTableViewDataSource?
    var delegate : AllTasksTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AllTasksViewModel()
        modelBond.bind(dynamic: (viewModel?.tasksToPopulate)!)
        filterBond.bind(dynamic: (viewModel?.filteredTasks!)!)
        setupTableView()
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
    
    // Setup
    
    func setupTableView() {
        dataSource = AllTasksTableViewDataSource(viewModel: viewModel! as! AllTasksViewModel, delegate: self)
        delegate = AllTasksTableViewDelegate(viewModel: viewModel! as! AllTasksViewModel, delegate : self)
        self.tableView.dataSource = dataSource
        self.tableView.delegate = delegate
    }
    
    // View presentation
    
    func pushDisplayTask(at index : Int) {
        let displayTaskVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_all_tasks_individuAL_VC_ID) as! AllTasksIndividualTaskViewController
        displayTaskVC.viewModel!.setTask(newTask: (viewModel?.tasksToPopulate.value[index].value)!)
        self.navigationController?.pushViewController(displayTaskVC, animated: true)
    }
}
