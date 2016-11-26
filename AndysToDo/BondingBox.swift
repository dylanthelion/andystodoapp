//
//  BondingBox.swift
//  AndysToDo
//
//  Created by dillion on 11/25/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class BondBox<T> {
    
    weak var bond: Bond<T>?
    
    init(_ b: Bond<T>) {
        bond = b
    }
    
}
