//
//  ArchivedTasksTableViewCells.swift
//  AndysToDo
//
//  Created by dillion on 11/19/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class ArchivedTasksTableViewCells: UITableViewCell {
    
    var task : Task?
    
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var time_lbl: UILabel!
    
    func setTask(_task : Task) {
        if _task.isValid() {
            task = _task
        }
    }
}
