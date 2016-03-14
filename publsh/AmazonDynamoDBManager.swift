//
//  AmazonDynamoDBManager.swift
//  publsh
//
//  Created by Itai Wiseman on 3/13/16.
//  Copyright © 2016 iws. All rights reserved.
//

import Foundation

class AmazonDynamoDBManager{
    
    static func getUser(hashKey:AnyObject) -> AWSTask?{
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        return dynamoDBObjectMapper.load(User.self, hashKey: hashKey, rangeKey: nil)
    }
    
    static func getArticles(hash: String) -> AWSTask! {
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        
        let exp = AWSDynamoDBQueryExpression()
        exp.hashKeyValues      = hash
        return dynamoDBObjectMapper.query(Article.self, expression: exp)
    }
    
    
    //        var dynamoDB = AWSDynamoDB.defaultDynamoDB()
    
    //Write Request 1
    //        let hashValue1 = AWSDynamoDBAttributeValue()
    //        hashValue1.S = magazine.name
    //
    //        let otherValue1 = AWSDynamoDBAttributeValue()
    //        otherValue1.SS = Array<String>(magazine.followers!)
    //
    //        let writeRequest = AWSDynamoDBWriteRequest()
    //        writeRequest.putRequest = AWSDynamoDBPutRequest()
    //        writeRequest.putRequest!.item = [
    //            "name" : hashValue1,
    //            "followers" : otherValue1]
    
    
    //        //Write Request 2
    //        let hashValue2 = AWSDynamoDBAttributeValue()
    //        hashValue2.S = currentUser!.username
    //
    //        let otherValue2 = AWSDynamoDBAttributeValue()
    //        otherValue2.SS = Array<String>(currentUser!.following!)
    //
    //        let writeRequest2 = AWSDynamoDBWriteRequest()
    //        writeRequest2.putRequest = AWSDynamoDBPutRequest()
    //        writeRequest2.putRequest!.item = [
    //            "username" : hashValue2,
    //            "following" : otherValue2]
    //
    //
    //
    //        let batchWriteItemInput = AWSDynamoDBBatchWriteItemInput()
    //        batchWriteItemInput.requestItems = [/*"Magazine": [writeRequest],*/ "User":[writeRequest2]];
    //        dynamoDB.batchWriteItem(batchWriteItemInput).continueWithBlock({ (task: AWSTask!) -> AnyObject! in
    //                        if task.error != nil {
    //                            print("Error: \(task.error)")
    //                        }else{
    //                            dispatch_async(dispatch_get_main_queue()) {
    //                                self.craftFollowButton((self.headerCell?.followBtn)!)
    //
    //                            }
    //                        }
    //                        return nil
    //                    })
    
    
    
}
