//
//  RepeatableUnwrapper.swift
//  AndysToDo
//
//  Created by dillion on 12/9/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class RepeatableUnwrapper {
    
    class func unwrapRepeatables(_ task : Task, toUnwrap : Int) -> [Dynamic<Task>] {
        if CollectionHelper.IsNilOrEmpty(task.unwrappedRepeatables) {
            task.unwrappedRepeatables = [Task]()
        }
        if task.unwrappedRepeatables!.filter({ $0.finishTime == nil }).count >= toUnwrap {
            return task.unwrappedRepeatables!.map({ Dynamic($0) })
        }
        var toReturn = [Dynamic<Task>]()
        let component = getTimeInterval(task.repeatableTask!.unitOfTime!)
        let startDate = getStartingDate(task, adding: (component * TimeInterval(task.repeatableTask!.unitsPerTask!)))
        for i in 0..<toUnwrap {
            let taskToAdd = Task(name: "\(task.name!)\(i + task.unwrappedRepeatables!.count)", description: task.description!, start: startDate.addingTimeInterval(TimeInterval(i) * component), finish: nil, category: task.categories, timeCategory: task.timeCategory, repeatable: nil, dueDate: nil, parent: task.ID!, expectedUnitOfTime: nil, expectedTotalUnits: nil)
            taskToAdd.ID = Int(NSDate().timeIntervalSince1970) + Int(taskToAdd.startTime!.timeIntervalSince1970)
            toReturn.append(Dynamic(taskToAdd))
            task.unwrappedRepeatables!.append(taskToAdd)
        }
        return toReturn
    }
    
    class func generateRepeatablesFrom(repeatables : [RepeatableTaskOccurrence], ofParent : Task, withID: Int) -> [Task]? {
        var newTasks = [Task]()
        var areValid = true
        for index in 0..<repeatables.count {
            let task = Task(name: ofParent.name!, description: ofParent.description!, start: ofParent.startTime, finish: ofParent.finishTime, category: ofParent.categories, timeCategory: ofParent.timeCategory, repeatable: ofParent.repeatableTask, dueDate: ofParent.dueDate, parent: withID, expectedUnitOfTime: ofParent.expectedTimeRequirement.unit, expectedTotalUnits: ofParent.expectedTimeRequirement.numberOfUnits)
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
    
    class func removeChildren(_ allTasks : [Task]) -> ([Task], [Task]) {
        var childTasks = [Task]()
        for parent in allTasks {
            for child in allTasks {
                if child.parentID == nil {
                    continue
                }
                if parent.ID! == child.parentID! && childTasks.index(of: child) == nil {
                    childTasks.append(child)
                }
            }
        }
        return (allTasks.filter({ childTasks.index(of: $0) == nil }), childTasks)
    }
    
    class func getStartingDate(_ task : Task, adding timeInterval : TimeInterval) -> NSDate {
        var startDate : NSDate
        if !CollectionHelper.IsNilOrEmpty(task.unwrappedRepeatables) {
            startDate = task.unwrappedRepeatables!.last!.startTime!.addingTimeInterval(timeInterval)
        } else {
            startDate = (task.repeatableTask?.firstOccurrence!)!
            
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
