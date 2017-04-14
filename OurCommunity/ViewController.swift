//
//  ViewController.swift
//  OurCommunity
//
//  Created by Ramesh Kolamala on 12/04/17.
//  Copyright © 2017 tokkalo.com. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
        if (FBSDKAccessToken.current() != nil)
        {
            
            print("User Logged In")
            
        }
        else
        {
            let loginButton : FBSDKLoginButton = FBSDKLoginButton()
            
            loginButton.center = self.view.center
            
            loginButton.readPermissions = ["public_profile", "email"]
            
            loginButton.delegate = self
            
            self.view.addSubview(loginButton)
        }
        
        
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil
        {
            
            print(error)
            
        }
        else if result.isCancelled {
            
            print("User cancelled login")
            
        }
        else {
            
            
            if result.grantedPermissions.contains("email")
            {
                
                if let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"]) {
                    
                    graphRequest.start(completionHandler: { (connection, result, error) in
                        
                        if error != nil {
                            
                            print(error)
                            
                        } else {
                            
                            if let userDetails = result as? [String: String] {
                                
                                print(userDetails["email"])
                                
                            }
                            
                        }
                        
                        
                    })
                    
                    
                }
                
                
                
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        print("Logged out")
        
    }
    
    
}



