//
//  TimeCategoryDTO.swift
//  AndysToDo
//
//  Created by dillion on 11/17/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private let sharedDTO = TimeCategoryDTO()

class TimeCategoryDTO {
    
    var allTimeCategories : Dynamic<[Dynamic<TimeCategory>]>?
    
    init() {
        loadTimeCategories()
    }
    
    class var shared : TimeCategoryDTO {
        return sharedDTO
    }
    
    func loadTimeCategories() {
        // logic to load categories from file and/or server
        
        // Until persistence is finished, load fake categories
        
        if allTimeCategories == nil {
            allTimeCategories = Dynamic(loadFakeTimeCategories())
        }
    }
    
    func loadFakeTimeCategories() -> [Dynamic<TimeCategory>] {
        let category1 = Dynamic(TimeCategory(name: "Time Cat 1", description: "Fake Morning", start: 8.5, end: 11.0, color: UIColor.red.cgColor))
        let category2 = Dynamic(TimeCategory(name: "Time Cat 2", description: "Fake Lunch Hours", start: 12.25, end: 13.25, color: UIColor.green.cgColor))
        let category3 = Dynamic(TimeCategory(name: "Time Cat 3", description: "Fake Afternoon", start: 14.0, end: 17.0, color: UIColor.green.cgColor))
        let category4 = Dynamic(TimeCategory(name: "Time Cat 4", description: "Fake evening", start: 18.5, end: 21.75, color: nil))
        return [category1, category2, category3, category4]
    }
    
    // Time Category CRUD
    
    func createNewTimeCategory(_ category : TimeCategory) -> Bool {
        if category.isValid() {
            var isUnique = true
            for cat in allTimeCategories!.value {
                if cat.value == category {
                    isUnique = false
                    break
                }
            }
            if isUnique {
                allTimeCategories!.value.append(Dynamic(category))
                return true
            } else {
                return false
            }
            
        }
        return false
    }
    
    func updateTimeCategory(oldCategory : TimeCategory, newCategory: TimeCategory) -> Bool {
        if newCategory.isValid() {
            for cat in allTimeCategories!.value {
                if cat.value.name == oldCategory.name! {
                    cat.value.name = newCategory.name!
                    cat.value.description = newCategory.description!
                    cat.value.startOfTimeWindow = newCategory.startOfTimeWindow
                    cat.value.endOfTimeWindow = newCategory.endOfTimeWindow
                    cat.value.color = newCategory.color
                    return true
                }
            }
        }
        
        return false
    }
}
