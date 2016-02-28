//
//  User.swift
//  publsh
//
//  Created by Itai Wiseman on 2/16/16.
//  Copyright © 2016 iws. All rights reserved.
//

import Foundation

class User: AWSDynamoDBObjectModel, AWSDynamoDBModeling{

    var id:NSNumber?
    var username: String?
    var fb_id:String?
    var email:String?
    var gender:String?
    var fullName:String?
    var statistics : NSDictionary = [String : NSNumber]()
    var about:String?
    var socialPings : NSDictionary = [String : NSNumber]() //twitter, Facebook etc. addresses
    

    class func dynamoDBTableName() -> String! {
        return "User"
    }
    
    class func hashKeyAttribute() -> String! {
        return "id"
    }
    
    
    class func ignoreAttributes() -> Array<AnyObject>! {
        return ["email", "gender", "socialPings", "about"]
    }
    
    //MARK: NSObjectProtocol hack
    override func isEqual(object: AnyObject?) -> Bool {
        return super.isEqual(object)
    }
    
    override func `self`() -> Self {
        return self
    }

}
