//
//  ArchivedTasksChildTableViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/19/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class ArchivedTasksChildTableViewController: TaskDisplayViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllTasks!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "archiveTasksChildTableViewCell", for: indexPath) as! ArchivedTasksChildTableViewCell
        cell.setTask(_task: AllTasks![indexPath.row])
        cell.name_lbl.text = AllTasks![indexPath.row].Name!
        cell.time_lbl.text = TimeConverter.dateToShortDateConverter(_time: AllTasks![indexPath.row].FinishTime!)
        return cell
    }
    
    // Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskVC : DisplayArchivedTaskViewController = Constants.main_storyboard.instantiateViewController(withIdentifier: "displayArchiveVC") as! DisplayArchivedTaskViewController
        taskVC.task = AllTasks![indexPath.row]
        self.navigationController?.pushViewController(taskVC, animated: true)
    }
}
