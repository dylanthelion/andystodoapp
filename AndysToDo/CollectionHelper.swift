//
//  CollectionHelper.swift
//  AndysToDo
//
//  Created by dillion on 10/21/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class CollectionHelper {
    
    class func IsNilOrEmpty<T: Collection>(_ coll : T?) -> Bool {
        if let _ = coll {
            if(coll!.count > 0) {
                return false
            }
        }
        return true
    }
    
    class func containsNoChildren(children : [Dynamic<Task>], ofParents : [Dynamic<Task>]) -> Bool {
        for parent in ofParents {
            for child in children {
                if let _ = child.value.parentID {
                    if child.value.parentID! == parent.value.ID! {
                        return false
                    }
                }
            }
        }
        
        return true
    }
}
