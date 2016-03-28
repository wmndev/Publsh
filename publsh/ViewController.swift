//
//  ViewController.swift
//  publsh
//
//  Created by Itai Wiseman on 12/15/15.
//  Copyright © 2015 iws. All rights reserved.
//

import UIKit


class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var facebookLoginButton: FBSDKLoginButton!
    
    var activityIndicator = UIActivityIndicatorView()
        
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
        hideAllControllers()
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.view.addSubview(activityIndicator)
        activityIndicator.frame = self.view.bounds
        activityIndicator.startAnimating()
        
        AmazonClientManager.sharedInstance.fbLogin(self)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func hideAllControllers(){
        titleLbl.hidden = true
        facebookLoginButton.hidden = true
    }
    
    

    
    
}

