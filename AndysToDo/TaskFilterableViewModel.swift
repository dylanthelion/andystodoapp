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
        var tempTasks = _tasksToPopulate
        for _task in tempTasks!.value {
            if (_task.value.StartTime! as Date) > upperLimit! {
                let indexOf = _tasksToPopulate!.value.index(of: _task)
                _tasksToPopulate!.value.remove(at: indexOf!)
            }
        }
        sortDisplayedTasks()
    }
    
    func sortDisplayedTasks() {
        _tasksToPopulate!.value.sort(by: {
            return ($0.value.StartTime! as Date) < ($1.value.StartTime! as Date)
        })
    }
    
    // Task CRUDs
    
    func deleteAt(index : Int) {
        if let _ =  _tasksToPopulate!.value[index].value.parentID {
            _tasksToPopulate!.value.remove(at: index)
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
