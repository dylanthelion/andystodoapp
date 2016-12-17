//
//  HTTPRequestHelper.swift
//  AndysToDo
//
//  Created by dillion on 10/13/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

private let helper = HTTPRequestHelper()

class HTTPRequestHelper {
    
    var delegate : HTTPHelperDelegate?
    
    class var sharedHelper : HTTPRequestHelper {
        return helper
    }
}

protocol HTTPHelperDelegate {
    
}
