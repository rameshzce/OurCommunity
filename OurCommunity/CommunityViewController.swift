//
//  CommunityViewController.swift
//  OurCommunity
//
//  Created by Ramesh Kolamala on 22/04/17.
//  Copyright © 2017 tokkalo.com. All rights reserved.
//

import UIKit

class CommunityViewController: UIViewController {
    @IBOutlet var communityName: UILabel!
    
    var cName: String = ""
    
    @IBAction func goHome(_ sender: Any) {
        self.performSegue(withIdentifier: "goHome", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.communityName.text = UserDefaults.standard.object(forKey: "communityName") as? String
        self.communityName.text = self.cName

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
