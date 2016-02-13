//
//  MagazineTableViewController.swift
//  publsh
//
//  Created by Itai Wiseman on 1/30/16.
//  Copyright © 2016 iws. All rights reserved.
//

import UIKit

class MagazineTableViewController: UITableViewController {
    
//    var magazine: PFObject?
//    
//    var user = PFUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 70.0
        
        //navigation
        self.view.backgroundColor = Style.viewBackgroundColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationItem.title = magazine!.objectForKey("name") as? String
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Style.textColorWhite]
        
        //loadUser()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("magazineHeaderCell", forIndexPath: indexPath) as! MagazineIntroductionCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.contentView.backgroundColor = Style.strongCellBackgroundColor
            
            cell.collectedByLabel.textColor = Style.textLightColor
            
            setUserProfileImage(cell)
            cell.userProfileImage.layer.cornerRadius = cell.userProfileImage.frame.size.width / 2;
            cell.userProfileImage.clipsToBounds = true
            cell.userProfileImage.layer.borderWidth = 1
            
            cell.username.setTitleColor(Style.textColorWhite, forState: UIControlState.Normal)
//            cell.username.setTitle(user.objectForKey("name") as? String, forState: UIControlState.Normal)
            
//            cell.magazineDescription.text = magazine!.objectForKey("description") as? String
            cell.magazineDescription.textColor = Style.textLightColor
            cell.magazineDescription.lineBreakMode = .ByWordWrapping
            
            
            
            
            return cell
        }else{
            let cell =  UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "articleDetails")
            return cell
        }
        
        
        
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if indexPath.row == 0{
//            return UITableViewAutomaticDimension
//        }
//                    let screenWidth = tableView.frame.size.width
//                   if indexPath.row == 0 {
//        
//                    if indexPath.section % 3 == 0{
//                           return screenWidth * 0.75
//                       }
//                        return screenWidth
//                    }
//                    return screenWidth
        
        return 70.0
    }
    
    func setUserProfileImage(cell: MagazineIntroductionCell){
        //get user image
        
//        let userImageFile: PFFile = (user.objectForKey("image"))! as! PFFile
//        
//        userImageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
//            if(error == nil){
//                cell.userProfileImage.image =  UIImage(data: data!)
//            }
//        }
    }
    
    
//    func loadUser(){
//        let userQuery = PFUser.query()
//        userQuery?.whereKey("objectId", equalTo: magazine!.objectForKey("createdBy")!)
//        
//        do{
//              user = try userQuery?.findObjects()[0] as! PFUser
//        }catch{
//            print("cant load user")
//        }
//    }
    
    
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showUserProfile"{
            //let destinationVC = segue.destinationViewController as! ProfileTableViewController
            //destinationVC.user = self.user
        }

    }
    
    
}
