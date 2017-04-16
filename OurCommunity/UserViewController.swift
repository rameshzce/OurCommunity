//
//  UserViewController.swift
//  OurCommunity
//
//  Created by Ramesh Kolamala on 15/04/17.
//  Copyright © 2017 tokkalo.com. All rights reserved.
//

import UIKit
import SCLAlertView

class UserViewController: UIViewController {
    @IBOutlet var userImage: UIImageView!
    
    
    var textfield1: UITextField!
    var textfield2: UITextView!
    
    let profilePicture = "https://lh5.googleusercontent.com/-LVhc7szsUq0/AAAAAAAAAAI/AAAAAAAAAAA/AMcAYi8Q6nEL0D0DHI03VOozdcxdQhZkcQ/s100/photo.jpg"
    
    
    
    @IBAction func createCommunity(_ sender: UIButton) {
        // Create custom Appearance Configuration
        /*let appearance = SCLAlertView.SCLAppearance(kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!, kTextFont: UIFont(name: "HelveticaNeue", size: 20)!, kButtonFont: UIFont(name: "HelveticaNeue", size: 20)!, showCloseButton: false, showCircularIcon: true)
        
        
       
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        
        let icon = UIImage(named:"logo.png")
        let color = UIColor.red

        
        // Creat the subview
        let subview = UIView(frame: CGRect(x: 0,y: 0,width: 216,height: 150))
        let x = (subview.frame.width - 180) / 2
        
        // Add textfield 1
         textfield1 = UITextField(frame: CGRect(x: x,y: 10,width: 180,height: 25))
        textfield1.layer.borderColor = UIColor.green.cgColor
        textfield1.layer.borderWidth = 1.5
        textfield1.layer.cornerRadius = 5
        textfield1.placeholder = "Username"
        textfield1.textAlignment = NSTextAlignment.center
        subview.addSubview(textfield1)
        
        // Add textfield 2
        let textfield2 = UITextView(frame: CGRect(x: x,y: textfield1.frame.maxY + 10,width: 180,height: 100))
        textfield2.isSecureTextEntry = true
        textfield2.layer.borderColor = UIColor.blue.cgColor
        textfield2.layer.borderWidth = 1.5
        textfield2.layer.cornerRadius = 5
        textfield1.layer.borderColor = UIColor.blue.cgColor
        //textfield2.placeholder = "Password"
        textfield2.textAlignment = NSTextAlignment.center
        subview.addSubview(textfield2)
        
        // Add the subview to the alert's UI property
        //alert.customSubview = subview
        //_ = alert.addButton("Login", backgroundColor: color, target:self, selector:#selector(checkAndCreateCommunity))
        
        _ = alert.showCustom("Create new community", subTitle: "Create a new community", color: color, icon: icon!, closeButtonTitle:"No")*/
        
        let alert = SCLAlertView()
        
        let icon = UIImage(named:"logo.png")
        let color = UIColor.red
        let color2 = Helper.hexStringToUIColor("#006400")
        
        let subview = UIView(frame: CGRect(x: 0,y: 0,width: 216,height: 150))
        let x = (subview.frame.width - 180) / 2
        
        // Add textfield 1
        textfield1 = UITextField(frame: CGRect(x: x,y: 10,width: 180,height: 25))
        textfield1.layer.borderColor = UIColor.green.cgColor
        textfield1.layer.borderWidth = 1.5
        textfield1.layer.cornerRadius = 5
        textfield1.placeholder = "Username"
        textfield1.textAlignment = NSTextAlignment.center
        subview.addSubview(textfield1)
        
        alert.customSubview = subview
        
        _ = alert.addButton("Create", backgroundColor: color2, target:self, selector:#selector(self.checkAndCreateCommunity))
        _ = alert.showCustom("Our Community", subTitle: "Are you sure to delete?", color: color, icon: icon!, closeButtonTitle:"No")

    }
    
    func checkAndCreateCommunity() {
        print(textfield1.text!)
    }

    @IBAction func btnSignOut(_ sender: Any) {
        //GIDSignIn.sharedInstance().signOut()
        //self.performSegue(withIdentifier: "signOut", sender: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2;
        self.userImage.clipsToBounds = true
        
        self.userImage.layer.borderWidth = 5.0
        self.userImage.layer.borderColor = Helper.hexStringToUIColor("#C4C4C4").cgColor
        
        //Helper.loadImageFromUrl(profilePicture, userImage)
        Helper.loadImageFromUrl(UserDefaults.standard.object(forKey: "profilePic") as! String, userImage)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
