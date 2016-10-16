//
//  Category.swift
//  AndysToDo
//
//  Created by dillion on 10/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class  Category {
    var Name : String?
    var Description : String?
    
    init(_name : String, _description : String) {
        Name = _name
        Description = _description
    }
    
    func isValid() -> Bool {
        return Name != nil && Description != nil
    }
}

class TimeCategory : Category {
    
    init(_name : String, _description : String, _start : Float, _end: Float) {
        super.init(_name: _name, _description: _description)
        StartOfTimeWindow = _start
        EndOfTimeWindow = _end
    }
    
    var StartOfTimeWindow : Float?
    var EndOfTimeWindow : Float?
}
