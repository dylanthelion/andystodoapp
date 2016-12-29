//
//  CategoryDTO.swift
//  AndysToDo
//
//  Created by dillion on 11/17/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

private let sharedDTO = CategoryDTO()

class CategoryDTO {
    
    var allCategories : Dynamic<[Dynamic<Category>]>?
    
    init() {
        loadCategories()
    }
    
    class var shared : CategoryDTO {
        return sharedDTO
    }
    
    func loadCategories() {
        // logic to load categories from file and/or server
        
        // Until persistence is finished, load fake categories
        if allCategories == nil {
            allCategories = Dynamic(loadFakeCategories())
        }
    }
    
    func loadFakeCategories() -> [Dynamic<Category>] {
        let category1 = Dynamic(Category(name: "Category 1", description: "Fake Category"))
        let category2 = Dynamic(Category(name: "Category 2", description: "Another fake Category"))
        let category3 = Dynamic(Category(name: "Category 3", description: "The worst fake category"))
        return [category1, category2, category3]
    }
    
    // CRUD
    
    func createNewCategory(_ category : Category) -> Bool {
        if category.isValid() {
            var isUnique = true
            for cat in allCategories!.value {
                if cat.value == category {
                    isUnique = false
                    break
                }
            }
            if isUnique {
                allCategories!.value.append(Dynamic(category))
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func updateCategory(oldCategory: Category, newCategory : Category) -> Bool {
        if newCategory.isValid() {
            for cat in allCategories!.value {
                if cat.value.name == oldCategory.name! {
                    cat.value.name = newCategory.name!
                    cat.value.description = newCategory.description!
                    return true
                }
            }
        }
        return false
    }
}
