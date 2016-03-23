//
//  ArticleViewController.swift
//  publsh
//
//  Created by Itai Wiseman on 3/22/16.
//  Copyright © 2016 iws. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {


    @IBOutlet var aContentText: UITextView!
    
    var attributedContent:NSAttributedString?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aContentText.attributedText = attributedContent!
        
        
        //aContent.loadHTMLString(contentStr!, baseURL: nil)
        
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

}
