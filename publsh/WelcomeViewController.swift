//
//  WelcomeViewController.swift
//  publsh
//
//  Created by Itai Wiseman on 2/28/16.
//  Copyright © 2016 iws. All rights reserved.
//

import UIKit

extension UITextField{
    func setBottomBorder(color:UIColor){
        
        self.borderStyle = UITextBorderStyle.None
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color.CGColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }
    
}



class WelcomeViewController: UIViewController, UITextFieldDelegate {
    
    var wasAnimated = false

    @IBOutlet var welcomeLabel: UILabel!
    
    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var confirmButton: UIButton!
    
    @IBAction func confirmTouched(sender: AnyObject) {
        EZLoadingActivity.show("Calm...", disableUI: true)
        persistUserCtxData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AmazonClientManager.sharedInstance.isConfigured() {
            AmazonClientManager.sharedInstance.resumeSession(self)
        }
        
        view.backgroundColor = Style.textColorWhite
        
        welcomeLabel.textColor = Style.welcomeScreenBackgroundColor
        
        usernameTextField.delegate = self
        usernameTextField.setBottomBorder(Style.textStrongLighterColor)
        usernameTextField.textColor = Style.textLightColor
        usernameTextField.text = "Your awsome username here.."
        usernameTextField.font = UIFont(name: "System", size: 20)
        usernameTextField.hidden = true
        
        confirmButton.backgroundColor = Style.category.green
        confirmButton.hidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (wasAnimated){
            self.welcomeLabel.center.y -= self.welcomeLabel.center.y - 70
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(1.5,  animations: {
            self.welcomeLabel.center.y -= self.welcomeLabel.center.y - 70
            },
        
            completion: {
                (value: Bool) -> Void in
                UIView.animateWithDuration(0.5, animations: {
                    self.usernameTextField.hidden = false
                    self.wasAnimated = true
                })
               
        
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        self.usernameTextField.resignFirstResponder()
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    //MARK - TextField Delegate
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if usernameTextField.text == "" {
            usernameTextField.font = UIFont.systemFontOfSize(25.0)
            usernameTextField.text = "Your awsome username here.."
            usernameTextField.textColor = Style.category.gray
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if usernameTextField.textColor == Style.textLightColor {
            usernameTextField.font = UIFont.systemFontOfSize(35.0)
            usernameTextField.text = ""
            usernameTextField.textColor = Style.textStrongColor
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
        guard let text = textField.text else {
            return true
        }
        let length = text.characters.count
        
        if  let _ = string.rangeOfCharacterFromSet(whitespaceSet) {return false}
        if length > AppConstants.MAXIMUM_USERNAME_LENGTH {return false}
        
        if length >= AppConstants.MINIMUM_USERNAME_LENGTH{
            confirmButton.hidden = false
        }
        
        return true
    }
    
    //MARK -- AWS
    func persistUserCtxData(){
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender, email"])
        graphRequest.startWithCompletionHandler( {
            
            (connection, result, error) -> Void in
            if error != nil {
                print(error)
            
            } else if let result1 = result {
                
                let userId = result["id"]!
                let fbProfileImgUrl = "https://graph.facebook.com/" + userId! + "/picture?type=large"
                if let fbpicUrl = NSURL(string: fbProfileImgUrl) {
                    
                    if let data = NSData(contentsOfURL: fbpicUrl) {
                        
                        //save to dynamoDb
                        let user = User.self()
                        user.fb_id = result1["id"]!
      
                        
                        user.gender = result1["gender"]
                        user.fullName = result1["name"]
                        user.email = result1["email"]
                        user.username = self.usernameTextField.text
                        user.followers = Set<String>()
                        user.followers?.insert("@")
                        user.following = Set<String>()
                        user.following?.insert("@")
                        
                        let statistics : [String : NSNumber] = ["magazines" : 0,
                            "followers" : 0, "following" : 0]
                        
                        user.statistics = statistics
                        
                        let insertValues = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
                        currentUser = user
                        insertValues.save(user) .continueWithBlock({ (task: AWSTask!) -> AnyObject! in
                            if task.error != nil {
                                print("**-> Error: \(task.error)")
                                EZLoadingActivity.hide(success: false, animated: false)
                            }else{
                                currentUser = user
                                
                                //saving into user defaults:
                                let defaults = NSUserDefaults.standardUserDefaults()
                                defaults.setObject(self.usernameTextField.text, forKey: AppConstants.USERNAME_KEY)
                                
                                let imageFile:UIImage = UIImage(data: data)!
                                AWSS3Manager.uploadImage(imageFile, fileIdentity: userId!)
                                EZLoadingActivity.hide(success: true, animated: false)
                                
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.performSegueWithIdentifier("selectMagazines", sender: self)
                                }

                                
                            }
                            return nil
                        })
                    }
                }
            }
            
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
