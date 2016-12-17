//
//  AlertHelper.swift
//  AndysToDo
//
//  Created by dillion on 12/4/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class AlertHelper {
    
    class func PresentAlertController(sender : UIViewController, title: String, message: String, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        sender.present(alertController, animated: true, completion: nil)
    }
}
