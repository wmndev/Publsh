//
//  CraftUtility.swift
//  publsh
//
//  Created by Itai Wiseman on 3/21/16.
//  Copyright © 2016 iws. All rights reserved.
//

import Foundation

class CraftUtility{
    
    
    static func craftApprovalFollowBtn(btn:UIButton, fontSize:CGFloat = 14.0){
        btn.setTitle("FOLLOWING", forState: UIControlState.Normal)
        btn.layer.borderWidth = 1
        btn.setTitleColor(Style.textColorWhite, forState: .Normal)
        btn.backgroundColor = Style.approvalColor
        btn.layer.borderColor = Style.approvalColor.CGColor
        btn.titleLabel!.font = UIFont.systemFontOfSize(fontSize, weight: UIFontWeightMedium)
        
    }
    
    
    static func craftNotFollowingButton(btn:UIButton, title:String, fontSize:CGFloat = 14.0){
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.layer.borderWidth = 1
        btn.setTitleColor(Style.defaultComponentColor, forState: .Normal)
        btn.backgroundColor = Style.whiteColor
        btn.layer.borderColor = Style.defaultComponentColor.CGColor
        btn.titleLabel!.font = UIFont.systemFontOfSize(fontSize, weight: UIFontWeightMedium)
    }
    
    
    
    
    
    
    
}