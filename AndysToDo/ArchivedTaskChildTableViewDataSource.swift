//
//  ArchivedTaskChildTableViewDataSource.swift
//  AndysToDo
//
//  Created by dillion on 12/17/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class ArchivedTaskChildTableViewDataSource : NSObject, UITableViewDataSource {
    
    var viewModel : ArchivedTaskChildrenViewModel?
    
    init(viewModel : ArchivedTaskChildrenViewModel) {
        self.viewModel = viewModel
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.tasksToPopulate!.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "archiveTasksChildTableViewCell", for: indexPath) as! ArchivedTasksChildTableViewCell
        cell.name_lbl.text = viewModel!.tasksToPopulate!.value[indexPath.row].value.Name!
        cell.time_lbl.text = TimeConverter.dateToShortDateConverter(_time: viewModel!.tasksToPopulate!.value[indexPath.row].value.FinishTime!)
        return cell
    }
}
