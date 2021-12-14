//
//  Party.swift
//  Slaad
//
//  Created by PJ Gray on 5/2/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation

class Party : Codable, CustomStringConvertible {
    var members : [PlayerCharacter]
    var elitePartyFactor : Double?
    
    init() {
        self.members = []
    }
    
    init(members: [PlayerCharacter]) {
        self.members = members
    }
    
    func addMember(_ character:PlayerCharacter, atIndex index:Int) {
        self.members.insert(character, at: index)
    }
    
    func addMember(_ character:PlayerCharacter) {
        self.members.append(character)
    }
    
    func removeMember(atIndex index:Int) {
        self.members.remove(at: index)
    }
    
    func xpThreshhold(withEncounterDifficulty difficulty:Encounter.Difficulty) -> Int {
        return Int(Double(self.members.map({$0.xpThreshhold(withEncounterDifficulty: difficulty)}).reduce(0, +)) * (self.elitePartyFactor ?? 1.0))
    }

    func adjustedXPPerAdventuringDay() -> Int {
        return Int(Double(self.members.map({$0.adjustedXPPerAdventuringDay()}).reduce(0,+)) * (self.elitePartyFactor ?? 1.0))
    }
}
