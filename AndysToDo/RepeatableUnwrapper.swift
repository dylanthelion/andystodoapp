//
//  RepeatableUnwrapper.swift
//  AndysToDo
//
//  Created by dillion on 12/9/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class RepeatableUnwrapper {
    
    class func unwrapRepeatables(_task : Task, toUnwrap : Int) -> [Dynamic<Task>] {
        if CollectionHelper.IsNilOrEmpty(_coll: _task.unwrappedRepeatables) {
            _task.unwrappedRepeatables = [Task]()
        }
        if _task.unwrappedRepeatables!.filter({ $0.FinishTime == nil }).count >= toUnwrap {
            return _task.unwrappedRepeatables!.map({ Dynamic($0) })
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
            let taskToAdd = Task(_name: "\(_task.Name!)\(i + _task.unwrappedRepeatables!.count)", _description: _task.Description!, _start: startDate!.addingTimeInterval(component * TimeInterval(units)), _finish: nil, _category: _task.Categories, _timeCategory: _task.TimeCategory, _repeatable: nil, _dueDate: nil, _parent: _task.ID!, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
            taskToAdd.ID = Int(NSDate().timeIntervalSince1970) + Int(taskToAdd.StartTime!.timeIntervalSince1970)
            toReturn.append(Dynamic(taskToAdd))
            _task.unwrappedRepeatables!.append(taskToAdd)
        }
        return toReturn
    }
    
    class func generateRepeatablesFrom(repeatables : [RepeatableTaskOccurrence], ofParent : Task, withID: Int) -> [Task]? {
        var newTasks = [Task]()
        var areValid = true
        for index in 0..<repeatables.count {
            let task = Task(_name: ofParent.Name!, _description: ofParent.Description!, _start: ofParent.StartTime, _finish: ofParent.FinishTime, _category: ofParent.Categories, _timeCategory: ofParent.TimeCategory, _repeatable: ofParent.RepeatableTask, _dueDate: ofParent.dueDate, _parent: withID, _expectedUnitOfTime: ofParent.expectedTimeRequirement.unit, _expectedTotalUnits: ofParent.expectedTimeRequirement.numberOfUnits)
            if !task.isValidWithoutId() {
                areValid = false
                break
            }
            newTasks.append(task)
            if index != 0 {
                newTasks[0].siblingRepeatables!.append(task)
            }
        }
        
        if areValid {
            return newTasks
        } else {
            return nil
        }
    }
    
    class func removeChildren(allTasks : [Task]) -> ([Task], [Task]) {
        var childTasks = [Task]()
        for _parent in allTasks {
            for _child in allTasks {
                if _child.parentID == nil {
                    continue
                }
                if _parent.ID! == _child.parentID! && childTasks.index(of: _child) == nil {
                    childTasks.append(_child)
                }
            }
        }
        return (allTasks.filter({ childTasks.index(of: $0) == nil }), childTasks)
    }
}
