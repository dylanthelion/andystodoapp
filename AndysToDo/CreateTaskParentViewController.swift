//
//  CreateTaskParentViewController.swift
//  AndysToDo
//
//  Created by dillion on 11/4/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CreateTaskParentViewController : UIViewController {
    
    var repeatableDetails : RepeatableTaskOccurrence?
    var startTime : NSDate?
    var allCategories : [Category]?
    
    override func viewDidLoad() {
        
    }
    
    // Categories
    
    func addCategory(_category : Category) {
        if let _ = self.allCategories {
            self.allCategories!.append(_category)
        } else {
            self.allCategories = [_category]
        }
    }
    
    func removeCategory(_category : Category) {
        let indexOf = self.allCategories?.index(of: _category)
        self.allCategories?.remove(at: indexOf!)
    }
}
