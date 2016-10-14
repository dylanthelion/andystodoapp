//
//  LoginHelper.swift
//  AndysToDo
//
//  Created by dillion on 10/14/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

private let loginProperties = LoginHelper()

class LoginHelper {
    
    var loginProvider : LoginProvider?
    
    class var sharedLogin : LoginHelper {
        return loginProperties
    }
    
    func setLoginProvider(provider : LoginProvider) {
        loginProvider = provider
    }
}

enum LoginProvider {
    case Facebook
    case Google
}
