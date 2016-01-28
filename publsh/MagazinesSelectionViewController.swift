//
//  MagazinesSelectionViewController.swift
//  publsh
//
//  Created by Itai Wiseman on 1/4/16.
//  Copyright © 2016 iws. All rights reserved.
//

import UIKit


extension MagazinesSelectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            
            //let screenWidth: CGFloat = screenSize.size.width
            //let length: CGFloat = (screenWidth / 2.0)
            let length = collectionView.frame.size.width / 2
            var size: CGSize = CGSizeMake(length - 2, length + 60 - 2  )
            return size
            
    }
    
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
}


extension MagazinesSelectionViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        filterContentForSearchText(textField)
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
    
    func filterContentForSearchText(textField: UITextField){
        if textField.text != "" {
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            textField.addSubview(activityIndicator)
            activityIndicator.frame = textField.bounds
            activityIndicator.startAnimating()
            
            let query =  PFQuery(className: "Magazine")
            query.whereKey("name", containsString: textField.text)
            query.whereKey("isPublic", equalTo: true)
            
            query.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                activityIndicator.removeFromSuperview()
                if let data = results{
                    self.magazines = data as [PFObject]
                    self.collectionView!.reloadData()
                }
                
            })
        }
    }
}


class MagazinesSelectionViewController: UICollectionViewController {
    
    var magazines = [PFObject]()
    
    
    
    //private let reuseIdentifier = "mCell"
    private let sectionInsets = UIEdgeInsets(top: 2.0, left: 1.0, bottom: 0.0, right: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return magazines.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("magCell", forIndexPath: indexPath)
            //as! CollectionViewCell
//        
//        // Configure the cell
//        //cell.backgroundColor = UIColor.blackColor()
//        
//        //image
//        var bundlePath = NSBundle.mainBundle().pathForResource("zevel", ofType: "jpg")
//        
//        cell.cellImage.image = UIImage(contentsOfFile: bundlePath!)
//        cell.magazineName.text = magazines[indexPath.row]["name"] as? String
//        cell.magazineDescription.text = magazines[indexPath.row]["description"] as? String
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
}
