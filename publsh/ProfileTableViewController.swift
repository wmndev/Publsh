//
//  ProfileTableViewController.swift
//  publsh
//
//  Created by Itai Wiseman on 1/18/16.
//  Copyright © 2016 iws. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    var userStats = [PFObject]()
    
    var userId = ""
    
    var user =  PFUser()
    
    var source = Types.Sources.NA
    
    var isFollowUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserStats()
        
        tableView.alwaysBounceVertical = false
        
        self.view.backgroundColor = Style.viewBackgroundColor
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    
    func createNavigationButton(){
        let btnName = UIButton()
        
        btnName.frame = CGRectMake(0, 0, 70, 24)
        btnName.titleLabel?.textAlignment = NSTextAlignment.Center
        btnName.titleLabel?.center =  CGPointMake(35,12)
        btnName.setTitle(isFollowUser ? "Unfollow" : "Follow", forState: UIControlState.Normal)
        btnName.layer.borderWidth = 1
        btnName.layer.borderColor = Style.textColorWhite.CGColor
        btnName.layer.cornerRadius = 5
        btnName.titleLabel?.font = UIFont.systemFontOfSize(14)
        btnName.addTarget(self, action: "followTapped", forControlEvents: .TouchUpInside)
        
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadUserStats(){
        let userQuery = PFUser.query()
        userQuery?.whereKey("objectId", equalTo: userId)
        
        do{
            try user = userQuery?.findObjects()[0] as! PFUser
        }catch{
            print("cant load user")
        }
        
        let query = PFQuery(className:"UserStats")
        query.whereKey("userId", equalTo: userId)
        query.findObjectsInBackgroundWithBlock { (data, error) -> Void in
            if error == nil {
                if let results = data {
                    self.userStats.append(results[0])
                    //activityIndicator.stopAnimating()
                }
                self.tableView.reloadData()
            }else{
                
                print(error)
            }
        }
        
        
        let followQuery = PFQuery(className: "followUser")
        followQuery.whereKey("followUserId", equalTo:  (PFUser.currentUser()?.objectId)!)
        followQuery.whereKey("followingUserId", equalTo:  userId)
        followQuery.findObjectsInBackgroundWithBlock { (data, error) -> Void in
            if error == nil{
                if let results = data{
                    self.isFollowUser = results.count > 0
                }
                self.tableView.reloadData()
            }
            self.createNavigationButton()
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.row == 0{
            return 150
        }
        if indexPath.row == 1{
            return 110
        }
        return 80
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("profileHeader", forIndexPath: indexPath) as! ProfileHeaderCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.contentView.backgroundColor = Style.strongCellBackgroundColor
            
            setUserProfileImage(cell)
            cell.userProfileImage.layer.cornerRadius = cell.userProfileImage.frame.size.width / 2;
            cell.userProfileImage.clipsToBounds = true
            cell.userProfileImage.layer.borderWidth = 1
            //cell.userProfileImage.layer.borderColor = Style.pages.userProfile.userProfileImageBorderColor.CGColor
            
            return cell
        }else{
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "detailedLogCell")
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            
            if indexPath.row == 1{
                
                let userName = (PFUser.currentUser()?.objectForKey("name"))! as! String
                let range = userName.rangeOfString(" ")!
                
                cell.textLabel?.text = userName.uppercaseString.stringByReplacingCharactersInRange(range, withString: "\n")
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.textColor = Style.textStrongColor
                cell.textLabel?.font = UIFont.systemFontOfSize(35)
                
                
                
            }else{
                
                
                let activityLabel = UILabel(frame: CGRectMake(0, 0, 60, 60))
                activityLabel.center = CGPointMake(23,23)
                activityLabel.textAlignment = NSTextAlignment.Center
                activityLabel.textColor = Style.textColorWhite
                activityLabel.font = UIFont.systemFontOfSize(23)
                
                
                activityLabel.layer.backgroundColor = Style.controllerColor.CGColor
                
                cell.accessoryView = activityLabel
                cell.accessoryView!.frame = CGRectMake(0, 0, 60, 60)
                
                cell.accessoryView!.layer.cornerRadius = cell.accessoryView!.frame.size.width / 2;
                cell.accessoryView!.clipsToBounds = true
                cell.accessoryView!.layer.borderWidth = 2
                cell.accessoryView!.layer.borderColor = UIColor.whiteColor().CGColor;
                
                if userStats.count > 0{
                    switch(indexPath.row){
                    case 2:
                        activityLabel.text = String(userStats[0].objectForKey("numOfMagazines") as! Int)
                        cell.textLabel?.text = "PUBLISHED MAGAZINES"
                        break
                    case 3:
                        activityLabel.text = String(userStats[0].objectForKey("numOfActivityActions") as! Int)
                        cell.textLabel?.text = "LAST MONTH ACTIVITIES"
                        break
                    case 4:
                        activityLabel.text = String(userStats[0].objectForKey("numOfFollowers") as! Int)
                        cell.textLabel?.text = "PUSBLHERS FOLLOW"
                        break
                    default:
                        break
                    }}
                
                
                cell.textLabel?.font = UIFont.systemFontOfSize(16)
                cell.textLabel?.textColor = Style.textLightColor

                cell.contentView.backgroundColor = Style.viewBackgroundColor
                cell.backgroundColor = Style.viewBackgroundColor
                
                
                
            }
            return cell
        }
    }
    
    func followTapped(){
        if !isFollowUser{
            var followUser = PFObject(className: "followUser", dictionary: ["followUserId": (PFUser.currentUser()?.objectId)!, "followingUserId": userId])
            followUser.saveInBackgroundWithBlock { (ok, error) -> Void in
                if ok{
                    self.isFollowUser = true
                    self.createNavigationButton()
                }else{
                    print(error)
                }
            }
        }else{
            let query = PFQuery(className: "followUser")
            query.whereKey("followUserId", equalTo: (PFUser.currentUser()?.objectId)!)
            query.whereKey("followingUserId", equalTo: userId)
            
            query.findObjectsInBackgroundWithBlock({ (data, error) -> Void in
                if error == nil{
                    if let results = data{
                        for res in results{
                            res.deleteEventually()
                        }
                        self.isFollowUser = false
                    }
                    self.createNavigationButton()
                }
            })
        }
        
    }
    
    
    func setUserProfileImage(cell: ProfileHeaderCell){
        //get user image
        
        let userImageFile: PFFile = (PFUser.currentUser()?.objectForKey("image"))! as! PFFile
        
        userImageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
            if(error == nil){
                cell.userProfileImage.image =  UIImage(data: data!)
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row > 1 {
            
            switch(indexPath.row){
            case 2:
                source = Types.Sources.MAGAZINES
                break
            case 3:
                source = Types.Sources.ACTIVITIES
                break
            case 4:
                source = Types.Sources.FOLLOWERS
                break
            default:
                source = Types.Sources.NA
                break
                
            }
            
            self.performSegueWithIdentifier("profileDDL", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as! UserActivityTableViewController
        destinationVC.userId = userId
        destinationVC.source = source
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    
    
    
}
