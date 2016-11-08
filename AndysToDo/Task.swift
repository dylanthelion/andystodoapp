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
    
    init(_name: String, _description: String, _start : NSDate?, _finish : NSDate?, _category : [Category]?, _timeCategory : TimeCategory?, _repeatable : RepeatableTaskOccurrence?) {
        Name = _name
        Description = _description
        StartTime = _start
        FinishTime = _finish
        Categories = _category
        TimeCategory = _timeCategory
        RepeatableTask = _repeatable
        ID = TaskDTO.globalManager.getNextID()
        siblingRepeatables = [Task]()
    }
    
    func isValid() -> Bool {
        //print("ID: \(ID)\nName: \(Name)\nDescription: \(Description)\nStart Time: \(StartTime)")
        print("Call is valid")
        return ID != nil && isValidWithoutId()
    }
    
    func isValidWithoutId() -> Bool {
        print("Call with ID")
        print("Repeatable: \(self.RepeatableTask)")
        if let _ = self.RepeatableTask {
            if Name == "Task 5" {
                print("Task:\nName: \(Name)\nDescription: \(Description)\nStart: \(StartTime)")
            }
            return Name != nil && Description != nil && RepeatableTask!.isValid() && StartTime != nil
        } else {
            return Name != nil && Description != nil && StartTime != nil
        }
    }
    
    func isRepeatable() -> Bool {
        return isValid() && RepeatableTask != nil
    }
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return
            lhs.ID! == rhs.ID!
    }
}
