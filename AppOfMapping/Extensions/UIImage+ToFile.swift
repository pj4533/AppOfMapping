//
//  UIImage+ToFile.swift
//  Slaad
//
//  Created by PJ Gray on 5/8/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func writeToFile(fileName:String) {
        do {
            if let path = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/"+fileName) {
                print(path)
                try self.pngData()?.write(to: path)
            }
        } catch {
            
        }
    }
}
