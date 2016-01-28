//
//  FirstSignupViewController.swift
//  publsh
//
//  Created by Itai Wiseman on 12/19/15.
//  Copyright © 2015 iws. All rights reserved.
//

import UIKit



class FirstSignupViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var magazines = ["The populars", "Nurds Stuff", "Want to be a super hero?"]
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK tableviewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return magazines.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        //var cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "magazine")
        var cell = tableView.dequeueReusableCellWithIdentifier("magazine", forIndexPath: indexPath)
        cell.textLabel?.text = magazines[indexPath.row]
     
        cell.detailTextLabel?.text = "Description of magazine"
        
        var bundlePath = NSBundle.mainBundle().pathForResource("magazine", ofType: "jpg")
        var image = UIImage(contentsOfFile: bundlePath!)
        cell.imageView?.image = image
        

        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.layer.cornerRadius = 10.0
        return cell;
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if tableView.cellForRowAtIndexPath(indexPath)?.accessoryType == UITableViewCellAccessoryType.Checkmark{
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
        }else{
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
    }
    
    //MARK SearchController
    

    
    

}
