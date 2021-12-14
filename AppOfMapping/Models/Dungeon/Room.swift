//
//  Room.swift
//  Slaad
//
//  Created by PJ Gray on 5/3/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation
import SpriteKit

class Room : MapGeometryObject {
    var encounter : Encounter?
    var trap : Trap?
    
    var roomLocked : Bool?
    var roomId : Int?
    var name : String?
    var nameLocked : Bool = false
    var notes : String?
    
    // only used for map encounter generation
    var shouldBeBossRoom : Bool = false
    var shouldBeTrapRoom : Bool = false

    private enum CodingKeys: String, CodingKey {
        case trap
        case encounter
        case roomLocked
        case roomId
        case name
        case nameLocked
        case notes
    }

    override init(X: Int, Y: Int, W: Int, H: Int) {
        super.init(X: X, Y: Y, W: W, H: H)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.encounter = try values.decodeIfPresent(Encounter.self, forKey: .encounter)
            self.trap = try values.decodeIfPresent(Trap.self, forKey: .trap)
            self.roomLocked = try values.decodeIfPresent(Bool.self, forKey: .roomLocked)
            self.roomId = try values.decodeIfPresent(Int.self, forKey: .roomId)
            self.name = try values.decodeIfPresent(String.self, forKey: .name)
            self.nameLocked = try values.decodeIfPresent(Bool.self, forKey: .nameLocked) ?? false
            self.notes = try values.decodeIfPresent(String.self, forKey: .notes)
        } catch {
            
        }
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.encounter, forKey: .encounter)
        try container.encode(self.trap, forKey: .trap)
        try container.encode(self.roomLocked, forKey: .roomLocked)
        try container.encode(self.roomId, forKey: .roomId)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.nameLocked, forKey: .nameLocked)
        try container.encode(self.notes, forKey: .notes)
    }
    
}
