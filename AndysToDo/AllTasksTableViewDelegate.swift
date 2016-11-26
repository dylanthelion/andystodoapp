//
//  AllTasksTableViewDelegate.swift
//  AndysToDo
//
//  Created by dillion on 12/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class AllTasksTableViewDelegate : NSObject, UITableViewDelegate {
    
    var viewModel : AllTasksViewModel?
    weak var viewDelegate : AllTasksViewController?
    
    init(viewModel : AllTasksViewModel, delegate : AllTasksViewController) {
        self.viewModel = viewModel
        self.viewDelegate = delegate
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.viewModel?.deleteAt(index: indexPath.row)
        }
        delete.backgroundColor = UIColor.red
        let move = UITableViewRowAction(style: .normal, title: "Re-add") { action, index in
            self.viewModel!.moveTaskToDayPlanner(index: indexPath.row)
            DispatchQueue.main.async {
                self.viewDelegate?.tabBarController?.selectedIndex = 0
            }
        }
        move.backgroundColor = UIColor.green
        return [move, delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewDelegate!.pushDisplayTask(at: indexPath.row)
    }
}
