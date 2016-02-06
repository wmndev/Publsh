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
    var rowIndex = -1;
    
    @IBAction func donePressed(sender: AnyObject) {
        
        let viewController:UIViewController = UIStoryboard(name: "App", bundle: nil).instantiateViewControllerWithIdentifier("appInit") as UIViewController
        self.presentViewController(viewController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigation
        self.view.backgroundColor = Style.viewBackgroundColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = "DISCOVER MAGAZINES"
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Style.textColorWhite]
        
        
        
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.view.addSubview(activityIndicator)
        activityIndicator.frame = self.view.bounds
        activityIndicator.startAnimating()
        
        let query = PFQuery(className:"Magazine")
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //navigationController?.hidesBarsOnSwipe = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 0
        }
        return magazines.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 110
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if section == 0{
            return 40
        }
        return 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("magazineCell", forIndexPath: indexPath) as! MagazineIntroCell
        
        cell.mImage.layer.cornerRadius = (cell.mImage.frame.size.width) / 2;
        cell.mImage.clipsToBounds = true
        cell.mImage.layer.borderWidth = 0.25
        cell.mImage.layer.borderColor = Style.textLightColor.CGColor
        
        cell.mTitle.text = (magazines[indexPath.row].objectForKey("name") as? String)! + " >"
        cell.mTitle.textColor = Style.textStrongColor
        //        cell.textLabel?.font = UIFont.boldSystemFontOfSize(16.0)
        
        cell.mDescription.text = magazines[indexPath.row].objectForKey("description") as? String
        cell.mDescription.textColor = Style.textStrongColor
        
        cell.follow.layer.cornerRadius = 6 //cell.follow.frame.size.width / 2;
        cell.follow.clipsToBounds = true
        cell.follow.layer.borderWidth = 1
        cell.follow.layer.borderColor = Style.navigationBarBackgroundColor.CGColor;
        cell.follow.setTitleColor(Style.navigationBarBackgroundColor, forState: UIControlState.Normal)
        
        cell.filter1.setTitleColor(Style.textLightColor, forState: UIControlState.Normal)
        cell.filter2.setTitleColor(Style.textLightColor, forState: UIControlState.Normal)
        cell.filter3.setTitleColor(Style.textLightColor, forState: UIControlState.Normal)
        
        //        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "magazineCell")
        //        cell.selectionStyle = UITableViewCellSelectionStyle.None
        //
        //        let image = UIImage(named: "sample.jpg")
        //        let newImage = resizeImage(image!, toTheSize: CGSizeMake(60, 60))
        //
        //
        //        cell.textLabel?.text = magazines[indexPath.row].objectForKey("name") as? String
        //        cell.textLabel?.textColor = Style.textStrongColor
        //        cell.textLabel?.font = UIFont.boldSystemFontOfSize(16.0)
        //
        //        cell.detailTextLabel?.text = magazines[indexPath.row].objectForKey("description") as? String
        //        cell.detailTextLabel?.textColor = Style.textLightColor
        //        cell.textLabel?.font = UIFont.boldSystemFontOfSize(14.0)
        //        cell.detailTextLabel?.numberOfLines = 3
        //
        //
        //        let accessoryButton = UIButton(frame: CGRectMake(0, 0, 36, 36))
        //        accessoryButton.center = CGPointMake(18, 20)
        //        accessoryButton.titleLabel!.textAlignment = NSTextAlignment.Center
        //        accessoryButton.titleLabel!.font = UIFont.systemFontOfSize(20)
        //        accessoryButton.setTitleColor(Style.navigationBarBackgroundColor, forState: UIControlState.Normal)
        //        accessoryButton.setTitle("+", forState: UIControlState.Normal)
        //
        //        accessoryButton.layer.cornerRadius = accessoryButton.frame.size.width / 2;
        //        accessoryButton.clipsToBounds = true
        //        accessoryButton.layer.borderWidth = 1
        //        accessoryButton.layer.borderColor = Style.navigationBarBackgroundColor.CGColor;
        //        accessoryButton.addTarget(self, action: "addMagazineButtonTouched", forControlEvents: .TouchUpInside)
        //
        //        cell.accessoryView = accessoryButton
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "headerCell")
        if section == 0{
            cell.textLabel!.text = "Build your collection"
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rowIndex = indexPath.row
        self.performSegueWithIdentifier("showMagazineDetails", sender: self)
    }
    
    
    func addMagazineButtonTouched(){
        
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
        
        if segue.identifier == "showMagazineDetails"{
            let destinationVC = segue.destinationViewController as! MagazineTableViewController
            destinationVC.magazine = magazines[rowIndex]            
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
