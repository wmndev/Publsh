//
//  UsersTableViewController.swift
//  publsh
//
//  Created by Itai Wiseman on 3/16/16.
//  Copyright © 2016 iws. All rights reserved.
//

import UIKit


class UsersTableViewController: UITableViewController {
    
    var usernames:Set<String>?
    var users = [User]()
    let cellReuseIdentifier = "reuseIdentifier"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        
        AmazonDynamoDBManager.getBatchUserItems(usernames!, completeHandler: { (task) -> AnyObject? in
            if task.result != nil{
                let getItemResult: AWSDynamoDBBatchGetItemOutput = task.result as! AWSDynamoDBBatchGetItemOutput
                
                let response = getItemResult.responses!["User"]
                for userDic in response!{
                    let user = User()
                    print(userDic["username"]?.S)
                    user.username = userDic["username"]?.S
                    user.fb_id = userDic["fb_id"]?.S
                    self.users.append(user)
                    
                }
                self.tableView.reloadData()
            }else{
                print(task.error)
            }
            
            return nil
        })
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return users.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
        
        cell.textLabel?.text = users[indexPath.row].username
        
        
        
        let fbProfileImgUrl = "https://graph.facebook.com/" + users[indexPath.row].fb_id! + "/picture?type=large"
        
        if let url = NSURL(string: fbProfileImgUrl) {
            cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width)! / 2;
            cell.imageView?.clipsToBounds = true
            cell.imageView?.layer.borderWidth = 1
            cell.imageView?.layer.borderColor = Style.grayBackground.CGColor
            cell.imageView!.sd_setImageWithURL(url)
        }
        
        
        return cell
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
