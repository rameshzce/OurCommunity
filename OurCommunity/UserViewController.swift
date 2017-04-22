//
//  UserViewController.swift
//  OurCommunity
//
//  Created by Ramesh Kolamala on 15/04/17.
//  Copyright © 2017 tokkalo.com. All rights reserved.
//

import UIKit
import SCLAlertView
import FBSDKLoginKit

class UserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var userImage: UIImageView!
    
    var communities = [UIImage(named: "flag1"), UIImage(named: "flag2"), UIImage(named: "flag3"), UIImage(named: "flag4")]
    
    @IBOutlet var userGreeting: UILabel!
    
    var textfield1: UITextField!
    var textView: UITextView!
    
    let alert = SCLAlertView()
    
    let userEmail = UserDefaults.standard.object(forKey: "userEmail")!

    let icon = UIImage(named:"logo.png")
    let color = UIColor.red
    let color2 = Helper.hexStringToUIColor("#006400")
    
    let apiUrl = "http://www.tokkalo.com/api/oc/create_community.php"
    
    
    @IBAction func createCommunity(_ sender: UIButton) {
        
        
        let subview = UIView(frame: CGRect(x: 0,y: 0,width: 216,height: 160))
        let x = (subview.frame.width - 180) / 2
        
        // Add textfield 1
        textfield1 = UITextField(frame: CGRect(x: x,y: 10,width: 180,height: 40))
        textfield1.layer.borderColor = UIColor.lightGray.cgColor
        textfield1.layer.borderWidth = 1.5
        textfield1.layer.cornerRadius = 5
        textfield1.placeholder = "Community name"
        textfield1.textAlignment = NSTextAlignment.center
        subview.addSubview(textfield1)
        
        // Add textview 1
        textView = UITextView(frame: CGRect(x: x,y: 60,width: 180,height: 100))
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.5
        textView.layer.cornerRadius = 5
        textView.text = "Description"
        textView.textAlignment = NSTextAlignment.center
        subview.addSubview(textView)
        
        alert.customSubview = subview
        
        _ = alert.addButton("Create", backgroundColor: color2, target:self, selector:#selector(self.checkAndCreateCommunity))
        _ = alert.showCustom("Our New Community", subTitle: "", color: color, icon: icon!, closeButtonTitle:"Cancel")

    }
    
    func checkAndCreateCommunity() {
        let cName = textfield1.text
        let cDesc = textView.text
        
        var paramString: String
        
        paramString = "name=\(cName!)&description=\(cDesc!)&email=\(UserDefaults.standard.object(forKey: "userEmail")!)"
        
        
        //result = Helper.data_request(apiUrl, paramString)!
        
        let url:NSURL = NSURL(string: apiUrl)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        
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
                let result = Helper.convertToDictionary(dataString as String)
                print(result!)
                
                UserDefaults.standard.set(cName!, forKey: "communityName")
                UserDefaults.standard.synchronize()
                
                self.performSegue(withIdentifier: "viewCommunity", sender: nil)
            }
            
        }
        
        task.resume()
        
    }

    @IBAction func btnSignOut(_ sender: Any) {
        if  (UserDefaults.standard.object(forKey: "userEmail") as?  String) != nil  {
            UserDefaults.standard.set(nil, forKey: "userEmail")
            UserDefaults.standard.synchronize()
        }
        
        GIDSignIn.sharedInstance().signOut()
        
        FBSDKLoginManager().logOut()

        self.performSegue(withIdentifier: "signOut", sender: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2;
        self.userImage.clipsToBounds = true
        
        self.userImage.layer.borderWidth = 5.0
        self.userImage.layer.borderColor = Helper.hexStringToUIColor("#C4C4C4").cgColor
        
        //Helper.loadImageFromUrl(profilePicture, userImage)
        Helper.loadImageFromUrl(UserDefaults.standard.object(forKey: "profilePic") as! String, userImage)
        
        self.userGreeting.text = "Welcome \(String(describing: UserDefaults.standard.object(forKey: "userName")!))"
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return communities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "communityCell", for: indexPath) as! CommunitiesCollectionViewCell
        
        cell.imageView.image = communities[indexPath.row]
        
        return cell
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
