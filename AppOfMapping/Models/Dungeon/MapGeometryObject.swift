//
//  MapGeometryObject.swift
//  Slaad
//
//  Created by PJ Gray on 5/3/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation
import SpriteKit
import os.log

class MapGeometryObject : Codable {
    var x1 : Int
    var x2 : Int
    var y1 : Int
    var y2 : Int
    
    // this is in row/col (tiles, NOT pixels)
    var center : CGPoint
    
    init(X: Int, Y: Int, W: Int, H: Int) {
        self.x1 = X
        self.x2 = X + W
        self.y1 = Y
        self.y2 = Y + H
        self.center = CGPoint(x: (self.x1 + self.x2) / 2, y: (self.y1 + self.y2) / 2)
    }
    
    private enum CodingKeys : String, CodingKey {
        case x1
        case x2
        case y1
        case y2
        case center
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.x1, forKey: .x1)
        try container.encode(self.x2, forKey: .x2)
        try container.encode(self.y1, forKey: .y1)
        try container.encode(self.y2, forKey: .y2)
        try container.encode(self.center, forKey: .center)
    }
}
