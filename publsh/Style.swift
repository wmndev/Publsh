//
//  Style.swift
//  publsh
//
//  Created by Itai Wiseman on 1/18/16.
//  Copyright © 2016 iws. All rights reserved.
//

import Foundation

struct Style{
    
    static var  navigationBarBackgroundColor = colorWithHexString("#2980B9")
    static var  textColorWhite = colorWithHexString("#FFFFFF")
    static var  viewBackgroundColor = colorWithHexString("#FFFFFF")
    static var  strongCellBackgroundColor = colorWithHexString("#34495E")
    static var  textStrongColor = colorWithHexString("#2C3E50")
    static var  textLightColor = colorWithHexString("#95A5A6")
    
    
    static var controllerColor = colorWithHexString("#2980B9")
    
}

//    
//    
//    struct header {
//        static var sectionHeaderTitleFont = UIFont(name: "Helvetica-Bold", size: 15)
//        static var sectionHeaderBackgroundColor = colorWithHexString("#FFFFFF")
//        static var sectionHeaderAlpha: CGFloat = 0.95
//    }
//    
//    
//    struct pages {
//        
//        struct userProfile {
//            static var leftLabelFontColor = colorWithHexString("#EB6E68")
//            static var rightLabelFontColor = colorWithHexString("#F8BDBF")
//            static var activityBulletColor = colorWithHexString("#EA5A51")
//            static var activityBulletFontColor = colorWithHexString("#FFFFFF")
//            static var userProfileImageBorderColor = colorWithHexString("#E8594B")
//            
//            
//            
//        }
//    }
//    
//    struct general {
//        static var lightFontColor =  colorWithHexString("#BBBBBB")
//        static var cellBackgroundColor = colorWithHexString("#E35C49")
//    }
//    
//    struct navigation {
//        static var navigationBackgroundColor = colorWithHexString("#38393E")
//        static var barButtonBackgroundColor = colorWithHexString("#3498db")
//    }
//
//
//    static var color = UIColor.whiteColor()
//    
//    
//    
//    static var detailsCellBackground = colorWithHexString("#FFFFFF")
//
//    
//    
//    struct controller {
//        static var buttonsNotSelectedColor = colorWithHexString("#383732")
//        static var buttonsNotSelectedBorderColor = colorWithHexString("#383732")        
//        static var buttonSelected = colorWithHexString("#B8959B") //green
//
//    }



func colorWithHexString (hex: String) -> UIColor {
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
    
    if (cString.hasPrefix("#")) {
        cString = (cString as NSString).substringFromIndex(1)
    }
    
    if (cString.characters.count != 6) {
        return UIColor.grayColor()
    }
    
    let rString = (cString as NSString).substringToIndex(2)
    let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
    let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    NSScanner(string: rString).scanHexInt(&r)
    NSScanner(string: gString).scanHexInt(&g)
    NSScanner(string: bString).scanHexInt(&b)
    
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}
