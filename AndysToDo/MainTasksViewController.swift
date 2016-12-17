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

class MainTasksViewController : TaskFilterableViewController {
    
    // Table view
    
    var dataSource : MainTasksTableViewDataSource?
    var delegate : MainTasksTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupTableView()
        for _task in (viewModel?.tasksToPopulate.value)! {
            if _task.value.inProgress {
                self.presentActiveTaskController(_task: _task.value)
                break
            }
        }
    }
    
    // Binding
    
    var modelBond: Bond<[Dynamic<Task>]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as! Bond<[Dynamic<Task>]>
        } else {
            let b = Bond<[Dynamic<Task>]>() { [unowned self] v in
                
                //print("Update all in view")
                DispatchQueue.main.async {
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
                //print("Apply filter in view")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            objc_setAssociatedObject(self, &filteredHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // Setup
    
    func setupBinding() {
        viewModel = PopulatedTasksViewModel()
        self.modelBond.bind(dynamic: (viewModel?.tasksToPopulate)!)
        self.filterBond.bind(dynamic: (viewModel?.filteredTasks!)!)
    }
    
    func setupTableView() {
        dataSource = MainTasksTableViewDataSource(viewModel: viewModel! as! PopulatedTasksViewModel)
        delegate = MainTasksTableViewDelegate(viewModel: viewModel! as! PopulatedTasksViewModel, delegate : self)
        self.tableView.dataSource = dataSource
        self.tableView.delegate = delegate
    }
    
    // Present task
    
    func presentActiveTaskController(_task : Task) {
        let displayActiveTaskVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_activeTask_VC_id) as! DisplayActiveTaskViewController
        displayActiveTaskVC.viewModel.task = Dynamic(_task)
        self.navigationController?.pushViewController(displayActiveTaskVC, animated: true)
    }
    
    func presentInactiveTaskController(_task : Task) {
        let displayInactiveTaskVC = Constants.main_storyboard.instantiateViewController(withIdentifier: Constants.main_storyboard_inactiveTask_VC_id) as! DisplayInactiveTaskViewController
        displayInactiveTaskVC.viewModel!.setTask(newTask: _task)
        self.navigationController?.pushViewController(displayInactiveTaskVC, animated: true)
    }}
