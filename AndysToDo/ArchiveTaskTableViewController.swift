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

class ArchiveTaskTableViewController : UITableViewController, TaskFilterableViewController {
    
    // View Model
    
    var viewModel : TaskFilterableViewModel?
    
    // Table view
    
    var dataSource : ArchivedTaskTableViewDataSource?
    var delegate : ArchivedTaskTableViewDelegate?
    
    // Outlets
    
    @IBOutlet weak var sort_btn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ArchiveTaskViewModel()
        modelBond.bind(dynamic: (viewModel?.tasksToPopulate)!)
        filterBond.bind(dynamic: (viewModel?.filteredTasks!)!)
        sort_btn.title = Constants.archivedTaskVC_sort_by_date_title
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
                    let archiveVM = self.viewModel! as! ArchiveTaskViewModel
                    switch archiveVM.sortParam {
                    case .Date :
                        self.sort_btn.title = Constants.archivedTaskVC_sort_by_date_title
                    case .Name:
                        self.sort_btn.title = Constants.archivedTaskVC_sort_by_name_title
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
                    let archiveVM = self.viewModel! as! ArchiveTaskViewModel
                    switch archiveVM.sortParam {
                        case .Date :
                            self.sort_btn.title = Constants.archivedTaskVC_sort_by_date_title
                        case .Name:
                            self.sort_btn.title = Constants.archivedTaskVC_sort_by_name_title
                    }
                    self.tableView.reloadData()
                }
            }
            objc_setAssociatedObject(self, &filteredHandle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // Setup
    
    func setupTableView() {
        dataSource = ArchivedTaskTableViewDataSource(viewModel: viewModel! as! ArchiveTaskViewModel)
        delegate = ArchivedTaskTableViewDelegate(viewModel: viewModel! as! ArchiveTaskViewModel, delegate : self)
        self.tableView.dataSource = dataSource
        self.tableView.delegate = delegate
    }
    
    // IB Actions
    
    @IBAction func sort(_ sender: AnyObject) {
        let archiveVM = self.viewModel! as! ArchiveTaskViewModel
        archiveVM.sortBy()
    }
    
    // Present didselect view
    
    func pushChildrenTableView(_ tasks : [Task]) {
        let childVC : ArchivedTasksChildTableViewController = Constants.archives_storyboard.instantiateViewController(withIdentifier: "archivedTasksChildVC") as! ArchivedTasksChildTableViewController
        childVC.viewModel.setTasks(Dynamic.wrapArray(array: tasks))
        self.navigationController?.pushViewController(childVC, animated: true)
    }
    
    func pushTaskInfoView(_ task : Task) {
        let taskVC : DisplayArchivedTaskViewController = Constants.archives_storyboard.instantiateViewController(withIdentifier: "displayArchiveVC") as! DisplayArchivedTaskViewController
        taskVC.viewModel.setTask(task)
        self.navigationController?.pushViewController(taskVC, animated: true)
    }
}
