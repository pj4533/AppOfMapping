//
//  UIColor+Hex.swift
//  Slaad
//
//  Created by PJ Gray on 5/3/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func fromHex( _ hexValue: UInt32) -> UIColor {
        let red = CGFloat((hexValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((hexValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(hexValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
