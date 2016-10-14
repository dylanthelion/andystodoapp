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
import GoogleSignIn

class MainLoginViewController : UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
    var loginButton: FBSDKLoginButton?
    var GoogleLoginButton: GIDSignInButton?
    
    let btnWidth : CGFloat = 82.0
    let btnHeight : CGFloat = 30.0
    var viewWidth : CGFloat?
    var viewHeight : CGFloat?
    
    override func viewDidLoad() {
        viewWidth = self.view.frame.width
        viewHeight = self.view.frame.height
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
        addLoginButtons()
        loginButton?.delegate = self
        loginButton?.readPermissions = ["email"]
        handleLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handleLogin()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func addLoginButtons() {
        let x_coord : CGFloat = (viewWidth! / 2.0) - (btnWidth / 2.0)
        let fb_y_coord : CGFloat = (viewHeight! / 2.0) - (btnHeight + 10.0)
        let google_y_coord : CGFloat = (viewHeight! / 2.0) + 10.0
        loginButton = FBSDKLoginButton(frame: CGRect(x: x_coord, y: fb_y_coord, width: btnWidth, height: btnHeight))
        GoogleLoginButton = GIDSignInButton(frame: CGRect(x: x_coord, y: google_y_coord, width: btnWidth, height: btnHeight))
        self.view.addSubview(loginButton!)
        self.view.addSubview(GoogleLoginButton!)
        
    }
    
    func handleLogin() {
        if((FBSDKAccessToken.current()) != nil) {
            //print("HERP token")
            if(FBSDKAccessToken.current().hasGranted("email")) {
                //print("HERP email")
                let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: FBSDKAccessToken.current().tokenString, version: nil, httpMethod: "GET")
                req?.start(completionHandler: { [weak self] connection, result, error in
                    if(error == nil)
                    {
                        print("result \(result)")
                    }
                    else
                    {
                        //print("HERP error \(error?.localizedDescription)")
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
        /*if(error == nil)
        {
            print("HERP login complete")
            print(result.grantedPermissions)
        }
        else{
            print(error.localizedDescription)
        }*/
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //print("HERP Logged out")
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if(error != nil) {
            print("Error: \(error.localizedDescription)")
        }
        /*if user == nil {
            print("HERP nil")
        }*/
        print("User: \(user.userID) \n \(user.profile.email) \n \(user.profile.name)")
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}
