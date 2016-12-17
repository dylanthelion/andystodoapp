//
//  ArchivedTaskChildTableViewDelegate.swift
//  AndysToDo
//
//  Created by dillion on 12/17/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class ArchivedTaskChildTableViewDelegate : NSObject, UITableViewDelegate {
    
    var viewModel : ArchivedTaskChildrenViewModel?
    weak var viewDelegate : ArchivedTasksChildTableViewController?
    
    init(viewModel : ArchivedTaskChildrenViewModel, delegate : ArchivedTasksChildTableViewController) {
        self.viewModel = viewModel
        self.viewDelegate = delegate
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewDelegate?.presentArchivedTask(at: indexPath.row)
    }
}
