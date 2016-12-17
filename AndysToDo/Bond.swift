//
//  Bond.swift
//  AndysToDo
//
//  Created by dillion on 11/25/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class Bond<T> {
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    init(_ listener: @escaping Listener) {
        self.listener = listener
    }
    
    func bind(dynamic: Dynamic<T>) {
        dynamic.bonds.append(BondBox(self))
    }
}
