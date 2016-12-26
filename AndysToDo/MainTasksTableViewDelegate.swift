//
//  MainTasksTableViewDelegate.swift
//  AndysToDo
//
//  Created by dillion on 12/15/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class MainTasksTableViewDelegate : NSObject, UITableViewDelegate {
    
    var viewModel : PopulatedTasksViewModel?
    weak var viewDelegate : MainTasksViewController?
    
    init(viewModel : PopulatedTasksViewModel, delegate : MainTasksViewController) {
        self.viewModel = viewModel
        self.viewDelegate = delegate
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (viewModel?.tasksToPopulate.value[indexPath.row].value.inProgress)! {
            viewDelegate!.presentActiveTaskController((viewModel?.tasksToPopulate.value[indexPath.row].value)!)
        } else {
            viewDelegate!.presentInactiveTaskController((viewModel?.tasksToPopulate.value[indexPath.row].value)!)
        }
    }
}
