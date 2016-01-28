//
//  InitialMagazineSelectionView.swift
//  publsh
//
//  Created by Itai Wiseman on 1/13/16.
//  Copyright © 2016 iws. All rights reserved.
//

import UIKit

class InitialMagazineSelectionView: UITableViewController {
    
    var magazines = [PFObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigation
        self.view.backgroundColor = Style.detailsCellBackground
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = "DISCOVER MAGAZINES"
        
        
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.view.addSubview(activityIndicator)
        activityIndicator.frame = self.view.bounds
        activityIndicator.startAnimating()
        
        var query = PFQuery(className:"Magazine")
        query.findObjectsInBackgroundWithBlock { (data, error) -> Void in
            if error == nil {
                if let results = data {
                    self.magazines = results
                    activityIndicator.stopAnimating()
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return magazines.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 60
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.row == 0 {
            let screenWidth = tableView.frame.size.width
            if indexPath.section % 3 == 0{
                return screenWidth * 0.75
            }
            return screenWidth
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 1{
            return UITableViewAutomaticDimension
        }
        let screenWidth = tableView.frame.size.width
        if indexPath.row == 0 {
            
            if indexPath.section % 3 == 0{
                return screenWidth * 0.75
            }
            return screenWidth
        }
        return screenWidth
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuseID = indexPath.row == 0 ? "magazineImages" : "magazineFooter"
        
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier(reuseID, forIndexPath: indexPath) as! MagazineIntroCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier(reuseID, forIndexPath: indexPath) as! MagazineIntroDetails
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "glasses_filled.png")
            let attachmentString = NSAttributedString(attachment: attachment)
            
            
            let myString = NSMutableAttributedString(string: String(magazines[indexPath.section]["numOfFolloweres"] as! Int) + " readers ")
            myString.appendAttributedString(attachmentString)
            
            
            cell.readersButton.setAttributedTitle(myString, forState: .Normal)
            
            cell.username.setTitle(magazines[indexPath.section]["createdBy"] as? String , forState: UIControlState.Normal)
            
            //cell.username.titleLabel!.text = magazines[indexPath.section]["createdBy"] as? String
            
            cell.magazineDescription.text = "When you use iTunes to update or restore iOS on your iPhone, iPad, or iPod touch, you might see an error code or alert message. Most of these errors happen because your computer has older versions of software or can’t connect to the server."
            
            return cell
            
        }
        
        
        //set Image
        
        
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("sectionHeader") as! CostumHeaderCell
        
        headerCell.backgroundColor = Style.header.sectionHeaderBackgroundColor
        
        headerCell.userName.text = magazines[section]["name"] as? String
        headerCell.layer.cornerRadius = 2
        headerCell.followButton.layer.borderWidth = 1
        headerCell.followButton.layer.cornerRadius = 2
        
        headerCell.followButton.clipsToBounds = true
        
        headerCell.followButton.setTitleColor(Style.controller.buttonsNotSelectedColor, forState: UIControlState.Normal)
        headerCell.followButton.layer.borderColor = Style.controller.buttonsNotSelectedBorderColor.CGColor
        
        headerCell.cellImage.layer.cornerRadius = headerCell.cellImage.frame.size.width / 2;
        headerCell.cellImage.clipsToBounds = true
        headerCell.cellImage.layer.borderWidth = 1
        headerCell.cellImage.layer.borderColor = UIColor.whiteColor().CGColor;
        
        return headerCell
        
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toUserProfile"{
            let button = sender as! UIButton
            
            let userId = button.titleLabel?.text
            
            let destinationVC = segue.destinationViewController as! ProfileTableViewController
            destinationVC.userId = userId!
            
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
