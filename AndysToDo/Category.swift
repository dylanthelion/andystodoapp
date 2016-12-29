//
//  Category.swift
//  AndysToDo
//
//  Created by dillion on 10/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation
import UIKit

class  Category : Equatable {
    var name : String?
    var description : String?
    
    init(name : String, description : String) {
        self.name = name
        self.description = description
    }
    
    func isValid() -> Bool {
        return name != nil && description != nil
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        return
            lhs.name! == rhs.name!
    }
}

class TimeCategory : Category {
    
    var color : CGColor?
    var startOfTimeWindow : Float?
    var endOfTimeWindow : Float?
    
    init(name : String, description : String, start : Float, end: Float, color: CGColor?) {
        super.init(name: name, description: description)
        startOfTimeWindow = start
        endOfTimeWindow = end
        self.color = color
    }
    
    override func isValid() -> Bool {
        return name != nil && description != nil && startOfTimeWindow != nil && endOfTimeWindow != nil
    }
}
