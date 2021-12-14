//
//  UIView+ScreenGrab.swift
//  Slaad
//
//  Created by PJ Gray on 5/8/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func screenGrab() -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: self.bounds.size.width, height: self.bounds.size.height))
        self.drawHierarchy(in: CGRect(x: 0.0, y: 0.0, width: self.bounds.size.width, height: self.bounds.size.height), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
