//
//  TrapDataSource.swift
//  Slaad
//
//  Created by PJ Gray on 6/5/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation

class TrapDataSource {
    
    func getRandomTrap(success: ((_ trap:Trap) -> Void)?, failure: ((_ error: Error?) -> Void)? ) {
        var trigger: String
        var severity: Trap.DamageSeverity
        var effects: String
        
        switch Roll.d6() {
        case 1: trigger = "Stepped on (floor, stairs)"
        case 2: trigger = "Moved through (doorway, hallway)"
        case 3: trigger = "Touched (doorknob, statue)"
        case 4: trigger = "Opened (door, treasure chest)"
        case 5: trigger = "Looked at (mural, arcane symbol)"
        case 6: trigger = "Moved (cart, stone block)"
        default: trigger = "Moved (cart, stone block)"
        }
        
        switch Roll.d6() {
        case 1...2: severity = .setback
        case 3...5: severity = .dangerous
        case 6: severity = .deadly
        default: severity = .setback
        }
        
        switch Roll.d100() {
        case 1...4: effects = "Magic missiles shoot from a statue or object"
        case 5...7: effects = "Collapsing staircase creates a ramp that deposits characters into a pit at its lower end"
        case 8...10: effects = "Ceiling block falls, or entire ceiling collapses"
        case 11...12: effects = "Ceiling lowers slowly in locked room"
        case 13...14: effects = "Chute opens in floor"
        case 15...16: effects = "Clanging noise attracts nearby monsters"
        case 17...19: effects = "Touching an object triggers a disintegrate spell"
        case 20...23: effects = "Door or other object is coated with contact poison"
        case 24...27: effects = "Fire shoots out from wall, floor, or object"
        case 28...30: effects = "Touching an object triggers a flesh to stone spell"
        case 31...33: effects = "Floor collapses or is an illusion"
        case 34...36: effects = "Vent releases gas: blinding, acidic, obscuring, paralyzing, poisonous, or sleep-inducing"
        case 37...39: effects = "Floor tiles are electrified"
        case 40...43: effects = "Glyph of warding"
        case 44...46: effects = "Huge wheeled statue rolls down corridor"
        case 47...49: effects = "Lightning bolt shoots from wall or object"
        case 50...52: effects = "Locked room floods with water or acid"
        case 53...56: effects = "Darts shoot out of an opened chest"
        case 57...59: effects = "A weapon, suit of armor, or rug animates and attacks when touched "
        case 60...62: effects = "Pendulum, either bladed or weighted as a maul, swings across the room or hall"
        case 63...67: effects = "Hidden pit opens beneath characters (25 percent chance that a black pudding or gelatinous cube fills the bottom of the pit)"
        case 68...70: effects = "Hidden pit floods with acid or fire"
        case 71...73: effects = "Locking pit floods with water"
        case 74...77: effects = "Scything blade emerges from wall or object"
        case 78...81: effects = "Spears (possibly poisoned ) spring out"
        case 82...84: effects = "Brittle stairs collapse over spikes"
        case 85...88: effects = "Thunderwave knocks characters into a pit or spikes"
        case 89...91: effects = "Steel or stone jaws restrain a character"
        case 92...94: effects = "Stone block smashes across hallway"
        case 95...97: effects = "Symbol"
        case 98...100: effects = "Walls slide together"
        default: effects = ""
        }
        
        success?(Trap(trigger: trigger, damageSeverity: severity, effects: effects))
    }
}
