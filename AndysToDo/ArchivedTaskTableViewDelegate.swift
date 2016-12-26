//
//  ArchivedTaskTableViewDelegate.swift
//  AndysToDo
//
//  Created by dillion on 12/17/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class ArchivedTaskTableViewDelegate : NSObject, UITableViewDelegate {
    
    var viewModel : ArchiveTaskViewModel?
    weak var viewDelegate : ArchiveTaskTableViewController?
    
    init(viewModel : ArchiveTaskViewModel, delegate : ArchiveTaskTableViewController) {
        self.viewModel = viewModel
        self.viewDelegate = delegate
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenTask = viewModel?.tasksToPopulate.value[indexPath.row]
        if CollectionHelper.IsNilOrEmpty(chosenTask?.value.unwrappedRepeatables) {
            viewDelegate?.pushTaskInfoView((chosenTask?.value)!)
            return
        }
        var childTasksToDisplay = [Task]()
        for _child in viewModel!.childTasks! {
            if _child.parentID! == chosenTask?.value.ID! {
                childTasksToDisplay.append(_child)
            }
        }
        if childTasksToDisplay.count > 0 {
            viewDelegate?.pushChildrenTableView(childTasksToDisplay)
            return
        } else {
            viewDelegate?.pushTaskInfoView((chosenTask?.value)!)
            return
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: Constants.tableViewCell_delete_action_title) { action, index in
            self.viewModel!.deleteAt(indexPath.row)
        }
        
        delete.backgroundColor = UIColor.red
        
        let move = UITableViewRowAction(style: .normal, title: Constants.tableViewCell_readd_action_title) { action, index in
            self.viewModel!.deArchive(index: indexPath.row)
        }
        move.backgroundColor = UIColor.green
        return [move, delete]
    }
}
