//
//  TimecatPickerDataSource.swift
//  AndysToDo
//
//  Created by dillion on 10/28/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class TimecatPickerDataSource : NSObject, UIPickerViewDataSource {
    
    var allTimeCategories : [TimeCategory]?
    
    convenience init(_categories : [TimeCategory]?) {
        self.init()
        allTimeCategories = _categories
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.allTimeCategories!.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
