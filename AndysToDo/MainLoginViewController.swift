//
//  MainLoginViewController.swift
//  AndysToDo
//
//  Created by dillion on 10/13/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class MainLoginViewController : UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        loginButton.delegate = self
        loginButton.readPermissions = ["email"]
        handleLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handleLogin()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func handleLogin() {
        if((FBSDKAccessToken.current()) != nil) {
            //print("HERP token")
            if(FBSDKAccessToken.current().hasGranted("email")) {
                //print("HERP email")
                let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: FBSDKAccessToken.current().tokenString, version: nil, httpMethod: "GET")
                req?.start(completionHandler: { [weak self] connection, result, error in
                    if(error != nil)
                    {
                        print("result \(result)")
                    }
                    else
                    {
                        print("error \(error)")
                    }
                    })
            } else {
                //print("HERP Email not granted")
            }
        } else {
            //print("HERP no token")
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if(error == nil)
        {
            //print("HERP login complete")
            //print(result.grantedPermissions)
        }
        else{
            //print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //print("HERP Logged out")
    }
}
