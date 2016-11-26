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
    var Name : String?
    var Description : String?
    var StartTime : NSDate?
    var FinishTime : NSDate?
    var inProgress : Bool = false
    var Categories : [Category]?
    var TimeCategory : TimeCategory?
    var RepeatableTask : RepeatableTaskOccurrence?
    var unwrappedRepeatables : [Task]?
    var siblingRepeatables : [Task]?
    var parentID : Int?
    var timeOnTask : TimeInterval?
    var dueDate : NSDate?
    var expectedTimeRequirement : (UnitOfTime, Int)?
    
    init(_name: String, _description: String, _start : NSDate?, _finish : NSDate?, _category : [Category]?, _timeCategory : TimeCategory?, _repeatable : RepeatableTaskOccurrence?) {
        Name = _name
        Description = _description
        StartTime = _start
        FinishTime = _finish
        Categories = _category
        TimeCategory = _timeCategory
        RepeatableTask = _repeatable
        ID = IDGenerator.shared.getNextID()
        siblingRepeatables = [Task]()
        timeOnTask = 0.0
    }
    
    convenience init(_name: String, _description: String, _start : NSDate?, _finish : NSDate?, _category : [Category]?, _timeCategory : TimeCategory?, _repeatable : RepeatableTaskOccurrence?, _dueDate : NSDate?, _parent: Int?, _expectedUnitOfTime : UnitOfTime?, _expectedTotalUnits : Int?) {
        self.init(_name: _name, _description: _description, _start : _start, _finish : _finish, _category : _category, _timeCategory : _timeCategory, _repeatable : _repeatable)
        dueDate = _dueDate
        parentID = _parent
        if let _ = _expectedUnitOfTime, let _ = _expectedTotalUnits {
            expectedTimeRequirement = (_expectedUnitOfTime!, _expectedTotalUnits!)
        }
    }
    
    func isValid() -> Bool {
        return ID != nil && isValidWithoutId()
    }
    
    func isValidWithoutId() -> Bool {
        if let _ = self.RepeatableTask {
            return Name != nil && Description != nil && RepeatableTask!.isValid() && StartTime != nil
        } else {
            return Name != nil && Description != nil && StartTime != nil
        }
    }
    
    func isRepeatable() -> Bool {
        return isValid() && RepeatableTask != nil
    }
    
    static func == (left: Task, right: Task) -> Bool {
        return
            left.ID! == right.ID!
    }
}
