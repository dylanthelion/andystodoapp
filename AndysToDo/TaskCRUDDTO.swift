//
//  TaskCRUDDTO.swift
//  AndysToDo
//
//  Created by dillion on 12/29/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

protocol TaskCRUDDTO {
    
    var allTasks : Dynamic<[Dynamic<Task>]>? { get set }
    
    func archiveTask(_ task: Task) -> Bool
    func editTask(_ task : Task)
    func deleteTask(_ task : Task)
}
