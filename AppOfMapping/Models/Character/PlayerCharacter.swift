//
//  PlayerCharacter.swift
//  Slaad
//
//  Created by PJ Gray on 5/1/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation

class PlayerCharacter : Codable, CustomStringConvertible {
    var name : String?
    var classes : [Class]?
    var externalLink : URL?
    
    init() {}
    
    func totalLevel() -> Int {
        return (self.classes?.map({$0.level ?? 0}) ?? []).reduce(0, +)
    }
}
