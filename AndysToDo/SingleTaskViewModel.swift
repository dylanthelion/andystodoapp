//
//  SingleTaskViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/11/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class SingleTaskViewModel {
    
    // Model
    
    var task : Dynamic<Task>?
    
    // Updates
    
    func updateTask() {
        for checkTask in TaskDTO.globalManager.AllTasks!.value {
            if task?.value == checkTask.value {
                task = checkTask
                break
            }
        }
    }
}
