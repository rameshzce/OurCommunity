//
//  ViewController.swift
//  OurCommunity
//
//  Created by Ramesh Kolamala on 12/04/17.
//  Copyright © 2017 tokkalo.com. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    
    // [START viewcontroller_vars]
    //@IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signOutButton: UIButton!
    // [END viewcontroller_vars]
    @IBOutlet var signInButton: UIButton!
    @IBAction func signInBtn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
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
        
        let btnSize : CGFloat = 100
        signInButton = UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
        //signInButton.center = view.center
        signInButton.setImage(UIImage(named: "google_signin_button.png"), for: UIControlState.normal)
        signInButton.addTarget(self, action: #selector(signInBtn), for: UIControlEvents.touchUpInside)
        
        //Circular button
        //signInButton.layer.cornerRadius = btnSize/2
        signInButton.layer.masksToBounds = true
        signInButton.layer.borderColor = UIColor.black.cgColor
        signInButton.layer.borderWidth = 2
        view.addSubview(signInButton)
        
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        // TODO(developer) Configure the sign-in button look/feel
        // [START_EXCLUDE]
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ViewController.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
        
        toggleAuthUI()
        // [END_EXCLUDE]
        
        
        
        
        
        
    }
    
    // [START signout_tapped]
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        // [START_EXCLUDE silent]
        print("Signed out.")
        toggleAuthUI()
        // [END_EXCLUDE]
    }

    func toggleAuthUI() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            // Signed in
            signInButton.isHidden = true
            signOutButton.isHidden = false
        } else {
            signInButton.isHidden = false
            signOutButton.isHidden = true
        }
    }
    // [END toggle_auth]
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                                  object: nil)
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            self.toggleAuthUI()
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
                //self.statusText.text = userInfo["statusText"]!
            }
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
                            
                            print(error?.localizedDescription)
                            
                        } else {
                            
                            if let userDetails = result as? [String: String] {
                                
                                print(userDetails["email"]!)
                                
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



