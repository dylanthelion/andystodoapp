//
//  TaskFilterableViewModel.swift
//  AndysToDo
//
//  Created by dillion on 12/9/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class TaskFilterableViewModel : TaskCRUDTableViewModel {
    
    // Model
    
    var filteredTasks : Dynamic<[Dynamic<Task>]>?
    var _tasksToPopulate : Dynamic<[Dynamic<Task>]>? = nil
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
    
    // Local model. These classes are used to prevent excessive view updates, caused by frequent model changes
    
    var localTasks : Dynamic<[Dynamic<Task>]>?
    var localFilteredTasks : Dynamic<[Dynamic<Task>]>?
    
    // Filters
    
    var categoryFilters : [Category]?
    var timeCategoryFilters : [TimeCategory]?
    
    // State
    
    var filterActive = false
    
   init() {
        CategoryDTO.shared.loadCategories()
        TimeCategoryDTO.shared.loadTimeCategories()
        TaskDTO.globalManager.loadTasks()
    }
    
    // Filter
    
    func applyFilter() {
        //print("Apply filter")
        if(CollectionHelper.IsNilOrEmpty(_coll: categoryFilters) && CollectionHelper.IsNilOrEmpty(_coll: timeCategoryFilters)) {
            clearFilter()
            return
        }
        localFilteredTasks!.value.removeAll()
        filterActive = false
        for _task in localTasks!.value {
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
                localFilteredTasks!.value.append(_task)
                addToFilter = false
            }
        }
        filteredTasks!.value = localFilteredTasks!.value
        filterActive = true
    }
    
    
    // Filter add/remove
    
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
    
    func clearFilter() {
        //print("Clear filter")
        filterActive = false
        localFilteredTasks!.value.removeAll()
        filteredTasks!.value.removeAll()
    }
    
    // Sort tasks
    
    func sortDisplayedTasks(forWindow : Calendar.Component, units: Int) {
        var timeInterval : TimeInterval? = TimeInterval(0)
        if forWindow == .day {
            timeInterval = TimeInterval (Constants.seconds_per_day)
        } else if forWindow == .hour {
            timeInterval = TimeInterval(Constants.seconds_per_hour)
        }
        timeInterval! *= Double(units)
        let df = StandardDateFormatter()
        let upperLimit = df.date(from: df.string(from: Date().addingTimeInterval(timeInterval!)))
        let tempTasks = localTasks
        for _task in tempTasks!.value {
            if (_task.value.StartTime! as Date) > upperLimit! {
                let indexOf = localTasks!.value.index(of: _task)
                localTasks!.value.remove(at: indexOf!)
            }
        }
        sortDisplayedTasks()
    }
    
    func sortDisplayedTasks() {
        localTasks!.value.sort(by: {
            return ($0.value.StartTime! as Date) < ($1.value.StartTime! as Date)
        })
        Constants.mainTaskQueue.async {
            self._tasksToPopulate!.value = self.localTasks!.value
        }
    }
    
    // Task CRUDs
    
    func deleteAt(index : Int) {
        if let _ =  localTasks!.value[index].value.parentID {
            localTasks!.value.remove(at: index)
            sortDisplayedTasks()
        } else {
            TaskDTO.globalManager.deleteTask(_task: _tasksToPopulate!.value[index].value)
        }
    }
    
    func addNewTasks() {
        // Currently no shared or default behavior
    }
    
    func removeDeletedTasks() {
        // Currently no shared or default behavior
    }
}
