//
//  Types.swift
//  publsh
//
//  Created by Itai Wiseman on 1/24/16.
//  Copyright © 2016 iws. All rights reserved.
//

import Foundation
class Types{
    enum Sources : Int {
        case MAGAZINE
        case USER
        case NA
    }
    
    enum Activity: String {
        case FOLLOWED = "is now following"
        case CREATED_MAGAZINE = "created magazine"
        case UPDATED_MAGAZINE = "updated magazine"
    }
}

