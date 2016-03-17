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
    
    
    func initView(object: NSObject, withTitle: String, source: Types.Sources){
        self.object = object
        self.source = source
        self.navigationItem.title = withTitle
        isUserFollowing()
        getLinkedData()
    }
    
    @IBAction func followTouched(sender: AnyObject) {
        isFollowing = !isFollowing
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        var magazine:Magazine?
        var user:User?
        
        
        
        if source == Types.Sources.MAGAZINE{
             magazine = object as! Magazine
            
            if isFollowing{
                magazine!.followers?.insert(currentUser!.username!)
                currentUser!.following!.insert(magazine!.getHashKeyValue()!)
            }else{
                magazine!.followers?.remove(currentUser!.username!)
                currentUser?.following?.remove(magazine!.getHashKeyValue()!)
            }
            
        }else{
            user = object as! User
            if isFollowing{
                user!.followers?.insert(currentUser!.username!)
                currentUser!.following!.insert(user!.getHashKeyValue()!)
            }else{
                user!.followers?.remove(currentUser!.username!)
                currentUser?.following?.remove(user!.getHashKeyValue()!)
            }
        }
        
        objectMapper.save(source == Types.Sources.MAGAZINE ? magazine! : user!).continueWithSuccessBlock({ (task: AWSTask!) -> AnyObject! in
                if task.error != nil {
                    print("Error: \(task.error)")
                }else{
                    objectMapper.save(currentUser)
                    dispatch_async(dispatch_get_main_queue()) {
                        let followers =  (self.source == Types.Sources.MAGAZINE ?  magazine!.followers!.count : user!.followers!.count) - 1
                        self.craftMenuButton(self.controllerCell!.followersBtn,title: "\(followers)\nFOLLOWERS")
                        
                        self.craftFollowButton((self.headerCell!.followBtn)!)
                        
                    }
                }
                return nil
            })
    }
    
    @IBAction func usernameClicked(sender: AnyObject) {
        let btn = sender as! UIButton
        let username = btn.titleLabel?.text
        
        ViewTransitionManager.moveToUserView(username!, view: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        self.view.backgroundColor = Style.lightGrayBackgroundColor
        
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
            
            cell.targetImage.layer.cornerRadius = cell.targetImage.frame.size.width / 2;
            cell.targetImage.clipsToBounds = true
            cell.targetImage.layer.borderWidth = 1
            cell.targetImage.layer.borderColor = Style.grayBackground.CGColor
            
            craftFollowButton(cell.followBtn)
            
            cell.desc.textColor = Style.textStrongColor
            cell.desc.lineBreakMode = .ByWordWrapping
            cell.desc.font = UIFont.systemFontOfSize(13, weight: UIFontWeightLight)
            
            cell.publshLbl.font = UIFont.systemFontOfSize(12, weight: UIFontWeightSemibold)
            
            if source == Types.Sources.MAGAZINE{
                

                let magazine = object as! Magazine
                
                cell.publshLbl.text = "Creator:"
                
                cell.username.setTitleColor(Style.defaultComponentColor, forState: .Normal)
                cell.username.setTitle(magazine.createdBy, forState: UIControlState.Normal)
                cell.username.titleLabel?.font = UIFont.systemFontOfSize(14, weight: UIFontWeightSemibold)
                
                cell.desc.text = magazine.desc!

            }else{ //User
                
                let user = object as! User
                
                cell.publshLbl.text = "About me:"
                cell.username.hidden = true
                
                EZLoadingActivity.showOnController("", disableUI: false, controller: self)
                setUserProfileImage(user.fb_id!)
                
                cell.desc.text = user.about
            }
            
            return cell
        }
        if indexPath.row == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("objectControllerCell") as! ObjectControllerCell
            controllerCell = cell
            
            if source == Types.Sources.MAGAZINE{
                let magazine = object as! Magazine
                craftMenuButton(cell.totalBtn,title: "\(magazine.statistics.objectForKey("contributers")!)\nCONTRIBUTE")
                craftMenuButton(cell.followingBtn  ,title: "\(magazine.statistics.objectForKey("sources")!)\nSOURCES")
                let followers = magazine.followers!.count
                craftMenuButton(cell.followersBtn,title: "\(followers)\nFOLLOWERS")
                craftMenuButton(cell.activityBtn,title: "\(followers)\nACTIVITIES")
                
            }else{
                let user = object as! User
                craftMenuButton(cell.totalBtn,title: "17\nMAGAZINES")
                let followers = (user.followers?.count)! - 1
                craftMenuButton(cell.followersBtn,title: "\(followers)\nFOLLOWERS")
                let following = (user.following?.count)! - 1
                craftMenuButton(cell.followingBtn,title: "\(following)\nFOLLOWING")
                craftMenuButton(cell.activityBtn,title: "72\nACTIVITIES")
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
            btn.setTitle(source == Types.Sources.MAGAZINE ? "+ GET" : "FOLLOW", forState: UIControlState.Normal)
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
        if source == Types.Sources.MAGAZINE{
        let magazine = object as! Magazine
        isFollowing = magazine.followers?.contains(currentUser!.username!) ?? false
        }else{
            let user = object as! User
            isFollowing = user.followers?.contains(currentUser!.username!) ?? false
        }
    }
    
    func getLinkedData(){
        if source == Types.Sources.MAGAZINE{
            let magazine = object as! Magazine
            
            AmazonDynamoDBManager.getArticles(magazine.name!).continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { (task:AWSTask!) -> AnyObject! in
                if task.error == nil {
                    if task.result != nil {
                        
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
    
    
    func setUserProfileImage(u_id: String ) {
        let downloadPath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("temp-download")
         AWSS3Manager.downloadImage(u_id, downloadingFilePath: downloadPath).continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { (task:AWSTask!) -> AnyObject! in
            
            if task.result != nil{
                
                self.headerCell?.targetImage.image = UIImage(contentsOfFile: downloadPath.path!)
                EZLoadingActivity.hide()
            }
            return nil
            
        })

    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    
}
