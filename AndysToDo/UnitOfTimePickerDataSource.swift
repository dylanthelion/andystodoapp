//
//  UnitOfTimePickerDataSource.swift
//  AndysToDo
//
//  Created by dillion on 10/28/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class UnitOfTimePickerDataSource : NSObject, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.total_unitsOfTime
    }
}
