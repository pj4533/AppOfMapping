//
//  Trap.swift
//  Slaad
//
//  Created by PJ Gray on 6/5/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation

struct Trap : Codable {
    
    enum DamageSeverity : String, Codable, CaseIterable {
        case setback = "Setback"
        case dangerous = "Dangerous"
        case deadly = "Deadly"
    }

    let trigger : String
    let damageSeverity : DamageSeverity
    let effects : String
    let saveDC : Int
    let attackBonus : Int
    
    init(trigger: String, damageSeverity: DamageSeverity, effects: String) {
        self.trigger = trigger
        self.damageSeverity = damageSeverity
        self.effects = effects
        
        switch self.damageSeverity {
        case .setback: self.saveDC = [10,11].randomElement()!
        case .dangerous: self.saveDC = [12,13,14,15].randomElement()!
        case .deadly: self.saveDC = [16,17,18,19,20].randomElement()!
        }

        switch self.damageSeverity {
        case .setback: self.attackBonus = [3,4,5].randomElement()!
        case .dangerous: self.attackBonus = [6,7,8].randomElement()!
        case .deadly: self.attackBonus = [9,10,11,12].randomElement()!
        }

    }
    
    
    func damageDice(_ characterLevel: Int) -> String {
        switch self.damageSeverity {
        case .setback:
            switch characterLevel {
            case 1...4: return "1d10"
            case 5...10: return "2d10"
            case 11...16: return "4d10"
            case 17...20: return "10d10"
            default: return ""
            }
        case .dangerous:
            switch characterLevel {
            case 1...4: return "2d10"
            case 5...10: return "4d10"
            case 11...16: return "10d10"
            case 17...20: return "18d10"
            default: return ""
            }
        case .deadly:
            switch characterLevel {
            case 1...4: return "4d10"
            case 5...10: return "10d10"
            case 11...16: return "18d10"
            case 17...20: return "24d10"
            default: return ""
            }
        }
    }
}
