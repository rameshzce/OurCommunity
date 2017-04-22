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

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
    // [START viewcontroller_vars]
    //@IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    let apiUrl = "http://www.tokkalo.com/api/oc/create_user.php"

    func signInBtn() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBOutlet var btnFBSignIn: FBSDKLoginButton!
    
    @IBOutlet var btnGSignIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  let user = UserDefaults.standard.object(forKey: "userEmail") as?  String  {
            print("User : \(user)")
            self.performSegue(withIdentifier: "userSegue", sender: nil)
        }

        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        if (FBSDKAccessToken.current() != nil)
        {
            
            print("User Logged In")
            self.performSegue(withIdentifier: "userSegue", sender: nil)
            
        }
        else
        {
           // let loginButton : FBSDKLoginButton = FBSDKLoginButton()
            
            //loginButton.center = self.view.center
            
            btnFBSignIn.readPermissions = ["public_profile", "email"]
            
            btnFBSignIn.delegate = self
            
            //self.view.addSubview(loginButton)
        }
        
        //btnGSignIn.setImage(UIImage(named: "google_signin_btn1.png"), for: UIControlState.normal)
        btnGSignIn.addTarget(self, action: #selector(signInBtn), for: UIControlEvents.touchUpInside)
        btnGSignIn.layer.cornerRadius = 2
        btnGSignIn.clipsToBounds = true
        
        
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
    
    // [START signin_handler]
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        
        if let error = error {
            print("error: \(error.localizedDescription)")
            // [START_EXCLUDE silent]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            // [END_EXCLUDE]
        } else {
            // Perform any operations on signed in user here.
            _ = user.userID                  // For client-side use only!
            
            _ = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            _ = user.profile.givenName
            _ = user.profile.familyName
            _ = user.profile.email
            // [START_EXCLUDE]
            UserDefaults.standard.set(user.profile.email, forKey: "userEmail")
            UserDefaults.standard.set(fullName, forKey: "userName")
            print("Userid: \(String(describing: fullName!))")
            if user.profile.hasImage
            {
                let pic = user.profile.imageURL(withDimension: 100)
                var pic2: String
                pic2 = (pic?.absoluteString)!
                UserDefaults.standard.set(pic2, forKey: "profilePic")
                
                
                //print(pic!)
            }
            UserDefaults.standard.synchronize()
            
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                object: nil,
                userInfo: ["statusText": "Signed:\(String(describing: fullName!))"])
            // [END_EXCLUDE]
            
            if let token = UserDefaults.standard.object(forKey: "deviceToken") as? String{
                self.registerUpdateUser(token, user.profile.email, user.profile.name)
            }
            
            self.performSegue(withIdentifier: "userSegue", sender: nil)
        }
    }
    // [END signin_handler]
    // [START disconnect_handler]
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }
    // [END disconnect_handler]
    
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
                        print(result!)
                        if error != nil {
                            print("error")
                            print(error?.localizedDescription)
                            
                        } else {
                            
                            if let userDetails = result as? [String: String] {
                                print(userDetails)
                                
                                print("Email\n\n\n\n")
                                print(userDetails["name"]!)
                                /*print(userDetails["name"]!)
                                print(userDetails["picture"]!)
                                print(userDetails["first_name"]!)
                                print(userDetails["last_name"]!)*/
                                UserDefaults.standard.set(userDetails["email"]!, forKey: "userEmail")
                                UserDefaults.standard.set(userDetails["name"]!, forKey: "userName")
                                
                            }else{
                                print("tokka")
                            }
                            
                            let pic2: String = ((((result as AnyObject).object(forKey: "picture") as AnyObject).object(forKey: "data") as AnyObject).object(forKey: "url") as? String)!
                            //print(pic2)
                            
                            let name: String = ((result as AnyObject).object(forKey: "name") as? String)!
                            let email: String = ((result as AnyObject).object(forKey: "email") as? String)!
                            
                            UserDefaults.standard.set(email, forKey: "userEmail")
                            UserDefaults.standard.set(name, forKey: "userName")
                            
                            UserDefaults.standard.set(pic2, forKey: "profilePic")
                            
                            UserDefaults.standard.synchronize()
                            
                            if let token = UserDefaults.standard.object(forKey: "deviceToken") as? String{
                                self.registerUpdateUser(token, email, name)
                            }
                            
                            
                            
                            self.performSegue(withIdentifier: "userSegue", sender: nil)
                            
                        }
                        
                        
                    })
                    
                    
                }
                
                
                
            }
        }
    }
    
    func registerUpdateUser(_ token: String, _ email: String, _ name: String){
        let url:NSURL = NSURL(string: self.apiUrl)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        
        let paramString = "os_type=iOS&token=" + token + "&email=" + email + "&name=" + name
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            
            guard let _:NSData = data as NSData?, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            
            if let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            {
                print(dataString)
                let result = Helper.convertToDictionary(dataString as String)
                print(result)
            }
        }
        
        task.resume()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        print("Logged out")
        
    }
    
    
}



