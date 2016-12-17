//
//  LoadAllTasksViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/9/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class LoadAllTasksViewModel {
    
    // Not sure why, but unrelated viewmodels are loading before first view. Will subclass all viewmodels, and make sure tasks and categories load once, at least
    
    private let taskDTO = TaskDTO.globalManager
    
    init() {
        
    }
}
