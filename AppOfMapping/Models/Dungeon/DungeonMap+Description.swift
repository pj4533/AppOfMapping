//
//  DungeonMap+Description.swift
//  Slaad
//
//  Created by PJ Gray on 6/7/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation

extension DungeonMap {
    
    func randomizeMapDescription() {
        let enemy = self.rooms.filter({$0.encounter?.boss == true}).first?.encounter?.enemies.first
        self.dungeonDescription = self.getMapDescriptionWithBossEnemy(enemy)
    }
    
    func getMapDescriptionWithBossEnemy(_ enemy:EncounterEnemy?) -> String? {
        let objectiveAndScheme = self.getVillainObjectiveAndScheme()
        let wording = Bool.random() ? ("seeking", "wants") : ("wanting", "seeks")
        return
"""
A \(enemy?.monster?.name?.split(separator: " ").last?.lowercased() ?? ""), \(wording.0) \(objectiveAndScheme.0.lowercased()), \(wording.1) \(objectiveAndScheme.1.lowercased()).
"""
    }
    

    func getVillainObjectiveAndScheme() -> (String,String) {
        switch Roll.d8() {
        case 1:
            switch Roll.d4() {
            case 1: return ("Immortality","to acquire a legendary item to prolong life")
            case 2: return ("Immortality","to become a god")
            case 3: return ("Immortality","to Become undead or obtain a younger body")
            case 4: return ("Immortality","to Steal a planar creature's essence")
            default: return ("","")
            }
        case 2:
            switch Roll.d4() {
            case 1: return ("Influence","to Seize a position of power or title")
            case 2: return ("Influence","to Win a contest or tournament")
            case 3: return ("Influence","to Win favor with a powerful individual")
            case 4: return ("Influence","to Place a pawn in a position of power")
            default: return ("","")
            }
        case 3:
            switch Roll.d6() {
            case 1: return ("Magic","to Obtain an ancient artifact")
            case 2: return ("Magic","to Build a construct or magical device")
            case 3: return ("Magic","to Carry out a deity’s wishes")
            case 4: return ("Magic","to Offer sacrifices to a deity")
            case 5: return ("Magic","to Contact a lost deity or power")
            case 6: return ("Magic","to Open a gate to another world")
            default: return ("","")
            }
        case 4:
            switch Roll.d4() {
            case 1: return ("Mayhem","to Fulfill an apocalyptic prophecy")
            case 2: return ("Mayhem","to Enact the vengeful will of a god or patron")
            case 3: return ("Mayhem","to Spread a vile contagion")
            case 4: return ("Mayhem","to Overthrow a government")
            case 5: return ("Mayhem","to Trigger a natural disaster")
            case 6: return ("Mayhem","to Utterly destroy a bloodline or clan")
            default: return ("","")
            }
        case 5:
            switch Roll.d4() {
            case 1: return ("Passion","to Prolong the life of a loved one")
            case 2: return ("Passion","to Prove worthy of another person’s love")
            case 3: return ("Passion","to Raise or restore a dead loved one")
            case 4: return ("Passion","to Destroy rivals for another person’s affection")
            default: return ("","")
            }
        case 6:
            switch Roll.d4() {
            case 1: return ("Power","to Conquer a region or incite a rebellion")
            case 2: return ("Power","to Seize control of an army")
            case 3: return ("Power","to Become the power behind the throne")
            case 4: return ("Power","to Gain the favor of a ruler")
            default: return ("","")
            }
        case 7:
            switch Roll.d4() {
            case 1: return ("Revenge","to Avenge a past humiliation or insult")
            case 2: return ("Revenge","to Avenge a past imprisonment or injury")
            case 3: return ("Revenge","to Avenge the death of a loved one")
            case 4: return ("Revenge","to Retrieve stolen property and punish the thief")
            default: return ("","")
            }
        case 8:
            switch Roll.d4() {
            case 1: return ("Wealth","to Control natural resources or trade")
            case 2: return ("Wealth","to Marry into wealth")
            case 3: return ("Wealth","to Plunder ancient ruins")
            case 4: return ("Wealth","to Steal land, goods, or money")
            default: return ("","")
            }
        default: return ("","")
        }
    }
}
