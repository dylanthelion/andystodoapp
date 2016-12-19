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
        var toReturn = [Dynamic<Task>]()
        let component = getTimeInterval(_task.RepeatableTask!.UnitOfTime!)
        let startDate = getStartingDate(_task, adding: (component * TimeInterval(_task.RepeatableTask!.UnitsPerTask!)))
        for i in 0..<toUnwrap {
            let taskToAdd = Task(_name: "\(_task.Name!)\(i + _task.unwrappedRepeatables!.count)", _description: _task.Description!, _start: startDate.addingTimeInterval(TimeInterval(i) * component), _finish: nil, _category: _task.Categories, _timeCategory: _task.TimeCategory, _repeatable: nil, _dueDate: nil, _parent: _task.ID!, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
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
    
    class func getStartingDate(_ task : Task, adding timeInterval : TimeInterval) -> NSDate {
        var startDate : NSDate
        if !CollectionHelper.IsNilOrEmpty(_coll: task.unwrappedRepeatables) {
            startDate = task.unwrappedRepeatables!.last!.StartTime!.addingTimeInterval(timeInterval)
        } else {
            startDate = (task.RepeatableTask?.FirstOccurrence!)!
            
            let now = Date()
            while (startDate as Date) < now {
                startDate = startDate.addingTimeInterval(timeInterval)
            }
        }
        return startDate
    }
    
    class func getTimeInterval(_ unit : RepetitionTimeCategory) -> TimeInterval {
        let component : TimeInterval
        if unit == .Daily {
            component = TimeInterval(Constants.seconds_per_day)
        } else if unit == .Hourly {
            component = TimeInterval(Constants.seconds_per_hour)
        } else {
            component = TimeInterval(Constants.seconds_per_day * 7)
        }
        return component
    }
}
