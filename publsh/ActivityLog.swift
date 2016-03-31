//
//  ActivityLog.swift
//  publsh
//
//  Created by Itai Wiseman on 3/30/16.
//  Copyright © 2016 iws. All rights reserved.
//

import Foundation

class ActivityLog: AWSDynamoDBObjectModel,AWSDynamoDBModeling{
    
    var entityName: String?
    var logTime: NSNumber?
    var operation: String?
    var onEntity: String?
    var onEntityType: String?
    
    class func dynamoDBTableName() -> String! {
        return "ActivityLog"
    }
    
    class func hashKeyAttribute() -> String! {
        return "entityName"
    }
    
    class func rangeKeyAttribute() -> String! {
        return "logTime"
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        return super.isEqual(object)
    }
    
    override func `self`() -> Self {
        return self
    }
}