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
        if(CollectionHelper.IsNilOrEmpty(categoryFilters) && CollectionHelper.IsNilOrEmpty(timeCategoryFilters)) {
            clearFilter()
            return
        }
        localFilteredTasks!.value.removeAll()
        filterActive = false
        for task in localTasks!.value {
            var addToFilter : Bool = false
            if task.value.categories != nil && !CollectionHelper.IsNilOrEmpty(categoryFilters) {
                for category in task.value.categories! {
                    for checkCategory in categoryFilters! {
                        if(category.name! == checkCategory.name!) {
                            addToFilter = true
                            break
                        }
                    }
                }
            }
            
            if task.value.timeCategory != nil && !CollectionHelper.IsNilOrEmpty(timeCategoryFilters) {
                for checkCategory in timeCategoryFilters! {
                    if(task.value.timeCategory!.name! == checkCategory.name!) {
                        addToFilter = true
                        break
                    }
                }
            }
            
            if(addToFilter) {
                localFilteredTasks!.value.append(task)
                addToFilter = false
            }
        }
        filteredTasks!.value = localFilteredTasks!.value
        filterActive = true
    }
    
    
    // Filter add/remove
    
    func removeCategoryFilter(_ category: Category) {
        let indexOf = self.categoryFilters?.index(of: category)
        self.categoryFilters?.remove(at: indexOf!)
        applyFilter()
    }
    
    func removeTimeCategoryFilter(_ category: TimeCategory) {
        let indexOf = self.timeCategoryFilters?.index(of: category)
        self.timeCategoryFilters?.remove(at: indexOf!)
        applyFilter()
    }
    
    func addCategoryFilter(_ category : Category) {
        if let _ = self.categoryFilters {
            self.categoryFilters?.append(category)
        } else {
            self.categoryFilters = [category]
        }
        applyFilter()
    }
    
    func addTimeCategoryFilter(_ category: TimeCategory) {
        if let _ = self.timeCategoryFilters {
            self.timeCategoryFilters?.append(category)
        } else {
            self.timeCategoryFilters = [category]
        }
        applyFilter()
    }
    
    func clearFilter() {
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
            if (_task.value.startTime! as Date) > upperLimit! {
                let indexOf = localTasks!.value.index(of: _task)
                localTasks!.value.remove(at: indexOf!)
            }
        }
        sortDisplayedTasks()
    }
    
    func sortDisplayedTasks() {
        localTasks!.value.sort(by: {
            return ($0.value.startTime! as Date) < ($1.value.startTime! as Date)
        })
        Constants.mainTaskQueue.async {
            self._tasksToPopulate!.value = self.localTasks!.value
        }
    }
    
    // Task CRUDs
    
    func deleteAt(_ index : Int) {
        if let _ =  localTasks!.value[index].value.parentID {
            localTasks!.value.remove(at: index)
            sortDisplayedTasks()
        } else {
            TaskDTO.globalManager.deleteTask(_tasksToPopulate!.value[index].value)
        }
    }
}
