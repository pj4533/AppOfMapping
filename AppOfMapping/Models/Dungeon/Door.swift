//
//  Door.swift
//  Slaad
//
//  Created by PJ Gray on 5/17/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation
import CoreGraphics

class Door : Codable {
    enum Direction : String, Codable, CaseIterable {
        case up
        case down
        case left
        case right
    }

    var point : CGPoint?
    var direction : Direction?
    
    init(_ direction: Direction, _ point: CGPoint) {
        self.point = point
        self.direction = direction
    }
}
