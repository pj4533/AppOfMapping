//
//  CustomStringConvertible+Desc.swift
//  Slaad
//
//  Created by PJ Gray on 5/2/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation

extension CustomStringConvertible {
    var description : String {
        var description: String = "***** \(type(of: self)) *****\n"
        
        let selfMirror = Mirror(reflecting: self)
        for child in selfMirror.children {

            var unwrappedAny = child.value
            let mi = Mirror(reflecting: child.value)
            if mi.displayStyle == .optional {
                if mi.children.count == 0 {
                    unwrappedAny = NSNull()
                } else {
                    let (_, some) = mi.children.first!
                    unwrappedAny = some
                }
            }
                        
            if let propertyName = child.label {
                description += "\(propertyName): \(unwrappedAny)\n"
            }
        }
        return description
    }
}
