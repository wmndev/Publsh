//
//  Style.swift
//  publsh
//
//  Created by Itai Wiseman on 1/18/16.
//  Copyright © 2016 iws. All rights reserved.
//

import Foundation

struct Style{
    
    struct magazine {
        static var headerBackgroundColor = colorWithHexString("#2B81BA")
    }
    
    struct user {
        static var headerBackgroundColor = colorWithHexString("#13C7AE")
    }
    
    struct category{
        static var orange = colorWithHexString("#EDBB71")
        static var lightBlue = colorWithHexString("#84D2F0")
        static var green = colorWithHexString("#74CC98")
        static var gray = colorWithHexString("#DEE2E5")
    }
    
    
    
    static var navigationBarBackgroundColor = baseColor
    
    static var welcomeScreenBackgroundColor = baseColor
    
    static var textColorWhite = whiteColor
    
    static var viewBackgroundColor = whiteColor
    
    static var strongCellBackgroundColor = colorWithHexString("#34495E") //--
    
    static var textStrongLighterColor = colorWithHexString("#464646")
    
    static var textStrongColor = colorWithHexString("#222222")
    
    static var textLightColor = colorWithHexString("#95A5A6")
    
    static var approvalColor = colorWithHexString("#1ABC9C")
    
    static var controllerColor = colorWithHexString("#2980B9")
    
    static var defaultComponentColor = colorWithHexString("#00587A")
    
    static var lightGrayBackgroundColor = colorWithHexString("#F2F2F2")
    static var strongGrayBackgroundColor = colorWithHexString("#DEE2E5")
    
    
    static var whiteColor = colorWithHexString("#FFFFFF")
    static var baseColor = colorWithHexString("#2EA1D7")
    
    
}



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
