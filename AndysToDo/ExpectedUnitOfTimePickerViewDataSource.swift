//
//  ExpectedUnitOfTimePickerViewDataSource.swift
//  AndysToDo
//
//  Created by dillion on 11/18/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class ExpectedUnitOfTimePickerDataSource : NSObject, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.totalExpectedUnitsOfTime
    }
}
