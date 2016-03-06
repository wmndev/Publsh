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
    
    @IBOutlet var skipDoneBarButton: UIBarButtonItem!
    
    @IBAction func donePressed(sender: AnyObject) {
        let viewController:UIViewController = UIStoryboard(name: "App", bundle: nil).instantiateViewControllerWithIdentifier("appInit") as UIViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register UITableViewCell for reuse
//        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        self.view.backgroundColor = Style.lightGrayBackgroundColor
        
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.view.addSubview(activityIndicator)
        activityIndicator.frame = self.view.bounds
        
        if AmazonClientManager.sharedInstance.isConfigured() {
            AmazonClientManager.sharedInstance.resumeSession {
                (task) -> AnyObject! in
                dispatch_async(dispatch_get_main_queue()) {
                    self.activityIndicator.startAnimating()
                    self.updateTableData()
                }
                return nil
            }
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source'
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 84
    }
    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 15
//    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return magazines.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("magazineCell", forIndexPath: indexPath) as! MagazineIntroCell

        cell.mImage.layer.borderColor = Style.textLightColor.CGColor
        
        cell.mTitle.text = magazines[indexPath.row].name!
        cell.mTitle.textColor = Style.textStrongColor
        
        cell.mDesc.text = magazines[indexPath.row].desc!
        cell.mTitle.textColor = Style.textStrongLighterColor
        

        
        
        cell.category1.backgroundColor = Style.category.gray
        cell.category1.textColor = Style.textStrongLighterColor
        cell.category1.text = "sport"
        cell.category1.clipsToBounds = true
        cell.category1.layer.cornerRadius = 7
        
        cell.numOfFollowers.text = "122 followers"
        cell.numOfFollowers.textColor = Style.textStrongLighterColor
        
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rowIndex = indexPath.row
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
            destinationVC.initView(magazines[rowIndex], withTitle: magazines[rowIndex].name!, source: Types.Sources.MAGAZINE)
            
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
