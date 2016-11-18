//
//  CollectionHelper.swift
//  AndysToDo
//
//  Created by dillion on 10/21/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class CollectionHelper {
    
    class func IsNilOrEmpty<T: Collection>(_coll : T?) -> Bool {
        if let _ = _coll {
            if(_coll!.count > 0) {
                return false
            }
        }
        return true
    }
}
