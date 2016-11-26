//
//  TimecatTableViewCell.swift
//  AndysToDo
//
//  Created by dillion on 11/6/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private var handle: UInt8 = 0

class TimecatTableViewCell : UITableViewCell {
    
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var time_lbl: UILabel!
    
    override func awakeFromNib() {
        
    }
    
    var timecatBond: Bond<TimeCategory> {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as! Bond<TimeCategory>
        } else {
            let b = Bond<TimeCategory>() { [unowned self] v in
                DispatchQueue.main.async {
                    self.name_lbl.text = v.Name!
                    self.time_lbl.text = "\(TimeConverter.convertFloatToTimeString(_time: v.StartOfTimeWindow!))-\(TimeConverter.convertFloatToTimeStringWithMeridian(_time: v.EndOfTimeWindow!))"
                }
            }
            objc_setAssociatedObject(self, &handle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
}
