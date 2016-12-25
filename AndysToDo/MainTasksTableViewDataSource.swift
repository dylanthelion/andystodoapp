//
//  MainTasksTableViewDataSource.swift
//  AndysToDo
//
//  Created by dillion on 12/15/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class MainTasksTableViewDataSource : NSObject, UITableViewDataSource {
    
    var viewModel : PopulatedTasksViewModel?
    
    init(viewModel : PopulatedTasksViewModel) {
        self.viewModel = viewModel
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.tasksToPopulate.value.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*if indexPath.row == viewModel!.tasksToPopulate.value.count {
            // Until I find a good GCD solution to KVO-cuased race conditions, return an empty cell as a safe out
            return UITableViewCell()
        }*/
        let cell : TaskTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.task_table_view_cell_id) as! TaskTableViewCell
        let cellTask : Task = viewModel!.tasksToPopulate.value[indexPath.row].value
        cell.setTask(_task: cellTask)
        switch cellTask.inProgress {
        case true :
            cell.onItButton.alpha = Constants.alpha_solid
        case false :
            cell.onItButton.alpha = Constants.alpha_faded
        }
        cell.taskTitleLabel.text = cellTask.Name!
        if let _ = cellTask.StartTime {
            cell.timeLabel.text = TimeConverter.dateToTimeWithMeridianConverter(_time: cellTask.StartTime!)
        }
        if let _ = cellTask.FinishTime {
            cell.onItButton.setTitle(Constants.taskTableViewCell_done, for: .normal)
        } else {
            cell.onItButton.setTitle(Constants.taskTableViewCell_onIt, for: .normal)
        }
        if let _ = cellTask.TimeCategory?.color {
            cell.backgroundColor = UIColor(cgColor: cellTask.TimeCategory!.color!)
        } else {
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.deleteAt(index: indexPath.row)
        }
    }
}
