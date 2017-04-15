//
//  UserViewController.swift
//  OurCommunity
//
//  Created by Ramesh Kolamala on 15/04/17.
//  Copyright © 2017 tokkalo.com. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    @IBOutlet var userImage: UIImageView!
    

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
