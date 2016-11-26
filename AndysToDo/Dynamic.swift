//
//  Dynamic.swift
//  AndysToDo
//
//  Created by dillion on 11/25/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class Dynamic<T> : Equatable {
    var value: T {
        didSet {
            for bondBox in bonds {
                bondBox.bond?.listener?(value)
            }
        }
    }
    
    var bonds: [BondBox<T>] = []
    
    init(_ v: T) {
        value = v
    }
    
    static func == (left : Dynamic<T>, right : Dynamic<T>) -> Bool {
        if let l = left.value as? Task, let r = right.value as? Task {
            return l == r
        }
        if let l = left.value as? Category, let r = right.value as? Category {
            return l == r
        }
        return false
    }
    
    class func wrapArray(array : [T]) -> [Dynamic<T>] {
        var toReturn = [Dynamic<T>]()
        for item in array {
            toReturn.append(Dynamic(item))
        }
        return toReturn
    }
    
    class func unwrapArray(array : [Dynamic<T>]) -> [T] {
        var toReturn = [T]()
        for item in array {
            toReturn.append(item.value)
        }
        return toReturn
    }
}
