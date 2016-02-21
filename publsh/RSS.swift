//
//  RSS.swift
//  publsh
//
//  Created by Itai Wiseman on 2/18/16.
//  Copyright © 2016 iws. All rights reserved.
//

import Foundation


class RssSource : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var id:NSNumber?
    var name:String?
    var url:String?
    var type:[String]?
    var imgUrl:String?
    
    
    class func dynamoDBTableName() -> String! {
        return "RssSource"
    }
    
    class func hashKeyAttribute() -> String! {
        return "name"
    }
    
    
    //MARK: NSObjectProtocol hack
    override func isEqual(object: AnyObject?) -> Bool {
        return super.isEqual(object)
    }
    
    override func `self`() -> Self {
        return self
    }
  
}

class RssFeed : AWSDynamoDBObjectModel, AWSDynamoDBModeling{
    
    var id:NSNumber?
    var sourceId:NSNumber?
    var recievedAt:NSNumber?
    var file:String?
    
    class func dynamoDBTableName() -> String! {
        return "RssFeed"
    }
    
    class func hashKeyAttribute() -> String! {
        return "id"
    }
    
    class func rangeKeyAttribute() -> String! {
        return "sourceId"
    }
    
    
    //MARK: NSObjectProtocol hack
    override func isEqual(object: AnyObject?) -> Bool {
        return super.isEqual(object)
    }
    
    override func `self`() -> Self {
        return self
    }
    

    
    
    
    /*
    var id:NSNumber?  = 0
    var userId:NSNumber? = 0
    var score:NSNumber? = 0
    var statistics : NSDictionary = [String : NSNumber]()
    
    
    var name: String?
    var desc: String?
    
    class func dynamoDBTableName() -> String! {
    return "Magazine"
    }
    
    class func hashKeyAttribute() -> String! {
    return "id"
    }
    
    class func rangeKeyAttribute() -> String! {
    return "userId"
    }
    
    class func ignoreAttributes() -> Array<AnyObject>! {
    return ["name","desc"]
    }
    
    //MARK: NSObjectProtocol hack
    override func isEqual(object: AnyObject?) -> Bool {
    return super.isEqual(object)
    }
    
    override func `self`() -> Self {
    return self
    }
*/
    
    
    
}
