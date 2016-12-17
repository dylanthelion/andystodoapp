//
//  ArchiveTaskViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/8/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

private var handle: UInt8 = 0

class ArchiveTaskViewModel : TaskFilterableViewModel {
    
    var sortParam : TaskSortParameter = .Date
    var childTasks : [Task]?
    
    override init() {
        super.init()
        self.tasksToPopulate = Dynamic(ArchivedTaskDTO.shared.archivedTasks!.value.map({ $0 }))
        filteredTasks = Dynamic([Dynamic<Task>]())
        self.taskDTOBond.bind(dynamic: ArchivedTaskDTO.shared.archivedTasks!)
        removeChildren()
        sortDisplayedTasks()
    }
    
    // Binding
    
    var taskDTOBond: Bond<[Dynamic<Task>]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as! Bond<[Dynamic<Task>]>
        } else {
            let b = Bond<[Dynamic<Task>]>() { [unowned self] v in
                print("Update in view model")
                self.setup()
            }
            objc_setAssociatedObject(self, &handle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // Model setup
    
    func setup() {
        tasksToPopulate.value.removeAll()
        tasksToPopulate.value.append(contentsOf: ArchivedTaskDTO.shared.archivedTasks!.value)
        removeChildren()
        sortDisplayedTasks()
    }
    
    // Filter children from model
    
    func removeChildren() {
        let unwrappedTasks = RepeatableUnwrapper.removeChildren(allTasks: tasksToPopulate.value.map({ $0.value }))
        tasksToPopulate.value = unwrappedTasks.0.map({ Dynamic($0) })
        childTasks = unwrappedTasks.1
    }
    
    // Table view actions
    
    func deArchive(index : Int) {
        let _task = tasksToPopulate.value[index].value
        if ArchivedTaskDTO.shared.deArchive(_task: _task) {
            // handle success
        }
        // handle failure
    }
    
    // on update
    
    override func removeDeletedTasks() {
        let tempTasks = tasksToPopulate
        for _task in tempTasks.value {
            if _task.value.parentID == nil && ArchivedTaskDTO.shared.archivedTasks!.value.index(of: _task) == nil {
                _tasksToPopulate!.value.remove(at: _tasksToPopulate!.value.index(of: _task)!)
            }
        }
    }
    
    override func addNewTasks() {
        for _task in ArchivedTaskDTO.shared.archivedTasks!.value {
            if tasksToPopulate.value.index(of: _task) == nil {
                tasksToPopulate.value.append(_task)
            }
        }
    }
    
    // Sort tasks
    
    func sortBy() {
        switch sortParam {
        case .Date:
            sortParam = .Name
            tasksToPopulate.value.sort(by: {
                return $0.value.Name! < $1.value.Name!
            })
        case .Name:
            sortParam = .Date
            tasksToPopulate.value.sort(by: {
                return ($0.value.FinishTime! as Date) < ($1.value.FinishTime! as Date)
            })
        }
    }
}
