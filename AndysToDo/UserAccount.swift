//
//  UserAccount.swift
//  AndysToDo
//
//  Created by dillion on 10/16/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation


class UserAccount {
    
    var Name : String?
    var ID : String?
    var FB_Email : String?
    var FB_ID : String?
    var FB_UserName : String?
    var FB_Token : String?
    var Google_Email : String?
    var Google_ID : String?
    var Google_UserName : String?
    var Google_Token : String?
    
    init(_name : String?, _id : String?) {
        Name = _name
        ID = _id
    }
    
    func handleFacebookLogin(_email : String, _id : String?, _name : String?, _token: String) {
        FB_Email = _email
        FB_ID = _id
        FB_UserName = _name
        FB_Token = _token
    }
    
    func handleGoogleLogin(_email : String, _id : String?, _name : String?, _token: String) {
        Google_Email = _email
        Google_ID = _id
        Google_UserName = _name
        Google_Token = _token
    }
    
    func isValid() -> Bool {
        /// No validation, currently
        return true
    }
    
    func isLoggedIn() -> Bool {
        return isValid() && ((FB_Token != nil && FB_Email != nil) || (Google_Token != nil && Google_Email != nil))
    }
}
