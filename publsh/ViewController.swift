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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            self.performSegueWithIdentifier("afterSignup", sender: self)
            print("segued due to login")
        }else{
            facebookLoginButton.readPermissions = ["public_profile"]
            facebookLoginButton.delegate = self
        }
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("logout")
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        AmazonClientManager.sharedInstance.fbLogin{
            (task) -> AnyObject? in
            self.performSegueWithIdentifier("afterSignup", sender: self)
            return nil
        }
        
        loadFBUserData()
        
        self.performSegueWithIdentifier("afterSignup", sender: self)
        print("segued due to login")
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadFBUserData(){
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender, email"])
        graphRequest.startWithCompletionHandler( {
            
            (connection, result, error) -> Void in
            
            if error != nil {
                
                print(error)
                
            } else if let result = result {
                
                print(result)
                
                // PFUser.currentUser()?["gender"] = result["gender"]
                // PFUser.currentUser()?["name"] = result["name"]
                // PFUser.currentUser()?["facebookId"] = result["id"]
                
                let userId = result["id"] as! String
                let fbProfileImgUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                if let fbpicUrl = NSURL(string: fbProfileImgUrl) {
                    
                    if let data = NSData(contentsOfURL: fbpicUrl) {
                        
                        //save to dynamoDb
                        let user = User.self()
                        user.fb_id = result["id"] as! String
                        user.id = 2000000
                        user.gender = result["gender"] as? String
                        user.name = result["name"] as! String
                        user.email = result["email"] as? String
                        
                        let statistics : [String : NSNumber] = ["magazines" : 0,
                            "followers" : 0, "following" : 0]
                        
                        user.statistics = statistics
                        
                        let insertValues = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
                        
                        insertValues.save(user) .continueWithBlock({ (task: AWSTask!) -> AnyObject! in
                            if ((task.error) != nil) {
                                print("Failed")
                                print("Error: \(task.error)")
                            }
                            if ((task.result) != nil){
                                print("Something happened")
                            }
                            return nil
                        })
                        
                        let imageFile:UIImage = UIImage(data: data)!
                        AWSS3Manager.uploadImage(imageFile, fileIdentity: userId)
                        
                        
                    }
                    
                }
                
            }
            
        })
    }
    
    
}

