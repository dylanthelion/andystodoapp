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
    
    var delegate : TaskDTODelegate?
    var AllTimeCategories : [TimeCategory]?
    
    class var shared : TimeCategoryDTO {
        return _DTO
    }
    
    func loadTimeCategories() {
        // logic to load categories from file and/or server
        
        // Until persistence is finished, load fake categories
        
        if AllTimeCategories == nil {
            AllTimeCategories = loadFakeTimeCategories()
        }
        
    }
    
    func loadFakeTimeCategories() -> [TimeCategory] {
        let category1 = TimeCategory(_name: "Time Cat 1", _description: "Fake Morning", _start: 8.5, _end: 11.0, _color: UIColor.red.cgColor)
        let category2 = TimeCategory(_name: "Time Cat 2", _description: "Fake Lunch Hours", _start: 12.25, _end: 13.25, _color: UIColor.green.cgColor)
        let category3 = TimeCategory(_name: "Time Cat 3", _description: "Fake Afternoon", _start: 14.0, _end: 17.0, _color: UIColor.green.cgColor)
        let category4 = TimeCategory(_name: "Time Cat 4", _description: "Fake evening", _start: 18.5, _end: 21.75, _color: nil)
        return [category1, category2, category3, category4]
    }
    
    // Time Category CRUD
    
    func createNewTimeCategory(_category : TimeCategory) -> Bool {
        if _category.isValid() {
            var isUnique = true
            for _cat in AllTimeCategories! {
                if _cat == _category {
                    isUnique = false
                    break
                }
            }
            if isUnique {
                AllTimeCategories!.append(_category)
                return true
            } else {
                return false
            }
            
        }
        return false
    }
    
    func updateTimeCategory(_oldCategory : TimeCategory, _category: TimeCategory) -> Bool {
        if _category.isValid() {
            for _cat in AllTimeCategories! {
                if _cat.Name == _oldCategory.Name! {
                    _cat.Name = _category.Name!
                    _cat.Description = _category.Description!
                    _cat.StartOfTimeWindow = _category.StartOfTimeWindow
                    _cat.EndOfTimeWindow = _category.EndOfTimeWindow
                    _cat.color = _category.color
                    return true
                }
            }
        }
        
        return false
    }
}
