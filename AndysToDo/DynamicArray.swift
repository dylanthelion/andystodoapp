//
//  DynamicArray.swift
//  AndysToDo
//
//  Created by dillion on 11/26/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class DynamicArray<T> : Dynamic<T> {
    
    override var value: T {
        didSet {
            for bondBox in bonds {
                print("Update")
                bondBox.bond?.listener?(value)
            }
        }
    }
}
