//
//  TimeCategoryDTO.swift
//  AndysToDo
//
//  Created by dillion on 11/17/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

private let _DTO = TimeCategoryDTO()

class TimeCategoryDTO {
    
    var AllTimeCategories : Dynamic<[Dynamic<TimeCategory>]>?
    
    init() {
        loadTimeCategories()
    }
    
    class var shared : TimeCategoryDTO {
        return _DTO
    }
    
    func loadTimeCategories() {
        // logic to load categories from file and/or server
        
        // Until persistence is finished, load fake categories
        
        if AllTimeCategories == nil {
            AllTimeCategories = Dynamic(loadFakeTimeCategories())
        }
        
    }
    
    func loadFakeTimeCategories() -> [Dynamic<TimeCategory>] {
        let category1 = Dynamic(TimeCategory(_name: "Time Cat 1", _description: "Fake Morning", _start: 8.5, _end: 11.0, _color: UIColor.red.cgColor))
        let category2 = Dynamic(TimeCategory(_name: "Time Cat 2", _description: "Fake Lunch Hours", _start: 12.25, _end: 13.25, _color: UIColor.green.cgColor))
        let category3 = Dynamic(TimeCategory(_name: "Time Cat 3", _description: "Fake Afternoon", _start: 14.0, _end: 17.0, _color: UIColor.green.cgColor))
        let category4 = Dynamic(TimeCategory(_name: "Time Cat 4", _description: "Fake evening", _start: 18.5, _end: 21.75, _color: nil))
        return [category1, category2, category3, category4]
    }
    
    // Time Category CRUD
    
    func createNewTimeCategory(_category : TimeCategory) -> Bool {
        if _category.isValid() {
            var isUnique = true
            for _cat in AllTimeCategories!.value {
                if _cat.value == _category {
                    isUnique = false
                    break
                }
            }
            if isUnique {
                AllTimeCategories!.value.append(Dynamic(_category))
                return true
            } else {
                return false
            }
            
        }
        return false
    }
    
    func updateTimeCategory(_oldCategory : TimeCategory, _category: TimeCategory) -> Bool {
        if _category.isValid() {
            for _cat in AllTimeCategories!.value {
                if _cat.value.Name == _oldCategory.Name! {
                    _cat.value.Name = _category.Name!
                    _cat.value.Description = _category.Description!
                    _cat.value.StartOfTimeWindow = _category.StartOfTimeWindow
                    _cat.value.EndOfTimeWindow = _category.EndOfTimeWindow
                    _cat.value.color = _category.color
                    return true
                }
            }
        }
        
        return false
    }
}
