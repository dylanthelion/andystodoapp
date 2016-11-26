//
//  CategoryDTO.swift
//  AndysToDo
//
//  Created by dillion on 11/17/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

private let _DTO = CategoryDTO()

class CategoryDTO {
    
    var delegate : TaskDTODelegate?
    var AllCategories : Dynamic<[Dynamic<Category>]>?
    
    class var shared : CategoryDTO {
        return _DTO
    }
    
    func loadCategories() {
        // logic to load categories from file and/or server
        
        // Until persistence is finished, load fake categories
        if AllCategories == nil {
            AllCategories = Dynamic(loadFakeCategories())
        }
    }
    
    func loadFakeCategories() -> [Dynamic<Category>] {
        let category1 = Dynamic(Category(_name: "Category 1", _description: "Fake Category"))
        let category2 = Dynamic(Category(_name: "Category 2", _description: "Another fake Category"))
        let category3 = Dynamic(Category(_name: "Category 3", _description: "The worst fake category"))
        return [category1, category2, category3]
    }
    
    // CRUD
    
    func createNewCategory(_category : Category) -> Bool {
        if _category.isValid() {
            var isUnique = true
            for _cat in AllCategories!.value {
                if _cat.value == _category {
                    isUnique = false
                    break
                }
            }
            if isUnique {
                AllCategories!.value.append(Dynamic(_category))
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func updateCategory(_oldCategory: Category, _category : Category) -> Bool {
        if _category.isValid() {
            for _cat in AllCategories!.value {
                if _cat.value.Name == _oldCategory.Name! {
                    _cat.value.Name = _category.Name!
                    _cat.value.Description = _category.Description!
                    return true
                }
            }
        }
        return false
    }
}
