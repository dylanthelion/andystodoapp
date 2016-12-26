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
        let archive1 = Task(name: "Archive 1", description: "Fake archived task", start: Date().addingTimeInterval(-4000) as NSDate?, finish: Date().addingTimeInterval(-2000) as NSDate?, category: [CategoryDTO.shared.allCategories!.value[2].value, CategoryDTO.shared.allCategories!.value[0].value], timeCategory: TimeCategoryDTO.shared.allTimeCategories!.value[1].value, repeatable: nil, dueDate: nil, parent: nil, expectedUnitOfTime: UnitOfTime.Hour, expectedTotalUnits: 2)
        let archive2 = Task(name: "Archive 2", description: "Fake archived task", start: Date().addingTimeInterval(-8000) as NSDate?, finish: Date().addingTimeInterval(-6000) as NSDate?, category: [CategoryDTO.shared.allCategories!.value[1].value, CategoryDTO.shared.allCategories!.value[0].value], timeCategory: TimeCategoryDTO.shared.allTimeCategories!.value[0].value, repeatable: nil, dueDate: nil, parent: nil, expectedUnitOfTime: nil, expectedTotalUnits: nil)
        let archive3 = Task(name: "Archive 3", description: "Fake archived task", start: Date().addingTimeInterval(-400000) as NSDate?, finish: Date().addingTimeInterval(-320000) as NSDate?, category: [CategoryDTO.shared.allCategories!.value[1].value, CategoryDTO.shared.allCategories!.value[2].value], timeCategory: TimeCategoryDTO.shared.allTimeCategories!.value[1].value, repeatable: nil, dueDate: nil, parent: nil, expectedUnitOfTime: .Day, expectedTotalUnits: 2)
        let archive4 = Task(name: "Archive 4", description: "Fake archived task", start: Date().addingTimeInterval(-6000000) as NSDate?, finish: Date().addingTimeInterval(-580000) as NSDate?, category: [CategoryDTO.shared.allCategories!.value[2].value, CategoryDTO.shared.allCategories!.value[0].value], timeCategory: TimeCategoryDTO.shared.allTimeCategories!.value[2].value, repeatable: nil, dueDate: nil, parent: nil, expectedUnitOfTime: .Week, expectedTotalUnits: 1)
        let repeatable1 = RepeatableTaskOccurrence(unit: RepetitionTimeCategory.Daily, unitCount: 2, time: 13.5, firstOccurrence: Date().addingTimeInterval(-40000) as NSDate?, dayOfWeek: nil)
        let archive5 = Task(name: "Archive 5", description: "Fake archived task with daily repetition", start: Date().addingTimeInterval(-40000) as NSDate?, finish: Date().addingTimeInterval(-4000) as NSDate?, category: [CategoryDTO.shared.allCategories!.value[2].value], timeCategory: TimeCategoryDTO.shared.allTimeCategories!.value[2].value, repeatable: repeatable1, dueDate: nil, parent: nil, expectedUnitOfTime: nil, expectedTotalUnits: nil)
        let archive6 = Task(name: "Archive 6", description: "Fake archived task", start: Date().addingTimeInterval(-30000) as NSDate?, finish: Date().addingTimeInterval(-28000) as NSDate?, category: [CategoryDTO.shared.allCategories!.value[2].value], timeCategory: TimeCategoryDTO.shared.allTimeCategories!.value[2].value, repeatable: nil, dueDate: nil, parent: archive5.ID!, expectedUnitOfTime: nil, expectedTotalUnits: nil)
        let archive7 = Task(name: "Archive 7", description: "Fake archived task", start: Date().addingTimeInterval(-20000) as NSDate?, finish: Date().addingTimeInterval(-18000) as NSDate?, category: [CategoryDTO.shared.allCategories!.value[2].value], timeCategory: TimeCategoryDTO.shared.allTimeCategories!.value[2].value, repeatable: nil, dueDate: nil, parent: archive5.ID!, expectedUnitOfTime: nil, expectedTotalUnits: nil)
        let archive8 = Task(name: "Archive 8", description: "Fake archived task", start: Date().addingTimeInterval(-10000) as NSDate?, finish: Date().addingTimeInterval(-8000) as NSDate?, category: [CategoryDTO.shared.allCategories!.value[2].value], timeCategory: TimeCategoryDTO.shared.allTimeCategories!.value[2].value, repeatable: nil, dueDate: nil, parent: archive5.ID!, expectedUnitOfTime: nil, expectedTotalUnits: nil)
        let archive9 = Task(name: "Archive 9", description: "Fake archived task", start: Date().addingTimeInterval(-8000) as NSDate?, finish: Date().addingTimeInterval(-6000) as NSDate?, category: [CategoryDTO.shared.allCategories!.value[2].value], timeCategory: TimeCategoryDTO.shared.allTimeCategories!.value[2].value, repeatable: nil, dueDate: nil, parent: archive5.ID!, expectedUnitOfTime: nil, expectedTotalUnits: nil)
        archive5.unwrappedRepeatables = [archive6, archive7, archive8, archive9]
        let repeatable2 = RepeatableTaskOccurrence(unit: RepetitionTimeCategory.Daily, unitCount: 2, time: 13.5, firstOccurrence: Date().addingTimeInterval(-400000) as NSDate?, dayOfWeek: nil)
        let archive10 = Task(name: "Archive 10", description: "Fake task with daily repetition", start: Date().addingTimeInterval(-40000) as NSDate?, finish: nil, category: [CategoryDTO.shared.allCategories!.value[1].value], timeCategory: TimeCategoryDTO.shared.allTimeCategories!.value[1].value, repeatable: repeatable2, dueDate: nil, parent: nil, expectedUnitOfTime: nil, expectedTotalUnits: nil)
        let archive11 = Task(name: "Archive 11", description: "Fake archived task", start: Date().addingTimeInterval(-10000) as NSDate?, finish: Date().addingTimeInterval(-8000) as NSDate?, category: [CategoryDTO.shared.allCategories!.value[1].value], timeCategory: TimeCategoryDTO.shared.allTimeCategories!.value[1].value, repeatable: nil, dueDate: nil, parent: archive10.ID!, expectedUnitOfTime: nil, expectedTotalUnits: nil)
        let archive12 = Task(name: "Archive 12", description: "Fake archived task", start: Date().addingTimeInterval(-8000) as NSDate?, finish: Date().addingTimeInterval(-6000) as NSDate?, category: [CategoryDTO.shared.allCategories!.value[1].value], timeCategory: TimeCategoryDTO.shared.allTimeCategories!.value[1].value, repeatable: nil, dueDate: nil, parent: archive10.ID!, expectedUnitOfTime: nil, expectedTotalUnits: nil)
        archive10.unwrappedRepeatables = [archive11, archive12]
        archivedTasks = Dynamic([Dynamic(archive1), Dynamic(archive2), Dynamic(archive3), Dynamic(archive4), Dynamic(archive5), Dynamic(archive6), Dynamic(archive7), Dynamic(archive8), Dynamic(archive9), Dynamic(archive11), Dynamic(archive12)])
    }
    
    // CRUD
    
    func addToArchive(_ task: Task) {
        if let _ = archivedTasks {
            archivedTasks?.value.append(Dynamic(task))
        } else {
            archivedTasks = Dynamic([Dynamic(task)])
        }
    }
    
    func editArchivedTask(_ task : Task) {
        archivedTasks!.value[archivedTasks!.value.index(of: Dynamic(task))!] = Dynamic(task)
    }
    
    func deleteArchivedTask(_ task: Task) {
        if let checkIndex = archivedTasks?.value.index(of: Dynamic(task)) {
            archivedTasks!.value.remove(at: checkIndex)
        }
    }
    
    func deArchive(_ task: Task) -> Bool {
        task.finishTime = nil
        task.startTime = NSDate()
        TaskDTO.globalManager.deArchive(task)
        archivedTasks!.value.remove(at: Int(archivedTasks!.value.index(of: Dynamic(task))!))
        return true
    }
}
