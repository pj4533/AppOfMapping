//
//  Monster+AbilityModifier.swift
//  Slaad
//
//  Created by PJ Gray on 5/21/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation

extension Monster {
    private func abilityScoreModifier(_ score: Int) -> Int {
        switch score {
        case 1: return -5
        case 2...3: return -4
        case 4...5: return -3
        case 6...7: return -2
        case 8...9: return -1
        case 10...11: return 0
        case 12...13: return 1
        case 14...15: return 2
        case 16...17: return 3
        case 18...19: return 4
        case 20...21: return 5
        case 22...23: return 6
        case 24...25: return 7
        case 26...27: return 8
        case 28...29: return 9
        case 30: return 10
        default: return 0
        }
    }
    
    func strModifier() -> Int {
        return self.abilityScoreModifier(self.strength ?? 0)
    }
    func dexModifier() -> Int {
        return self.abilityScoreModifier(self.dexterity ?? 0)
    }
    func conModifier() -> Int {
        return self.abilityScoreModifier(self.constitution ?? 0)
    }
    func intModifier() -> Int {
        return self.abilityScoreModifier(self.intelligence ?? 0)
    }
    func wisModifier() -> Int {
        return self.abilityScoreModifier(self.wisdom ?? 0)
    }
    func chaModifier() -> Int {
        return self.abilityScoreModifier(self.charisma ?? 0)
    }
}
