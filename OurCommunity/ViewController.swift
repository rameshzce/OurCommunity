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

    func signInBtn() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBOutlet var btnFBSignIn: FBSDKLoginButton!
    
    @IBOutlet var btnGSignIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        if (FBSDKAccessToken.current() != nil)
        {
            
            print("User Logged In")
            
        }
        else
        {
           // let loginButton : FBSDKLoginButton = FBSDKLoginButton()
            
            //loginButton.center = self.view.center
            
            btnFBSignIn.readPermissions = ["public_profile", "email"]
            
            btnFBSignIn.delegate = self
            
            //self.view.addSubview(loginButton)
        }
        
        //btnGSignIn.setImage(UIImage(named: "google_logo.png"), for: UIControlState.normal)
        btnGSignIn.addTarget(self, action: #selector(signInBtn), for: UIControlEvents.touchUpInside)
        
        
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
            btnGSignIn.isHidden = true
            signOutButton.isHidden = false
        } else {
            btnGSignIn.isHidden = false
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
            print(result)
            
            if result.grantedPermissions.contains("email")
            {
                
                if let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name, picture.type(large)"]) {
                    
                    graphRequest.start(completionHandler: { (connection, result, error) in
                        
                        if error != nil {
                            print("error")
                            print(error?.localizedDescription)
                            
                        } else {
                            
                            if let userDetails = result as? [String: String] {
                                
                                print(userDetails["email"]!)
                                /*print(userDetails["name"]!)
                                print(userDetails["picture"]!)
                                print(userDetails["first_name"]!)
                                print(userDetails["last_name"]!)*/
                                
                            }
                            
                            let pic2: String = ((((result as AnyObject).object(forKey: "picture") as AnyObject).object(forKey: "data") as AnyObject).object(forKey: "url") as? String)!
                            print(pic2)
                            
                            UserDefaults.standard.set(pic2, forKey: "profilePic")
                            UserDefaults.standard.synchronize()
                            
                            self.performSegue(withIdentifier: "userSegue", sender: nil)
                            
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



