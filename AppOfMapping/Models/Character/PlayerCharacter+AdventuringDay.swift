//
//  PlayerCharacter+AdventuringDay.swift
//  Slaad
//
//  Created by PJ Gray on 5/14/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation

extension PlayerCharacter {
    func adjustedXPPerAdventuringDay() -> Int {
        switch self.totalLevel() {
        case 1: return 300
        case 2: return 600
        case 3: return 1200
        case 4: return 1700
        case 5: return 3500
        case 6: return 4000
        case 7: return 5000
        case 8: return 6000
        case 9: return 7500
        case 10: return 9000
        case 11: return 10500
        case 12: return 11500
        case 13: return 13500
        case 14: return 15000
        case 15: return 18000
        case 16: return 20000
        case 17: return 25000
        case 18: return 27000
        case 19: return 30000
        case 20: return 40000
        default:
            return 0
        }
    }
}
