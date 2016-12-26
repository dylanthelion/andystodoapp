//
//  ArchivedTaskTableViewDataSource.swift
//  AndysToDo
//
//  Created by dillion on 12/17/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class ArchivedTaskTableViewDataSource : NSObject, UITableViewDataSource {
    
    var viewModel : ArchiveTaskViewModel?
    
    init(viewModel : ArchiveTaskViewModel) {
        self.viewModel = viewModel
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.tasksToPopulate.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.main_storyboard_archived_task_table_view_cell_id, for: indexPath) as! ArchivedTasksTableViewCells
        cell.name_lbl.text = viewModel?.tasksToPopulate.value[indexPath.row].value.name!
        cell.time_lbl.text = TimeConverter.dateToShortDateConverter((viewModel?.tasksToPopulate.value[indexPath.row].value.finishTime!)!)
        if let _ = viewModel?.tasksToPopulate.value[indexPath.row].value.timeCategory?.color {
            cell.backgroundColor = UIColor(cgColor: (viewModel?.tasksToPopulate.value[indexPath.row].value.timeCategory!.color!)!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}
