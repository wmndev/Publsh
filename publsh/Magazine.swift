//
//  Magazine.swift
//  publsh
//
//  Created by Itai Wiseman on 2/11/16.
//  Copyright © 2016 iws. All rights reserved.
//

import Foundation


class Magazine: AWSDynamoDBObjectModel,AWSDynamoDBModeling{
    
    var id:NSNumber?  = 0
    var createdBy:NSNumber? = 0
    var score:NSNumber? = 0
    var statistics : NSDictionary = [String : NSNumber]()
    var content : NSDictionary = [NSNumber : NSSet]()
    var name: String?
    var desc: String?
    var types:NSSet?
    var contributers:NSSet?
    var sources:NSSet?
    var followers:NSSet?
    
    
    class func dynamoDBTableName() -> String! {
        return "Magazine"
    }
    
    class func hashKeyAttribute() -> String! {
        return "name"
    }
    
    class func rangeKeyAttribute() -> String! {
        return "createdBy"
    }
    
    class func ignoreAttributes() -> Array<AnyObject>! {
        return ["desc", "types", "content"]
    }
    
    //MARK: NSObjectProtocol hack
    override func isEqual(object: AnyObject?) -> Bool {
        return super.isEqual(object)
    }
    
    override func `self`() -> Self {
        return self
    }
    
}

class Article: AWSDynamoDBObjectModel,AWSDynamoDBModeling{
    var sourceId:NSNumber?
    var articleId:NSNumber?
    var img:String?
    var link:String?
    var title:String?
    var imageData:NSData?
    
    
    class func dynamoDBTableName() -> String! {
        return "FeedContent"
    }
    
    class func hashKeyAttribute() -> String! {
        return "sourceId"
    }
    
    class func rangeKeyAttribute() -> String! {
        return "articleId"
    }
    
    //MARK: NSObjectProtocol hack
    override func isEqual(object: AnyObject?) -> Bool {
        return super.isEqual(object)
    }
    
    override func `self`() -> Self {
        return self
    }
}
