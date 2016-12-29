//
//  NotifyingAlertController.swift
//  AndysToDo
//
//  Created by dillion on 12/19/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class NotifyingAlertController : UIAlertController {
    
    var delegate : AlertPresenter?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.handleWillDisappear()
        delegate?.alertIsVisible = false
    }
}
