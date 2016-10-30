//
//  CheckboxButton.swift
//  AndysToDo
//
//  Created by dillion on 10/21/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CheckboxButton : UIButton {
    
    var checked = false
    
    func toggleChecked() {
        switch checked {
        case false :
            checked = true
            DispatchQueue.main.async {
                self.setImage(UIImage(named: Constants.img_checkbox_checked), for: .normal)
            }
        case true :
            checked = false
            DispatchQueue.main.async {
                self.setImage(UIImage(named: Constants.img_checkbox_unchecked), for: .normal)
            }
        }
    }
}
