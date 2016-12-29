//
//  AlertHelper.swift
//  AndysToDo
//
//  Created by dillion on 12/4/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class AlertHelper {
    
    class func presentAlertController(_ sender : AlertPresenter, title: String, message: String, actions: [UIAlertAction]) -> UIAlertController {
        var senderVC = sender
        let alertController = NotifyingAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.delegate = sender
            senderVC.alertIsVisible = true
        for action in actions {
            alertController.addAction(action)
        }
        return alertController
    }
}
