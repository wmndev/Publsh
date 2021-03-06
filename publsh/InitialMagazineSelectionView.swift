//
//  InitialMagazineSelectionView.swift
//  publsh
//
//  Created by Itai Wiseman on 1/13/16.
//  Copyright © 2016 iws. All rights reserved.
//

import UIKit

class InitialMagazineSelectionView: UITableViewController {
    
    var magazines = [Magazine]()
    
    var rowIndex = -1;
    
    var activityIndicator = UIActivityIndicatorView()
    
    let cellReuseIdentifier = "cellHeader"
     let sectionReuseIdentifier = "sectionHeader"
    
    @IBOutlet var skipDoneBarButton: UIBarButtonItem!
    
    @IBAction func followersTouched(sender: AnyObject) {
        let btn = sender as! UIButton
        ViewTransitionManager.moveToUserListView(magazines[btn.tag].followers!, view: self, withTitle:"FOLLOWERS")
    }
    @IBAction func donePressed(sender: AnyObject) {
        let viewController:UIViewController = UIStoryboard(name: "App", bundle: nil).instantiateViewControllerWithIdentifier("appInit") as UIViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    
    @IBAction func followBtnTouched(sender: AnyObject) {
        let btn: UIButton = sender as! UIButton
        let isFollowing = currentUser!.following!.contains(magazines[btn.tag].name!)
        
        if !isFollowing{
            magazines[btn.tag].followers?.insert(currentUser!.username!)
            currentUser!.following!.insert(magazines[btn.tag].getHashKeyValue()!)
        }else{
            magazines[btn.tag].followers?.remove(currentUser!.username!)
            currentUser?.following?.remove(magazines[btn.tag].getHashKeyValue()!)
        }
        
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        objectMapper.save(magazines[btn.tag]).continueWithSuccessBlock({ (task: AWSTask!) -> AnyObject! in
            if task.error != nil {
                print("Error: \(task.error)")
            }else{
                objectMapper.save(currentUser)
                dispatch_async(dispatch_get_main_queue()) {
                    if !isFollowing{
                        CraftUtility.craftApprovalFollowBtn(btn)
                    }else{
                        CraftUtility.craftNotFollowingButton(btn, title: "GET")
                    }
                    
                }
            }
            return nil
        })
        
        
    }
    
    @IBAction func usernameTouched(sender: AnyObject) {
        let btn = sender as! UIButton
        let username = btn.titleLabel?.text
        
        ViewTransitionManager.moveToUserView(username!, view: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // register UITableViewCell for reuse
       self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: sectionReuseIdentifier)
        
        self.view.backgroundColor = Style.strongGrayBackgroundColor
        
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.view.addSubview(activityIndicator)
        activityIndicator.frame = self.view.bounds
        
        if AmazonClientManager.sharedInstance.isConfigured() {
            AmazonClientManager.sharedInstance.resumeSession(self)
        }
        
        
        //navigation
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = Style.navigationBarBackgroundColor
        self.navigationItem.title = "DISCOVER MAGAZINES"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Style.textColorWhite]
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    
    func updateTableData() {
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        
        
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 10
        
        dynamoDBObjectMapper.scan(Magazine.self, expression: scanExpression).continueWithBlock { (task) -> AnyObject? in
            if task.error != nil{
                print(task.error)
            }
            if task.exception != nil{
                print(task.exception)
            }
            
            if task.result != nil{
                
                let paginatedOutput = task.result as! AWSDynamoDBPaginatedOutput
                
                self.magazines = paginatedOutput.items as! [Magazine]
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicator.stopAnimating()
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine;
                    self.tableView.reloadData()
                })
                
            }
            
            return nil
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source'
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.row == 0{
            return 20
        }
        if indexPath.row == 1{
        return 332
        }
        return 41
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return magazines.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 15
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let header = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: sectionReuseIdentifier)
        header.backgroundColor = UIColor.clearColor()
        return header
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let idx = indexPath.row
        
        if idx == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
            cell.textLabel?.text = "Recommended for you."
            cell.textLabel?.font = UIFont.systemFontOfSize(14, weight: UIFontWeightMedium)
            cell.textLabel?.textColor = Style.textLightColor
            cell.selectionStyle = .None
            return cell
        }
        if idx == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("magazineCell", forIndexPath: indexPath) as! MagazineIntroCell
            
            cell.mImage!.layer.borderColor = Style.textLightColor.CGColor
            cell.mImage!.clipsToBounds = true
            cell.mImage!.layer.masksToBounds = true
            
            cell.mTitle.text = magazines[indexPath.section].name!
            cell.mTitle.textColor = Style.textStrongColor
            cell.mTitle.font = UIFont.systemFontOfSize(15, weight: UIFontWeightSemibold)
            
            cell.mDesc.text = magazines[indexPath.section].desc!
            cell.mDesc.textColor = Style.textStrongColor
            cell.mDesc.lineBreakMode = .ByWordWrapping
            cell.mDesc.font = UIFont.systemFontOfSize(13, weight: UIFontWeightLight)
            
            
            let isFollowing = currentUser!.following!.contains(magazines[indexPath.section].name!)
            
            if isFollowing{
                CraftUtility.craftApprovalFollowBtn(cell.getBtn)
            }else{
                CraftUtility.craftNotFollowingButton(cell.getBtn, title: "GET")
            }            
            cell.selectionStyle = .None
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("magazineFooterCell", forIndexPath: indexPath) as! MagazineFooterCell
        //cell.textLabel?.text = "Footer for you."
        //cell.textLabel?.font = UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
        //return cell
        
        
        cell.category1.backgroundColor = Style.category.gray
        cell.category1.textColor = Style.textStrongLighterColor
        cell.category1.text = "sport"
        cell.category1.clipsToBounds = true
        cell.category1.layer.cornerRadius = 7
        
        let followers = magazines[indexPath.section].followers!.count - 1
        cell.followersBtn.setTitle("\(followers) followers", forState: UIControlState.Normal)
        cell.followersBtn.titleLabel!.textColor = Style.textStrongLighterColor
        
        cell.followersBtn.setTitleColor(Style.defaultComponentColor, forState: .Normal)
        cell.followersBtn.titleLabel?.font = UIFont.systemFontOfSize(12, weight: UIFontWeightSemibold)
        cell.followersBtn.tag = indexPath.section
        
        cell.username.setTitleColor(Style.defaultComponentColor, forState: .Normal)
        cell.username.setTitle(magazines[indexPath.section].createdBy, forState: UIControlState.Normal)
        cell.username.titleLabel?.font = UIFont.systemFontOfSize(12, weight: UIFontWeightSemibold)
        

        //cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.selectionStyle = .None
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rowIndex = indexPath.section
        self.performSegueWithIdentifier("showSelectedObject", sender: self)
    }
    
    
    func addMagazineButtonTouched(){
        
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
    
    // In a storyboard-based applicati  on, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSelectedObject"{
            let destinationVC = segue.destinationViewController as! SelectedObjectViewController
            print(magazines[rowIndex])
            destinationVC.initView(magazines[rowIndex], withTitle: magazines[rowIndex].name!, source: Types.Sources.MAGAZINE)
            
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
