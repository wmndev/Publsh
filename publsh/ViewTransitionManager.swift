//
//  ViewTransitionManager.swift
//  
//
//  Created by Itai Wiseman on 3/16/16.
//
//

import Foundation

class ViewTransitionManager{
    
    static let  mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
    
    static func moveToUserView(username: String, view:UIViewController){
        
        EZLoadingActivity.show("", disableUI: true)
        
        AmazonDynamoDBManager.getUser(username)!.continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { (task:AWSTask!) -> AnyObject! in
            
            if task.error != nil{
                EZLoadingActivity.hide(success: false, animated: false)
            }
            
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let selectedObjectViewController: SelectedObjectViewController = mainStoryboard.instantiateViewControllerWithIdentifier("selectedObjectViewController") as! SelectedObjectViewController
            
            let user = task.result as! User
            selectedObjectViewController.initView(user, withTitle: user.username!, source: Types.Sources.USER)
            
            
            view.navigationController?.pushViewController(selectedObjectViewController, animated: true)
            EZLoadingActivity.hide()
            return nil
            
        })
        
    }
    
    static func moveToUserListView(usernameList:Set<String>, view:UIViewController, withTitle:String){
        let selectedObjectViewController: UsersTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("usersTableView") as! UsersTableViewController
        selectedObjectViewController.usernames = usernameList
        selectedObjectViewController.navigationItem.title = withTitle
        view.navigationController?.pushViewController(selectedObjectViewController, animated: true)
        
        
    }
    
    static func moveToArticleContentView(content:String, article:Article, view:UIViewController){
        let articleContentViewController :ArticleTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("articleTableViewController") as! ArticleTableViewController
        
        let str = content.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
        
        articleContentViewController.articleContent = str
        articleContentViewController.article = article
        
        view.navigationController?.pushViewController(articleContentViewController, animated: true)
        
    }
    
}
