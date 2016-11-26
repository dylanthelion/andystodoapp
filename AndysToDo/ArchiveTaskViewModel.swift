//
//  ArchiveTaskViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/8/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

private var handle: UInt8 = 0

class ArchiveTaskViewModel {
    
    // Properties
    
    var filterActive = false
    private var _tasksToPopulate : Dynamic<[Dynamic<Task>]>? = nil
    var sortParam : TaskSortParameter = .Date
    var tasksToPopulate : Dynamic<[Dynamic<Task>]> {
        set {
            self._tasksToPopulate = newValue
        }
        get {
            if !filterActive {
                return self._tasksToPopulate!
            } else {
                return self.filteredTasks!
            }
        }
    }
    
    var filteredTasks : Dynamic<[Dynamic<Task>]>?
    var childTasks : [Task]?
    
    // Filters
    
    var categoryFilters : [Category]?
    var timeCategoryFilters : [TimeCategory]?
    
    init() {
        self.tasksToPopulate = Dynamic(TaskDTO.globalManager.archivedTasks!.value.map({ $0 }))
        filteredTasks = Dynamic([Dynamic<Task>]())
        self.taskDTOBond.bind(dynamic: TaskDTO.globalManager.archivedTasks!)
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
        tasksToPopulate.value.append(contentsOf: TaskDTO.globalManager.archivedTasks!.value)
        removeChildren()
        sortDisplayedTasks()
    }
    
    // Filter
    
    func applyFilter() {
        //print("Apply filter")
        if(CollectionHelper.IsNilOrEmpty(_coll: categoryFilters) && CollectionHelper.IsNilOrEmpty(_coll: timeCategoryFilters)) {
            clearFilter()
            return
        }
        filteredTasks!.value.removeAll()
        filterActive = false
        for _task in tasksToPopulate.value {
            var addToFilter : Bool = false
            if _task.value.Categories != nil && !CollectionHelper.IsNilOrEmpty(_coll: categoryFilters) {
                for _category in _task.value.Categories! {
                    for _checkCategory in categoryFilters! {
                        if(_category.Name! == _checkCategory.Name!) {
                            addToFilter = true
                            break
                        }
                    }
                }
            }
            
            if _task.value.TimeCategory != nil && !CollectionHelper.IsNilOrEmpty(_coll: timeCategoryFilters) {
                for _checkCategory in timeCategoryFilters! {
                    if(_task.value.TimeCategory!.Name! == _checkCategory.Name!) {
                        addToFilter = true
                        break
                    }
                }
            }
            if(addToFilter) {
                filteredTasks!.value.append(_task)
                addToFilter = false
            }
        }
        filterActive = true
    }
    
    func clearFilter() {
        //print("Clear filter")
        filterActive = false
        filteredTasks!.value.removeAll()
    }
    
    // Filter children from model
    
    func removeChildren() {
        childTasks = [Task]()
        for _parent in tasksToPopulate.value {
            for _child in tasksToPopulate.value {
                if _child.value.parentID == nil {
                    continue
                }
                if _parent.value.ID! == _child.value.parentID! && childTasks!.index(of: _child.value) == nil {
                    childTasks!.append(_child.value)
                }
            }
        }
        for _task in childTasks! {
            tasksToPopulate.value.remove(at: tasksToPopulate.value.index(of: Dynamic(_task))!)
        }
    }
    
    // Filter handling
    
    func removeCategoryFilter(_category: Category) {
        let indexOf = self.categoryFilters?.index(of: _category)
        self.categoryFilters?.remove(at: indexOf!)
        applyFilter()
    }
    
    func removeTimeCategoryFilter(_category: TimeCategory) {
        let indexOf = self.timeCategoryFilters?.index(of: _category)
        self.timeCategoryFilters?.remove(at: indexOf!)
        applyFilter()
    }
    
    func addCategoryFilter(_category : Category) {
        if let _ = self.categoryFilters {
            self.categoryFilters?.append(_category)
        } else {
            self.categoryFilters = [_category]
        }
        applyFilter()
    }
    
    func addTimeCategoryFilter(_category: TimeCategory) {
        if let _ = self.timeCategoryFilters {
            self.timeCategoryFilters?.append(_category)
        } else {
            self.timeCategoryFilters = [_category]
        }
        applyFilter()
    }
    
    // Table view actions
    
    func deleteAt(index : Int) {
        if let _ =  _tasksToPopulate!.value[index].value.parentID {
            _tasksToPopulate!.value.remove(at: index)
        } else {
            TaskDTO.globalManager.deleteTask(_task: _tasksToPopulate!.value[index].value)
        }
    }
    
    func deArchive(index : Int) {
        print("De-archive")
        let _task = tasksToPopulate.value[index].value
        if TaskDTO.globalManager.deArchive(_task: _task) {
            // handle success
        }
        // handle failure
    }
    
    // on update
    
    func removeDeletedTasks() {
        let tempTasks = tasksToPopulate
        for _task in tempTasks.value {
            if _task.value.parentID == nil && TaskDTO.globalManager.archivedTasks!.value.index(of: _task) == nil {
                _tasksToPopulate!.value.remove(at: _tasksToPopulate!.value.index(of: _task)!)
            }
        }
    }
    
    func addNewTasks() {
        for _task in TaskDTO.globalManager.archivedTasks!.value {
            if tasksToPopulate.value.index(of: _task) == nil {
                tasksToPopulate.value.append(_task)
            }
        }
    }
    
    // Sort tasks
    
    func sortDisplayedTasks() {
        _tasksToPopulate!.value.sort(by: {
            return ($0.value.StartTime! as Date) < ($1.value.StartTime! as Date)
        })
    }
    
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
