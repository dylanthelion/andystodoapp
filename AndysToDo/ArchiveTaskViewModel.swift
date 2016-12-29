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
        self.tasksToPopulate = Dynamic(ArchivedTaskDTO.shared.allTasks!.value.map({ $0 }))
        filteredTasks = Dynamic([Dynamic<Task>]())
        localTasks = Dynamic(ArchivedTaskDTO.shared.allTasks!.value.map({ $0 }))
        localFilteredTasks = Dynamic([Dynamic<Task>]())
        self.taskDTOBond.bind(dynamic: ArchivedTaskDTO.shared.allTasks!)
        removeChildren()
        sortDisplayedTasks()
    }
    
    // Binding
    
    var taskDTOBond: Bond<[Dynamic<Task>]> {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as! Bond<[Dynamic<Task>]>
        } else {
            let b = Bond<[Dynamic<Task>]>() { [unowned self] v in
                //print("Update in view model")
                self.setup()
            }
            objc_setAssociatedObject(self, &handle, b, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return b
        }
    }
    
    // Model setup
    
    func setup() {
        localTasks!.value.removeAll()
        localTasks!.value.append(contentsOf: ArchivedTaskDTO.shared.allTasks!.value)
        removeChildren()
        sortDisplayedTasks()
    }
    
    // Filter children from model
    
    func removeChildren() {
        let unwrappedTasks = RepeatableUnwrapper.removeChildren(localTasks!.value.map({ $0.value }))
        localTasks!.value = unwrappedTasks.0.map({ Dynamic($0) })
        childTasks = unwrappedTasks.1
    }
    
    // Table view actions
    
    func deArchive(index : Int) {
        let task = localTasks!.value[index].value
        let _ = ArchivedTaskDTO.shared.deArchive(task)
    }
    
    // CRUD
    
    override func deleteAt(_ index: Int) {
        if let _ =  localTasks!.value[index].value.parentID {
            localTasks!.value.remove(at: index)
            sortDisplayedTasks()
        } else {
            ArchivedTaskDTO.shared.deleteTask(_tasksToPopulate!.value[index].value)
        }
    }
    
    // Sort tasks
    
    func sortBy() {
        switch sortParam {
        case .Date:
            sortParam = .Name
            if filterActive {
                localFilteredTasks!.value.sort(by: {
                    return $0.value.name! < $1.value.name!
                })
            } else {
                localTasks!.value.sort(by: {
                    return $0.value.name! < $1.value.name!
                })
            }
            
        case .Name:
            sortParam = .Date
            if filterActive {
                localFilteredTasks!.value.sort(by: {
                    return ($0.value.finishTime! as Date) < ($1.value.finishTime! as Date)
                })
            } else {
                localTasks!.value.sort(by: {
                    return ($0.value.finishTime! as Date) < ($1.value.finishTime! as Date)
                })
            }
        }
        tasksToPopulate.value = localTasks!.value
    }
}
