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
    var userId:NSNumber? = 0
    var score:NSNumber? = 0

    
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
    
    
}
