//
//  Task.swift
//  AndysToDo
//
//  Created by dillion on 10/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class Task : Equatable {
    
    var ID : Int?
    var name : String?
    var description : String?
    var startTime : NSDate?
    var finishTime : NSDate?
    var inProgress : Bool = false
    var categories : [Category]?
    var timeCategory : TimeCategory?
    var repeatableTask : RepeatableTaskOccurrence?
    var unwrappedRepeatables : [Task]?
    var siblingRepeatables : [Task]?
    var parentID : Int?
    var timeOnTask : TimeInterval?
    var dueDate : NSDate?
    var expectedTimeRequirement : ExpectedTimeRequirement
    
    init(name: String, description: String, start : NSDate?, finish : NSDate?, category : [Category]?, timeCategory : TimeCategory?, repeatable : RepeatableTaskOccurrence?, dueDate : NSDate?, parent: Int?, expectedUnitOfTime : UnitOfTime?, expectedTotalUnits : Int?) {
        self.name = name
        self.description = description
        startTime = start
        finishTime = finish
        categories = category
        self.timeCategory = timeCategory
        repeatableTask = repeatable
        ID = IDGenerator.shared.getNextID()
        siblingRepeatables = [Task]()
        timeOnTask = 0.0
        expectedTimeRequirement = ExpectedTimeRequirement(_unit: .Null, _numberOfUnits: 0)
        self.dueDate = dueDate
        parentID = parent
        if let _ = expectedUnitOfTime, let _ = expectedTotalUnits {
            expectedTimeRequirement.update(expectedUnitOfTime!, expectedTotalUnits!)
        }
    }
    
    func isValid() -> Bool {
        return ID != nil && isValidWithoutId()
    }
    
    func isValidWithoutId() -> Bool {
        if let _ = repeatableTask {
            return name != nil && description != nil && repeatableTask!.isValid() && startTime != nil
        } else {
            return name != nil && description != nil && startTime != nil
        }
    }
    
    func isRepeatable() -> Bool {
        return isValid() && repeatableTask != nil
    }
    
    static func == (left: Task, right: Task) -> Bool {
        return
            left.ID! == right.ID!
    }
}
