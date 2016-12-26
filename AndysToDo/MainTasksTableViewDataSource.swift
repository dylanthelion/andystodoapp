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
        let cell : TaskTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.task_table_view_cell_id) as! TaskTableViewCell
        let cellTask : Task = viewModel!.tasksToPopulate.value[indexPath.row].value
        cell.setTask(cellTask)
        switch cellTask.inProgress {
        case true :
            cell.onItButton.alpha = Constants.alpha_solid
        case false :
            cell.onItButton.alpha = Constants.alpha_faded
        }
        cell.taskTitleLabel.text = cellTask.name!
        if let _ = cellTask.startTime {
            cell.timeLabel.text = TimeConverter.dateToTimeWithMeridianConverter(cellTask.startTime!)
        }
        if let _ = cellTask.finishTime {
            cell.onItButton.setTitle(Constants.taskTableViewCell_done, for: .normal)
        } else {
            cell.onItButton.setTitle(Constants.taskTableViewCell_onIt, for: .normal)
        }
        if let _ = cellTask.timeCategory?.color {
            cell.backgroundColor = UIColor(cgColor: cellTask.timeCategory!.color!)
        } else {
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.deleteAt(indexPath.row)
        }
    }
}
