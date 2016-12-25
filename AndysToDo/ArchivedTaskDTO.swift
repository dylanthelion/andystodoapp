//
//  ArchivedTaskDTO.swift
//  AndysToDo
//
//  Created by dillion on 12/14/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

private let allArchives = ArchivedTaskDTO()

class ArchivedTaskDTO {
    
    var archivedTasks : Dynamic<[Dynamic<Task>]>?
    
    init() {
        loadTasks()
    }
    
    class var shared : ArchivedTaskDTO {
        return allArchives
    }
    
    func loadTasks() {
        loadFakeArchivedTasks()
    }
    
    // Fake tasks to load until persistence is set up
    
    func loadFakeArchivedTasks() {
        let archive1 = Task(_name: "Archive 1", _description: "Fake archived task", _start: Date().addingTimeInterval(-4000) as NSDate?, _finish: Date().addingTimeInterval(-2000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[2].value, CategoryDTO.shared.AllCategories!.value[0].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[1].value, _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: UnitOfTime.Hour, _expectedTotalUnits: 2)
        let archive2 = Task(_name: "Archive 2", _description: "Fake archived task", _start: Date().addingTimeInterval(-8000) as NSDate?, _finish: Date().addingTimeInterval(-6000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[1].value, CategoryDTO.shared.AllCategories!.value[0].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[0].value, _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        let archive3 = Task(_name: "Archive 3", _description: "Fake archived task", _start: Date().addingTimeInterval(-400000) as NSDate?, _finish: Date().addingTimeInterval(-320000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[1].value, CategoryDTO.shared.AllCategories!.value[2].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[1].value, _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: .Day, _expectedTotalUnits: 2)
        let archive4 = Task(_name: "Archive 4", _description: "Fake archived task", _start: Date().addingTimeInterval(-6000000) as NSDate?, _finish: Date().addingTimeInterval(-580000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[2].value, CategoryDTO.shared.AllCategories!.value[0].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[2].value, _repeatable: nil, _dueDate: nil, _parent: nil, _expectedUnitOfTime: .Week, _expectedTotalUnits: 1)
        let repeatable1 = RepeatableTaskOccurrence(_unit: RepetitionTimeCategory.Daily, _unitCount: 2, _time: 13.5, _firstOccurrence: Date().addingTimeInterval(-40000) as NSDate?, _dayOfWeek: nil)
        let archive5 = Task(_name: "Archive 5", _description: "Fake archived task with daily repetition", _start: Date().addingTimeInterval(-40000) as NSDate?, _finish: Date().addingTimeInterval(-4000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[2].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[2].value, _repeatable: repeatable1, _dueDate: nil, _parent: nil, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        let archive6 = Task(_name: "Archive 6", _description: "Fake archived task", _start: Date().addingTimeInterval(-30000) as NSDate?, _finish: Date().addingTimeInterval(-28000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[2].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[2].value, _repeatable: nil, _dueDate: nil, _parent: archive5.ID!, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        let archive7 = Task(_name: "Archive 7", _description: "Fake archived task", _start: Date().addingTimeInterval(-20000) as NSDate?, _finish: Date().addingTimeInterval(-18000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[2].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[2].value, _repeatable: nil, _dueDate: nil, _parent: archive5.ID!, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        let archive8 = Task(_name: "Archive 8", _description: "Fake archived task", _start: Date().addingTimeInterval(-10000) as NSDate?, _finish: Date().addingTimeInterval(-8000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[2].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[2].value, _repeatable: nil, _dueDate: nil, _parent: archive5.ID!, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        let archive9 = Task(_name: "Archive 9", _description: "Fake archived task", _start: Date().addingTimeInterval(-8000) as NSDate?, _finish: Date().addingTimeInterval(-6000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[2].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[2].value, _repeatable: nil, _dueDate: nil, _parent: archive5.ID!, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        archive5.unwrappedRepeatables = [archive6, archive7, archive8, archive9]
        let repeatable2 = RepeatableTaskOccurrence(_unit: RepetitionTimeCategory.Daily, _unitCount: 2, _time: 13.5, _firstOccurrence: Date().addingTimeInterval(-400000) as NSDate?, _dayOfWeek: nil)
        let archive10 = Task(_name: "Archive 10", _description: "Fake task with daily repetition", _start: Date().addingTimeInterval(-40000) as NSDate?, _finish: nil, _category: [CategoryDTO.shared.AllCategories!.value[1].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[1].value, _repeatable: repeatable2, _dueDate: nil, _parent: nil, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        let archive11 = Task(_name: "Archive 11", _description: "Fake archived task", _start: Date().addingTimeInterval(-10000) as NSDate?, _finish: Date().addingTimeInterval(-8000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[1].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[1].value, _repeatable: nil, _dueDate: nil, _parent: archive10.ID!, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        let archive12 = Task(_name: "Archive 12", _description: "Fake archived task", _start: Date().addingTimeInterval(-8000) as NSDate?, _finish: Date().addingTimeInterval(-6000) as NSDate?, _category: [CategoryDTO.shared.AllCategories!.value[1].value], _timeCategory: TimeCategoryDTO.shared.AllTimeCategories!.value[1].value, _repeatable: nil, _dueDate: nil, _parent: archive10.ID!, _expectedUnitOfTime: nil, _expectedTotalUnits: nil)
        archive10.unwrappedRepeatables = [archive11, archive12]
        archivedTasks = Dynamic([Dynamic(archive1), Dynamic(archive2), Dynamic(archive3), Dynamic(archive4), Dynamic(archive5), Dynamic(archive6), Dynamic(archive7), Dynamic(archive8), Dynamic(archive9), Dynamic(archive11), Dynamic(archive12)])
    }
    
    // CRUD
    
    func addToArchive(_task: Task) {
        if let _ = archivedTasks {
            archivedTasks?.value.append(Dynamic(_task))
        } else {
            archivedTasks = Dynamic([Dynamic(_task)])
        }
    }
    
    func editArchivedTask(_task : Task) {
        archivedTasks!.value[archivedTasks!.value.index(of: Dynamic(_task))!] = Dynamic(_task)
    }
    
    func deleteArchivedTask(_task: Task) {
        if let checkIndex = archivedTasks?.value.index(of: Dynamic(_task)) {
            archivedTasks!.value.remove(at: checkIndex)
        }
    }
    
    func deArchive(_task: Task) -> Bool {
        _task.FinishTime = nil
        _task.StartTime = NSDate()
        TaskDTO.globalManager.deArchive(task: _task)
        archivedTasks!.value.remove(at: Int(archivedTasks!.value.index(of: Dynamic(_task))!))
        return true
    }
}
