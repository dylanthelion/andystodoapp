//
//  ArchivedTasksChildtableViewCell.swift
//  AndysToDo
//
//  Created by dillion on 11/19/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private var handle: UInt8 = 0

class ArchivedTasksChildTableViewCell: UITableViewCell {
    
    var task : Task?
    
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var time_lbl: UILabel!
    
    override func awakeFromNib() {
        
    }
    
    func setTask(_task : Task) {
        if _task.isValid() {
            task = _task
        }
    }
    
    var taskBond: Bond<Task> {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as! Bond<Task>
        } else {
            let b = Bond<Task>() { [unowned self] v in
                DispatchQueue.main.async {
                    self.name_lbl.text = v.Name!
                    self.time_lbl.text = TimeConverter.dateToTimeWithMeridianConverter(_time: v.StartTime!)
                }
            }
            objc_setAssociatedObject(self, &handle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
}
