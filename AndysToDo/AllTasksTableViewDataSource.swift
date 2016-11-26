//
//  AllTasksTableViewDataSource.swift
//  AndysToDo
//
//  Created by dillion on 12/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class AllTasksTableViewDataSource : NSObject, UITableViewDataSource {
    
    // View Model
    
    var viewModel : AllTasksViewModel?
    
    // View Delegate
    
    weak var viewDelegate : AllTasksViewController?
    
    init(viewModel : AllTasksViewModel, delegate : AllTasksViewController) {
        self.viewModel = viewModel
        viewDelegate = delegate
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.tasksToPopulate.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : AllTasksTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.main_storyboard_display_task_table_view_cell_id) as! AllTasksTableViewCell
        let cellTask : Task = viewModel!.tasksToPopulate.value[indexPath.row].value
        cell.setTask(_task: cellTask)
        cell.name_lbl.text = cellTask.Name!
        if cellTask.isRepeatable() {
            cell.time_lbl.text = Constants.displayAllTasksVC_string_repeatable
        } else if let _ = cellTask.StartTime {
            cell.time_lbl.text = TimeConverter.dateToShortDateConverter(_time: cellTask.StartTime!)
        } else {
            cell.time_lbl.text = Constants.displayAllTasksVC_string_no_time
        }
        if let _ = cellTask.TimeCategory?.color {
            cell.backgroundColor = UIColor.init(cgColor: (cellTask.TimeCategory?.color!)!)
        } else {
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
}
