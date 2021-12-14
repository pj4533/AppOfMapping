//
//  EncounterEnemy.swift
//  Slaad
//
//  Created by PJ Gray on 5/9/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation

class EncounterEnemy : Codable, CustomStringConvertible {    
    var monster : Monster?
    var treasure : Treasure?
    var label : String?
    var locked: Bool?
    
    init(monster: Monster) {
        self.monster = monster
        self.label = monster.name
        self.locked = false
        self.treasure = Treasure(monster, false)
    }
}
