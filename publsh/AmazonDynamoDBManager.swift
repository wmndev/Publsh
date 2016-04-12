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
        exp.hashKeyValues = hash
        return dynamoDBObjectMapper.query(Article.self, expression: exp)
    }
    
    
//    static func getFollowersActivities(entityNames: Set<String>) -> AWSTask{
//        //let keysArray : NSArray = [dic]
//        var keysArray=[Dictionary<String,AWSDynamoDBAttributeValue>]()
//        for username in entityNames{
//            let attributeValue1 = AWSDynamoDBAttributeValue()
//            attributeValue1.S = username
//            let dic:Dictionary<String,AWSDynamoDBAttributeValue> = ["entityName":attributeValue1]
//            keysArray.append(dic)
//            
//        }
//        
//        let keysAndAttributes : AWSDynamoDBKeysAndAttributes = AWSDynamoDBKeysAndAttributes()
//        keysAndAttributes.keys = keysArray
//        keysAndAttributes.consistentRead = true
//        
//        let batchGetItemInput = AWSDynamoDBBatchGetItemInput()
//        batchGetItemInput.requestItems = ["ActivityLog" : keysAndAttributes]
//        
//        let dynamoDB = AWSDynamoDB.defaultDynamoDB()
//        
//        return dynamoDB.batchGetItem(batchGetItemInput)
//    }
    
    
    
//    static func searchBtnPressed(sender: UIButton) {
//        
//        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
//        
//        //Query using GSI index table
//        //What is the top score ever recorded for the game Meteor Blasters?
//        let queryExpression = AWSDynamoDBQueryExpression()
//        queryExpression.hashKeyValues = self.pickerData[self.gameTitlePickerView .selectedRowInComponent(0)];
//        queryExpression.scanIndexForward = self.orderSegControl.selectedSegmentIndex==0 ? true : false;
//        queryExpression.indexName = self.sortSegControl.titleForSegmentAtIndex(self.sortSegControl.selectedSegmentIndex)
//        
//        queryExpression.hashKeyAttribute = "GameTitle";
//        
//        //example expression: @"TopScore <= 5000" or @"Wins >= 10"
//        queryExpression.rangeKeyConditionExpression = "\(self.rangeKeyArray[self.sortSegControl.selectedSegmentIndex]) > :rangeval"
//        
//        queryExpression.expressionAttributeValues = [":rangeval":self.rangeStepper.value];
//        
//        dynamoDBObjectMapper .query(DDBTableRow.self, expression: queryExpression) .continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { (task:AWSTask!) -> AnyObject! in
//            if (task.error != nil) {
//                print("Error: \(task.error)")
//                
//                let alertController = UIAlertController(title: "Failed to query a test table.", message: task.error.description, preferredStyle: UIAlertControllerStyle.Alert)
//                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action:UIAlertAction) -> Void in
//                })
//                alertController.addAction(okAction)
//                self.presentViewController(alertController, animated: true, completion: nil)
//            } else {
//                if (task.result != nil) {
//                    self.pagniatedOutput = task.result as? AWSDynamoDBPaginatedOutput
//                }
//                self.performSegueWithIdentifier("unwindToMainSegue", sender: self)
//            }
//            return nil
//        })
//        
//    }
    
    
    static func getBatchItemEntites(entityNames: ArraySlice<String>, hashKey:String, tableName:String, prefix:String="") ->AWSTask{
        var keysArray=[Dictionary<String,AWSDynamoDBAttributeValue>]()
        for username in entityNames{
            let attributeValue1 = AWSDynamoDBAttributeValue()
            attributeValue1.S = prefix + username
            let dic:Dictionary<String,AWSDynamoDBAttributeValue> = [hashKey:attributeValue1]
            keysArray.append(dic)
            
        }
        
        let keysAndAttributes : AWSDynamoDBKeysAndAttributes = AWSDynamoDBKeysAndAttributes()
        keysAndAttributes.keys = keysArray
        keysAndAttributes.consistentRead = true
        
        let batchGetItemInput = AWSDynamoDBBatchGetItemInput()
        batchGetItemInput.requestItems = [tableName : keysAndAttributes]
        
        let dynamoDB = AWSDynamoDB.defaultDynamoDB()
        
        return dynamoDB.batchGetItem(batchGetItemInput)
        
    }
    
    
    
//    static func getBatchUserItems(usernames: Set<String>) -> AWSTask{
//        //let keysArray : NSArray = [dic]
//        var keysArray=[Dictionary<String,AWSDynamoDBAttributeValue>]()
//        for username in usernames{
//            let attributeValue1 = AWSDynamoDBAttributeValue()
//            attributeValue1.S = username
//            let dic:Dictionary<String,AWSDynamoDBAttributeValue> = ["username":attributeValue1]
//            keysArray.append(dic)
//            
//        }
//
//        let keysAndAttributes : AWSDynamoDBKeysAndAttributes = AWSDynamoDBKeysAndAttributes()
//        keysAndAttributes.keys = keysArray
//        keysAndAttributes.consistentRead = true
//        
//        
//        let batchGetItemInput = AWSDynamoDBBatchGetItemInput()
//        batchGetItemInput.requestItems = ["User" : keysAndAttributes]
//        
//         let dynamoDB = AWSDynamoDB.defaultDynamoDB()
//        
//        return dynamoDB.batchGetItem(batchGetItemInput)
//    }
    
    
    static func auditActivity(entityName:String, isEntityUser:Bool, operation:String, onEntityType:String, onEntity:String){
        let activityLog = ActivityLog()
        activityLog.entityName = isEntityUser ? "@U@_" + entityName : "@M@_"+entityName
        activityLog.operation = operation
        activityLog.onEntity = onEntity
        activityLog.onEntityType = onEntityType
        activityLog.logTime = NSDate().timeIntervalSince1970
        
        let insertValues = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        insertValues.save(activityLog)
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
