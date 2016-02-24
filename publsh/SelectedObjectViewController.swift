//
//  MagazineTableViewController.swift
//  publsh
//
//  Created by Itai Wiseman on 1/30/16.
//  Copyright © 2016 iws. All rights reserved.
//

import UIKit

class SelectedObjectViewController: UITableViewController {
    
    var source = Types.Sources.NA
    var object = NSObject()
    var data:[AnyObject]?
    
    
    func initView(object: NSObject, withTitle: String, source: Types.Sources){
        self.object = object
        self.source = source
        self.navigationItem.title = withTitle
        
        getLinkedData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        // tableView.estimatedRowHeight = 70.0
        
        //navigation
        self.view.backgroundColor = Style.viewBackgroundColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Style.textColorWhite]
        
        //loadUser()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
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
    
    //    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
    //        if indexPath.row == 0{
    //            return UITableViewAutomaticDimension
    //        }
    //        return 50.0
    //    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 96.0
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("objectHeaderCell") as! ObjectHeaderCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if source == Types.Sources.MAGAZINE{
            let magazine = object as! Magazine
            craftMenuButton(cell.totalBtn,title: "\(magazine.statistics.objectForKey("contributers")!)\ncontributers")
            craftMenuButton(cell.followersBtn,title: "\(magazine.statistics.objectForKey("sources")!)\nsources")
            craftMenuButton(cell.followingBtn,title: "\(magazine.statistics.objectForKey("followers")!)\nfollowers")
            
            
            
        }else{
            craftMenuButton(cell.totalBtn,title: "17\nmagazines")
            craftMenuButton(cell.followersBtn,title: "202\nfollowers")
            craftMenuButton(cell.followingBtn,title: "5K\nfollowing")
        }
        
        cell.followBtn.setTitle(source == Types.Sources.MAGAZINE ? "TAKE IT" : "FOLLOW", forState: UIControlState.Normal)
        cell.followBtn.layer.borderWidth = 1
        cell.followBtn.setTitleColor(Style.defaultComponentColor, forState: .Normal)
        cell.followBtn.layer.borderColor = Style.defaultComponentColor.CGColor
        
        setUserProfileImage(cell)
        cell.targetImage.layer.cornerRadius = cell.targetImage.frame.size.width / 2;
        cell.targetImage.clipsToBounds = true
        cell.targetImage.layer.borderWidth = 0.25
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("objectSubtitleCell", forIndexPath: indexPath) as! ObjectSubtitleViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            if source == Types.Sources.MAGAZINE{
                let magazine = object as! Magazine
                
                cell.username.setTitleColor(Style.defaultComponentColor, forState: .Normal)
                
                cell.desc.text = magazine.desc!
                cell.desc.textColor = Style.textStrongLighterColor
                cell.desc.lineBreakMode = .ByWordWrapping
                
            }else{
                
            }
            
            
            
            
            //cell.contentView.backgroundColor = Style.strongCellBackgroundColor
            
            //cell.collectedByLabel.textColor = Style.textLightColor
            
            
            
            //cell.username.setTitleColor(Style.textColorWhite, forState: UIControlState.Normal)
            //            cell.username.setTitle(user.objectForKey("name") as? String, forState: UIControlState.Normal)
            
            //            cell.magazineDescription.text = magazine!.objectForKey("description") as? String
            
            
            //cell.magazineDescription.textColor = Style.textLightColor
            //cell.magazineDescription.lineBreakMode = .ByWordWrapping
            
            
            
            
            return cell
        }else{
            let cell =  UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "articleDetails")
            return cell
        }
        
        
        
    }
    
    
    func getLinkedData(){
        if source == Types.Sources.MAGAZINE{
            let magazine = object as! Magazine
            
            for  (srcId, artclIds) in magazine.content{
                
                let cond = AWSDynamoDBCondition()
                
                let nsarr = artclIds.allObjects as NSArray
                
                for arId in nsarr{
                    let articleIdStr: String  = String(arId)
                    
                    let v1    = AWSDynamoDBAttributeValue();
                    v1.N = articleIdStr
                    cond.comparisonOperator = AWSDynamoDBComparisonOperator.EQ
                    cond.attributeValueList = [ v1 ]
                    let c = [ "articleId" : cond ]
                    
                    let sourceId = Int(srcId as! String)!
                    
                    self.query(sourceId , keyConditions:c).continueWithSuccessBlock({ (task: AWSTask!) -> AWSTask! in
                        
                        let results = task.result as! AWSDynamoDBPaginatedOutput
                        for r in results.items {
                            print(r)
                        }
                        return nil
                    })
                    
                }
            }
            
        }
    }
    
    func query(hash: NSNumber, keyConditions:[NSObject:AnyObject]) -> AWSTask! {
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        
        let exp = AWSDynamoDBQueryExpression()
        exp.hashKeyValues      = hash
        exp.rangeKeyConditions = keyConditions
        
        return dynamoDBObjectMapper.query(Article.self, expression: exp)
    }
    
    
    func craftMenuButton(button: UIButton, title: NSString){
        
        //------------------------
        // 2 lines title
        //------------------------
        
        //applying the line break mode
        button.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        button.titleLabel?.center = CGPointMake(30,22)
        button.titleLabel?.textAlignment = NSTextAlignment.Center
        
        //var buttonText: NSString = "hello\nthere"
        
        //getting the range to separate the button title strings
        let newlineRange: NSRange = title.rangeOfString("\n")
        
        //getting both substrings
        var substring1: NSString = ""
        var substring2: NSString = ""
        
        if(newlineRange.location != NSNotFound) {
            substring1 = title.substringToIndex(newlineRange.location)
            substring2 = title.substringFromIndex(newlineRange.location)
        }
        
        //assigning diffrent fonts to both substrings
        let titleAttributes : [String : AnyObject] = [NSFontAttributeName : UIFont(name: "Arial", size: 17.0)!,
            NSForegroundColorAttributeName : Style.textStrongColor]
        let subTitleAttributes : [String : AnyObject] = [NSFontAttributeName : UIFont(name: "Arial", size: 11.0)!,
            NSForegroundColorAttributeName : Style.textLightColor]
        
        let attrString = NSMutableAttributedString(
            string: substring1 as String,
            attributes: titleAttributes)
        
        let attrString1 = NSMutableAttributedString(
            string: substring2 as String,
            attributes: subTitleAttributes)
        
        //appending both attributed strings
        attrString.appendAttributedString(attrString1)
        
        //assigning the resultant attributed strings to the button
        button.setAttributedTitle(attrString, forState: .Normal)
        
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 100.0
        }
        return 50.0
    }
    
    func setUserProfileImage(cell: ObjectHeaderCell){
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
