//
//  UserAccount.swift
//  AndysToDo
//
//  Created by dillion on 10/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation


class UserAccount {
    
    var name : String?
    var ID : String?
    var FB_Email : String?
    var FB_ID : String?
    var FB_UserName : String?
    var FB_Token : String?
    var google_Email : String?
    var google_ID : String?
    var google_UserName : String?
    var google_Token : String?
    
    init(name : String?, id : String?) {
        self.name = name
        ID = id
    }
    
    func handleFacebookLogin(email : String, id : String?, name : String?, token: String) {
        FB_Email = email
        FB_ID = id
        FB_UserName = name
        FB_Token = token
    }
    
    func handleGoogleLogin(email : String, id : String?, name : String?, token: String) {
        google_Email = email
        google_ID = id
        google_UserName = name
        google_Token = token
    }
    
    func isValid() -> Bool {
        /// No validation, currently
        return true
    }
    
    func isLoggedIn() -> Bool {
        return isValid() && ((FB_Token != nil && FB_Email != nil) || (google_Token != nil && google_Email != nil))
    }
}
