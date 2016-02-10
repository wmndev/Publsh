//
//  ViewController.swift
//  publsh
//
//  Created by Itai Wiseman on 12/15/15.
//  Copyright © 2015 iws. All rights reserved.
//

import UIKit


class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet var facebookLoginButton: FBSDKLoginButton!
    let permissions = ["public_profile"]
    
    //    @IBAction func connectWithFacebook(sender: AnyObject) {
    //        if PFUser.currentUser() != nil{
    //            self.performSegueWithIdentifier("afterSignup", sender: self)
    //        }else{
    //            PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) { (user, error) -> Void in
    //                if error != nil{
    //                    print(error)
    //                }
    //                if user == nil{
    //                    print("fuck!")
    //                }else{
    //                    if ((user?.isNew ) != nil){
    //                        self.createFreshUser(user!)
    //                    }
    //                    self.loadData()
    //                    self.performSegueWithIdentifier("afterSignup", sender: self)
    //
    //                }
    //
    //
    //            }
    //        }
    //
    //    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            self.performSegueWithIdentifier("afterSignup", sender: self)
            print("segued due to login")
        }else{
            facebookLoginButton.readPermissions = ["public_profile"]
            facebookLoginButton.delegate = self
        }
        
        //        if PFUser.currentUser() != nil{
        //            self.performSegueWithIdentifier("afterSignup", sender: self)
        //        }
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("logout")
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        self.performSegueWithIdentifier("afterSignup", sender: self)
        print("segued due to login")
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createFreshUser(user: PFUser){
        let userStats = PFObject(className:"UserStats")
        userStats["userId"] = user.objectId
        userStats["numOfFollowers"] = 0
        userStats["numOfFollowing"] = 0
        userStats["numOfMagazines"] = 0
        userStats["numOfActivityActions"] = 0
        do{
            try userStats.save()
        }catch{print("issue with saving to user stats")}
    }
    
//    override func viewWillAppear(animated: Bool) {
//        self.loadData()
//    }
    
    
    func loadData(){
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender"])
        graphRequest.startWithCompletionHandler( {
            
            (connection, result, error) -> Void in
            
            if error != nil {
                
                print(error)
                
            } else if let result = result {
                
                print(result)
                
                //                PFUser.currentUser()?["gender"] = result["gender"]
                //                PFUser.currentUser()?["name"] = result["name"]
                //                PFUser.currentUser()?["facebookId"] = result["id"]
                //
                //
                //                do{
                //                    try PFUser.currentUser()?.save()
                //                }catch{
                //                    print("error")
                //                }
                //
                //
                //                let userId = result["id"] as! String
                //
                //                let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                //
                //                if let fbpicUrl = NSURL(string: facebookProfilePictureUrl) {
                //
                //                    if let data = NSData(contentsOfURL: fbpicUrl) {
                //
                //                        //self.userImage.image = UIImage(data: data)
                //
                //                        let imageFile:PFFile = PFFile(data: data)!
                //                        
                //                        PFUser.currentUser()?["image"] = imageFile
                //                        
                //                        do{
                //                            try PFUser.currentUser()?.save()
                //                        }catch{print("error2")}
                //                        
                //                    }
                //                    
                //                }
                
            }
            
        })
    }
    
    
}

