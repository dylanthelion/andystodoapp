//
//  PopulatedTasksVM.swift
//  AndysToDo
//
//  Created by dillion on 11/26/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

// View Model for Main Tasks VC

private var handle: UInt8 = 0
private let populated = PopulatedTasksVM()


class PopulatedTasksVM {
    
    // Properties
    
    var filterActive = false
    private var _tasksToPopulate : Dynamic<[Dynamic<Task>]>? = nil
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
    
    // Filters
    
    var categoryFilters : [Category]?
    var timeCategoryFilters : [TimeCategory]?
    
    init() {
        CategoryDTO.shared.loadCategories()
        TimeCategoryDTO.shared.loadTimeCategories()
        TaskDTO.globalManager.loadTasks()
        self.tasksToPopulate = Dynamic(TaskDTO.globalManager.AllTasks!.value.map({ $0 }))
        filteredTasks = Dynamic([Dynamic<Task>]())
        populateNonRepeatables()
        populateRepeatables()
        self.taskDTOBond.bind(dynamic: TaskDTO.globalManager.AllTasks!)
        sortDisplayedTasks(forWindow: Constants.mainTaskVC_upper_limit_calendar_unit, units: Constants.mainTaskVC_upper_limit_number_of_units)
    }
    
    class var shared : PopulatedTasksVM {
        return populated
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
        tasksToPopulate.value.removeAll()
        tasksToPopulate.value.append(contentsOf: TaskDTO.globalManager.AllTasks!.value)
        populateNonRepeatables()
        populateRepeatables()
        sortDisplayedTasks(forWindow: Constants.mainTaskVC_upper_limit_calendar_unit, units: Constants.mainTaskVC_upper_limit_number_of_units)
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
    
    // Populate tasks
    
    func populateNonRepeatables() {
        if tasksToPopulate == nil {
            tasksToPopulate = Dynamic([Dynamic<Task>]())
        }
        for _task in TaskDTO.globalManager.AllTasks!.value {
            if !_task.value.isRepeatable() && _tasksToPopulate!.value.index(of: _task) == nil {
                _tasksToPopulate!.value.append(_task)
            }
        }
    }
    
    func populateRepeatables() {
        let tempTasks = _tasksToPopulate
        for _task in tempTasks!.value {
            if _task.value.isRepeatable() {
                _tasksToPopulate!.value.append(contentsOf: unwrapRepeatables(_task: _task.value, toUnwrap: 3))
                _tasksToPopulate!.value.remove(at: _tasksToPopulate!.value.index(of: _task)!)
            }
        }
        sortDisplayedTasks(forWindow: Constants.mainTaskVC_upper_limit_calendar_unit, units: Constants.mainTaskVC_upper_limit_number_of_units)
    }
    
    // Table view delete
    
    func deleteAt(index : Int) {
        if let _ =  _tasksToPopulate!.value[index].value.parentID {
            _tasksToPopulate!.value.remove(at: index)
        } else {
            TaskDTO.globalManager.deleteTask(_task: _tasksToPopulate!.value[index].value)
        }
    }
    
    // on update
    
    func removeDeletedTasks() {
        let tempTasks = tasksToPopulate
        for _task in tempTasks.value {
            if _task.value.parentID == nil && TaskDTO.globalManager.AllTasks!.value.index(of: _task) == nil {
                _tasksToPopulate!.value.remove(at: _tasksToPopulate!.value.index(of: _task)!)
            }
        }
    }
    
    func addNewTasks() {
        for _task in TaskDTO.globalManager.AllTasks!.value {
            if !_task.value.isRepeatable() && _tasksToPopulate!.value.index(of: _task) == nil && _task.value.StartTime!.timeIntervalSince(Date()) <= Constants.mainTaskVC_upper_limit_time_interval && _task.value.FinishTime == nil {
                _tasksToPopulate!.value.append(_task)
            } else if _task.value.isRepeatable() && CollectionHelper.containsNoChildren(children: _tasksToPopulate!.value, ofParents: [_task]) && _task.value.FinishTime == nil  {
                if _task.value.RepeatableTask!.FirstOccurrence!.timeIntervalSince(Date()) <= Constants.mainTaskVC_upper_limit_time_interval {
                    _tasksToPopulate!.value.append(contentsOf: unwrapRepeatables(_task: _task.value, toUnwrap: 3))
                }
            }
        }
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
        var tempTasks = tasksToPopulate
        for _task in tempTasks.value {
            if (_task.value.StartTime! as Date) > upperLimit! {
                let indexOf = _tasksToPopulate!.value.index(of: _task)
                _tasksToPopulate!.value.remove(at: indexOf!)
            }
        }
        tempTasks = tasksToPopulate
        _tasksToPopulate!.value.sort(by: {
            return ($0.value.StartTime! as Date) < ($1.value.StartTime! as Date)
        })
    }
    
    // Unwrap tasks
    
    func unwrapRepeatables(_task : Task, toUnwrap : Int) -> [Dynamic<Task>] {
        if CollectionHelper.IsNilOrEmpty(_coll: _task.unwrappedRepeatables) {
            _task.unwrappedRepeatables = [Task]()
        }
        var startDate : NSDate? = nil
        var toReturn = [Dynamic<Task>]()
        for i in 0..<toUnwrap {
            let units = i
            let component : TimeInterval
            
            if _task.RepeatableTask!.UnitOfTime! == .Daily {
                component = TimeInterval(Constants.seconds_per_day)
            } else if _task.RepeatableTask!.UnitOfTime! == .Hourly {
                component = TimeInterval(Constants.seconds_per_hour)
            } else {
                component = TimeInterval(Constants.seconds_per_day * 7)
            }
            
            if startDate == nil {
                if !CollectionHelper.IsNilOrEmpty(_coll: _task.unwrappedRepeatables) {
                    startDate = _task.unwrappedRepeatables!.last!.StartTime!.addingTimeInterval(TimeInterval(units))
                } else {
                    startDate = (_task.RepeatableTask?.FirstOccurrence!)!
                }
                let now = Date()
                while startDate!.compare(now) == .orderedAscending {
                    startDate = startDate?.addingTimeInterval(component)
                }
            }
            let taskToAdd = Task(_name: "\(_task.Name!)\(i)", _description: _task.Description!, _start: startDate!.addingTimeInterval(component * TimeInterval(units)), _finish: nil, _category: _task.Categories, _timeCategory: _task.TimeCategory, _repeatable: nil)
            taskToAdd.parentID = _task.ID!
            taskToAdd.ID = Int(NSDate().timeIntervalSince1970) + Int(taskToAdd.StartTime!.timeIntervalSince1970)
            toReturn.append(Dynamic(taskToAdd))
            _task.unwrappedRepeatables!.append(taskToAdd)
        }
        return toReturn
    }
}
