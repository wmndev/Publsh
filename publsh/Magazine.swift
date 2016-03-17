//
//  Magazine.swift
//  publsh
//
//  Created by Itai Wiseman on 2/11/16.
//  Copyright © 2016 iws. All rights reserved.
//

import Foundation


class Magazine: AWSDynamoDBObjectModel,AWSDynamoDBModeling{
    
    var createdBy:String?
    var score:NSNumber? = 0
    var statistics : NSDictionary = [String : NSNumber]()
    var name: String?
    var desc: String?
    var types:NSSet?
    var contributers:NSSet?
    var sources:NSSet?
    var followers:Set<String>?
    
    
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
        return ["following"]
    }
    
    //MARK: NSObjectProtocol hack
    override func isEqual(object: AnyObject?) -> Bool {
        return super.isEqual(object)
    }
    
    override func `self`() -> Self {
        return self
    }
    
    func getHashKeyValue() -> String!{
        return name
    }
    
}

class Article: AWSDynamoDBObjectModel,AWSDynamoDBModeling{
    var source:String?
    var img:String?
    var link:String?
    var title:String?
    var imageData:NSData?
    var magazineName:String?
    var addedAt:NSNumber?
    
    
    class func dynamoDBTableName() -> String! {
        return "MagazineContent"
    }
    
    class func hashKeyAttribute() -> String! {
        return "magazineName"
    }
    
    class func rangeKeyAttribute() -> String! {
        return "addedAt"
    }
    
    //MARK: NSObjectProtocol hack
    override func isEqual(object: AnyObject?) -> Bool {
        return super.isEqual(object)
    }
    
    override func `self`() -> Self {
        return self
    }
}
