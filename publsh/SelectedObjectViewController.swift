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
    var data = [AnyObject]()
    var controllerCell: ObjectControllerCell?
    var headerCell: ObjectHeaderCell?
    var isFollowing = false
    
    let cellReuseIdentifier = "headerBasicCell"
    
    let EXTRA_CELLS = 2
    
    @IBAction func getMagazine(sender: AnyObject) {
        isFollowing = !isFollowing
        let magazine = object as! Magazine
        
        if isFollowing{
            if magazine.followers == nil{
                magazine.followers = Set<String>()
                magazine.followers?.insert("")
            }
            
            magazine.followers?.insert(currentUser!.username!)
            currentUser!.following!.insert(magazine.name!)
        }else{
            magazine.followers?.remove(currentUser!.username!)
            currentUser?.following?.remove(magazine.name!)
        }
        
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        
        objectMapper.save(magazine).continueWithSuccessBlock({ (task: AWSTask!) -> AnyObject! in
            if task.error != nil {
                print("Error: \(task.error)")
            }else{
                objectMapper.save(currentUser)
                dispatch_async(dispatch_get_main_queue()) {
                    let followers = magazine.followers!.count
                    self.craftMenuButton(self.controllerCell!.followingBtn,title: "\(followers)\nFOLLOWERS")
                    
                    self.craftFollowButton((self.headerCell!.followBtn)!)
                    
                }
            }
            return nil
        })
        
        
        //        var dynamoDB = AWSDynamoDB.defaultDynamoDB()
        
        //Write Request 1
        //        let hashValue1 = AWSDynamoDBAttributeValue()
        //        hashValue1.S = magazine.name
        //
        //        let otherValue1 = AWSDynamoDBAttributeValue()
        //        otherValue1.SS = Array<String>(magazine.followers!)
        //
        //        let writeRequest = AWSDynamoDBWriteRequest()
        //        writeRequest.putRequest = AWSDynamoDBPutRequest()
        //        writeRequest.putRequest!.item = [
        //            "name" : hashValue1,
        //            "followers" : otherValue1]
        
        
        //        //Write Request 2
        //        let hashValue2 = AWSDynamoDBAttributeValue()
        //        hashValue2.S = currentUser!.username
        //
        //        let otherValue2 = AWSDynamoDBAttributeValue()
        //        otherValue2.SS = Array<String>(currentUser!.following!)
        //
        //        let writeRequest2 = AWSDynamoDBWriteRequest()
        //        writeRequest2.putRequest = AWSDynamoDBPutRequest()
        //        writeRequest2.putRequest!.item = [
        //            "username" : hashValue2,
        //            "following" : otherValue2]
        //
        //
        //
        //        let batchWriteItemInput = AWSDynamoDBBatchWriteItemInput()
        //        batchWriteItemInput.requestItems = [/*"Magazine": [writeRequest],*/ "User":[writeRequest2]];
        //        dynamoDB.batchWriteItem(batchWriteItemInput).continueWithBlock({ (task: AWSTask!) -> AnyObject! in
        //                        if task.error != nil {
        //                            print("Error: \(task.error)")
        //                        }else{
        //                            dispatch_async(dispatch_get_main_queue()) {
        //                                self.craftFollowButton((self.headerCell?.followBtn)!)
        //
        //                            }
        //                        }
        //                        return nil
        //                    })
    }
    
    func initView(object: NSObject, withTitle: String, source: Types.Sources){
        self.object = object
        self.source = source
        self.navigationItem.title = withTitle
        isUserFollowing()
        getLinkedData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        self.view.backgroundColor = Style.lightGrayBackgroundColor
        
        //for Auto cell height
        //tableView.rowHeight = UITableViewAutomaticDimension
        
        
        //navigation
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Style.textColorWhite]
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        if indexPath.row == 0{
            return 160
            //return UITableViewAutomaticDimension
        }
        if indexPath.row == 1{
            return 56
        }
        
        return 120
        
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count + EXTRA_CELLS
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("objectHeaderCell") as! ObjectHeaderCell
            headerCell = cell
            
            
            craftFollowButton(cell.followBtn)
            
            setUserProfileImage(cell)
            cell.targetImage.layer.cornerRadius = cell.targetImage.frame.size.width / 2;
            cell.targetImage.clipsToBounds = true
            cell.targetImage.layer.borderWidth = 1
            cell.targetImage.layer.borderColor = Style.textColorWhite.CGColor
            
            let magazine = object as! Magazine
            
            cell.publshLbl.font = UIFont.systemFontOfSize(12, weight: UIFontWeightSemibolds)
            
            cell.username.setTitleColor(Style.defaultComponentColor, forState: .Normal)
            cell.username.setTitle(magazine.createdBy, forState: UIControlState.Normal)
            cell.username.titleLabel?.font = UIFont.systemFontOfSize(13, weight: UIFontWeightRegular)
            
            //cell.fullName.text = currentUser?.fullName
            
            cell.desc.text = magazine.desc!
            cell.desc.textColor = Style.textStrongColor
            cell.desc.lineBreakMode = .ByWordWrapping
            cell.desc.font = UIFont.systemFontOfSize(13, weight: UIFontWeightLight)
            
            return cell
        }
        if indexPath.row == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("objectControllerCell") as! ObjectControllerCell
            controllerCell = cell
            
            if source == Types.Sources.MAGAZINE{
                let magazine = object as! Magazine
                craftMenuButton(cell.totalBtn,title: "\(magazine.statistics.objectForKey("contributers")!)\nCONTRIBUTE")
                craftMenuButton(cell.followersBtn,title: "\(magazine.statistics.objectForKey("sources")!)\nSOURCES")
                let followers = magazine.followers!.count
                craftMenuButton(cell.followingBtn,title: "\(followers)\nFOLLOWERS")
                craftMenuButton(cell.activityBtn,title: "\(followers)\nACTIVITIES")
                
            }else{
                craftMenuButton(cell.totalBtn,title: "17\nmagazines")
                craftMenuButton(cell.followersBtn,title: "202\nfollowers")
                craftMenuButton(cell.followingBtn,title: "5K\nfollowing")
                craftMenuButton(cell.activityBtn,title: "72\nactivities")
            }
            
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("articleCell") as! ArticleCell
        
        if source == Types.Sources.MAGAZINE{
            
            let article:Article = data[indexPath.row - EXTRA_CELLS] as! Article
            
            
            cell.aTitle.text = article.title
            cell.aTitle.textColor = Style.textStrongColor
            cell.aTitle.font = UIFont.systemFontOfSize(15, weight: UIFontWeightSemibold)
            cell.aTitle.lineBreakMode = .ByWordWrapping
            
            cell.aSubTitle.text = article.title
            cell.aSubTitle.textColor = Style.textStrongColor
            cell.aSubTitle.font = UIFont.systemFontOfSize(13, weight: UIFontWeightLight)
            cell.aSubTitle.lineBreakMode = .ByWordWrapping
            
            
            cell.aImage.image = resizeImage(UIImage(data: article.imageData!)!, toTheSize: CGSizeMake(80, 80))
            cell.aImage!.clipsToBounds = true
            cell.aImage?.layer.masksToBounds = true
        }
        
        return cell
        
    }
    
    func craftFollowButton(btn:UIButton){
        if isFollowing{
            btn.setTitle("FOLLOWING", forState: UIControlState.Normal)
            btn.layer.borderWidth = 1
            btn.setTitleColor(Style.textColorWhite, forState: .Normal)
            btn.backgroundColor = Style.approvalColor
            btn.layer.borderColor = Style.approvalColor.CGColor
        }else{
            btn.setTitle(source == Types.Sources.MAGAZINE ? "GET" : "FOLLOW", forState: UIControlState.Normal)
            btn.layer.borderWidth = 1
            btn.setTitleColor(Style.defaultComponentColor, forState: .Normal)
            btn.backgroundColor = Style.whiteColor
            btn.layer.borderColor = Style.defaultComponentColor.CGColor
        }
    }
    
    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{
        let scale = CGFloat(max(size.width/image.size.width,
            size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale;
        
        let rr:CGRect = CGRectMake( 0, 0, width, height);
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.drawInRect(rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage
    }
    
    func isUserFollowing(){
        let magazine = object as! Magazine
        isFollowing = magazine.followers?.contains(currentUser!.username!) ?? false
    }
    
    func getLinkedData(){
        if source == Types.Sources.MAGAZINE{
            let magazine = object as! Magazine
            
            query(magazine.name!).continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { (task:AWSTask!) -> AnyObject! in
                if (task.error == nil) {
                    if (task.result != nil) {
                        
                        let results = task.result as! AWSDynamoDBPaginatedOutput
                        for r in results.items {
                            let article = r as! Article
                            article.imageData = NSData(contentsOfURL: NSURL(string: article.img!)!)
                            self.data.append(article)
                        }
                        self.tableView.reloadData()
                    }
                } else {
                    print("Error: \(task.error)")
                }
                return nil
            })
        }
    }
    
    func query(hash: String /*, keyConditions:[NSObject:AnyObject]*/) -> AWSTask! {
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        
        let exp = AWSDynamoDBQueryExpression()
        exp.hashKeyValues      = hash
        //if keyConditions != nil{
        //   exp.rangeKeyConditions = keyConditions
        // }
        
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
        let titleAttributes : [String : AnyObject] = [NSFontAttributeName : UIFont.systemFontOfSize(22, weight: UIFontWeightRegular),
            NSForegroundColorAttributeName : Style.textStrongColor]
        let subTitleAttributes : [String : AnyObject] = [NSFontAttributeName : UIFont.systemFontOfSize(9, weight: UIFontWeightLight),
            NSForegroundColorAttributeName : Style.textStrongColor]
        
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
    
    
    func setUserProfileImage(cell: ObjectHeaderCell){
    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showUserProfile"{
            //let destinationVC = segue.destinationViewController as! ProfileTableViewController
            //destinationVC.user = self.user
        }
        
    }
    
    
}
