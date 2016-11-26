//
//  IDGenerator.swift
//  AndysToDo
//
//  Created by dillion on 11/26/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

private let generator = IDGenerator()

class IDGenerator {
    
    var nextTaskID : Int = 1
    
    class var shared : IDGenerator {
        return generator
    }
    
    func getNextID() -> Int {
        nextTaskID += 1
        return nextTaskID
    }
}
