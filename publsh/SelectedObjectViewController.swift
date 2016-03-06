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
    
    let EXTRA_CELLS = 2
    
    
    func initView(object: NSObject, withTitle: String, source: Types.Sources){
        self.object = object
        self.source = source
        self.navigationItem.title = withTitle
        
        getLinkedData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Style.lightGrayBackgroundColor
        
        //for Auto cell height
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        //register default cell
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "clearCell")
        
        //navigation
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Style.textColorWhite]
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.row == 0 {
            return 96
        }
        if indexPath.row == 1 {
            return 85
        }
        return 50
        //return UITableViewAutomaticDimension
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EXTRA_CELLS + data.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("objectHeaderCell") as! ObjectHeaderCell
            
            if source == Types.Sources.MAGAZINE{
                //cell.contentView.backgroundColor = Style.magazine.headerBackgroundColor
                
                let magazine = object as! Magazine
                craftMenuButton(cell.totalBtn,title: "\(magazine.statistics.objectForKey("contributers")!)\nhelpers")
                craftMenuButton(cell.followersBtn,title: "\(magazine.statistics.objectForKey("sources")!)\nsources")
                craftMenuButton(cell.followingBtn,title: "\(magazine.statistics.objectForKey("followers")!)\nfollowers")
                
                
                
            }else{
                //cell.contentView.backgroundColor = Style.user.headerBackgroundColor
                
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
            cell.targetImage.layer.borderWidth = 1
            cell.targetImage.layer.borderColor = Style.textColorWhite.CGColor
            
            return cell
        }
        
        
        if indexPath.row == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("objectSubtitleCell", forIndexPath: indexPath) as! ObjectSubtitleViewCell
            
            //cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            //cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
            
            
            if source == Types.Sources.MAGAZINE{
                //cell.contentView.backgroundColor = Style.magazine.headerBackgroundColor
                
                let magazine = object as! Magazine
                
                cell.username.setTitleColor(Style.defaultComponentColor, forState: .Normal)
                cell.username.setTitle(magazine.createdBy, forState: UIControlState.Normal)
                
                cell.desc.text = magazine.desc!
                cell.desc.textColor = Style.textStrongLighterColor
                cell.desc.lineBreakMode = .ByWordWrapping
                
            }else{
                //cell.contentView.backgroundColor = Style.user.headerBackgroundColor
                
            }
            return cell
            
        }else{
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "articleDetails")
            
            if source == Types.Sources.MAGAZINE{
                
                let article:Article = data[indexPath.row - EXTRA_CELLS] as! Article
                
                cell.textLabel?.text = article.title
                cell.textLabel?.font = UIFont(name: "Arial", size: 14.0)
                cell.textLabel?.numberOfLines = 2
                
                let articleImage = resizeImage(UIImage(data: article.imageData!)!, toTheSize: CGSizeMake(40, 40))
                
                cell.imageView!.image = articleImage
                cell.imageView!.frame = CGRectMake(0, 0, 40, 40)
                cell.imageView!.layer.cornerRadius = 20
                cell.imageView!.clipsToBounds = true
                cell.imageView?.layer.masksToBounds = true
                //cell.imageView!.layer.borderWidth = 1
                
                
            }
            
            return cell
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
                        for item in results.items {
                            let article:Article = item as! Article
                            article.imageData = NSData(contentsOfURL: NSURL(string: article.img!)!)
                            
                            self.data.append(item)
                        }
                        
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                        })
                        
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
        let titleAttributes : [String : AnyObject] = [NSFontAttributeName : UIFont(name: "Arial", size: 25.0)!,
            NSForegroundColorAttributeName : Style.textStrongColor]
        let subTitleAttributes : [String : AnyObject] = [NSFontAttributeName : UIFont(name: "Arial", size: 12.0)!,
            NSForegroundColorAttributeName : Style.textStrongLighterColor]
        
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
        return 60.0
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
