//
//  EncounterDataSource.swift
//  Slaad
//
//  Created by PJ Gray on 5/2/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation
import UIKit
import os.log

class EncounterDataSource {
    
    private func getRandomDifficulty(withStartingEnemies startingEnemies:[EncounterEnemy], party:Party) -> Encounter.Difficulty {
        var difficulty : Encounter.Difficulty = .medium
        if startingEnemies.count > 0 {
            let encounter = Encounter(enemies: startingEnemies)
            let startingDifficulty = encounter.difficultyForParty(party)
            if startingDifficulty == .easy {
                switch Roll.d100() {
                case 1...5: difficulty = .easy
                case 6...100: difficulty = Roll.d12() == 12 ? .hard : .medium
                default: difficulty = .medium
                }
            } else if startingDifficulty == .medium {
                switch Roll.d100() {
                case 1...100: difficulty = Roll.d12() == 12 ? .hard : .medium
                default: difficulty = .medium
                }
            } else if startingDifficulty == .hard {
                switch Roll.d100() {
                case 1...100: difficulty = .hard
                default: difficulty = .medium
                }
            } else if startingDifficulty == .deadly {
                difficulty = .deadly
            }
        } else {
            switch Roll.d100() {
            case 1...5: difficulty = .easy
            case 6...100: difficulty = Roll.d12() == 12 ? .hard : .medium
            default: difficulty = .medium
            }
        }
        
        return difficulty
    }
    
    func getRandomRoomName(forEncounter encounter:Encounter?) -> String? {
        do {
            let roomWordsArray = try String(contentsOf: Bundle.main.url(forResource: "room_words", withExtension: "txt")!, encoding: .utf8).split(separator: "\n")
            let adjectiveWordsArray = try String(contentsOf: Bundle.main.url(forResource: "adjective_words", withExtension: "txt")!, encoding: .utf8).split(separator: "\n")
            if Bool.random() {
                let nounWordsArray = try String(contentsOf: Bundle.main.url(forResource: "noun_words", withExtension: "txt")!, encoding: .utf8).split(separator: "\n")                
                return "The \(roomWordsArray.randomElement()?.capitalized ?? "") of \(adjectiveWordsArray.randomElement()?.capitalized ?? "") \(nounWordsArray.randomElement()?.capitalized ?? "")"
            } else {
                let monsterWordsArray = encounter?.enemies.map({String($0.monster?.name?.split(separator: " ").last ?? "")})
                return "The \(roomWordsArray.randomElement()?.capitalized ?? "") of the \(adjectiveWordsArray.randomElement()?.capitalized ?? "") \(monsterWordsArray?.randomElement()?.capitalized ?? "")"
            }
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func getEncounter(forParty party:Party, maxEnemies:Int, withEnemies startingEnemies:[EncounterEnemy]?, atDifficulty encounterDifficulty: Encounter.Difficulty?, difficultyLocked: Bool?, bossEncounter: Bool?, datasource: MonsterDataSource,success: ((_ encounter:Encounter) -> Void)?, failure: ((_ error: Error?) -> Void)? ) {
/*
         The issue here is that I have several variables:
         
         - maximum enemies per encounter
         - the starting enemies (ie, the user constrained monsters)
         - the encounterDifficulty (ie, the user constrained difficulty)
         - the random enemy count (1 to max enemies)
         - random difficulty (if not constrained)
         
         out of that, I need to calculate what monsters I can add (if any) to the encounter.  if i can't add any, then change the unconstrained portions until i can (or make the random generation account for the constraints)
         
 
 */
        var enemyCount = bossEncounter == true ? 1 : Array(1...maxEnemies).randomElement()!
        var enemies : [EncounterEnemy] = startingEnemies ?? []
        let bossEncounterDifficulty : Encounter.Difficulty = Roll.d100() > 80 ? .deadly : .hard
        var difficulty : Encounter.Difficulty = bossEncounter == true ? bossEncounterDifficulty : encounterDifficulty ?? .medium
        if (encounterDifficulty == nil) && (bossEncounter != true) {
            difficulty = self.getRandomDifficulty(withStartingEnemies: startingEnemies ?? [], party: party)
        }
        
        // encounter difficulties are a range, so a medium encounter is any between the threshold for medium and the threshhold for hard
        // this accounts for that range
        //
        var encounterXPBudget = 0
        switch difficulty {
        case .easy: encounterXPBudget = party.xpThreshhold(withEncounterDifficulty: .medium)
        case .medium: encounterXPBudget = party.xpThreshhold(withEncounterDifficulty: .hard)
        case .hard: encounterXPBudget = party.xpThreshhold(withEncounterDifficulty: .deadly)
        case .deadly: encounterXPBudget = party.xpThreshhold(withEncounterDifficulty: .deadly) + party.xpThreshhold(withEncounterDifficulty: .deadly)
        }

        if enemies.count >= enemyCount {
            enemyCount = enemies.count + 1
        }
        
        var adjustedXPBudget = 0
        
        repeat {
            adjustedXPBudget = Int(Double(encounterXPBudget) / Encounter.adjustedXPMultiplier(forPartySize: party.members.count, numEnemies: enemyCount))
            
            for enemy in enemies {
                adjustedXPBudget = adjustedXPBudget - (enemy.monster?.experiencePoints() ?? 0)
            }
            if adjustedXPBudget < 0 { enemyCount = enemyCount - 1 }
        } while (adjustedXPBudget < 0) && (enemyCount > enemies.count)
        
        // easiest way to error out here is on a single monster encounter, hard difficulty, constrained both ways
        //
        // also gets an error if you only constrain single monster on a hard difficulty -- valid -- 1 monster only
        // works at hard, 2 monsters goes over threshhold
        //
        // gets error with only constrain single monster, no difficulty constrain, cause random gets hard difficulty which is a valid error case.  i need to catch this case and make it deadly
        if enemyCount == enemies.count {
            var nextDifficulty : Encounter.Difficulty = .easy
            var useNext = false
            for i in Encounter.Difficulty.allCases {
                if i == difficulty {
                    useNext = true
                } else {
                    if useNext {
                        nextDifficulty = i
                        useNext = false
                    } else {
                        continue
                    }
                }
            }
            if encounterDifficulty == nil {
                self.getEncounter(forParty: party, maxEnemies: maxEnemies, withEnemies: startingEnemies, atDifficulty: nextDifficulty, difficultyLocked: difficultyLocked, bossEncounter: bossEncounter, datasource: datasource, success: success, failure: failure)
            } else {
                failure?(NSError(domain: "Constraints too strict", code: -999, userInfo: nil))
            }
            return
        }
        
        os_log("****** START ******* Budget: %ld / Adjusted: %ld / Party Size: %ld / Difficulty: %@ / Max Enemies: %ld / Locked Enemies: %ld", log: OSLog.default, type: .debug, encounterXPBudget, adjustedXPBudget, party.members.count, difficulty.rawValue, enemyCount, enemies.count)
        
        var monsterFound = false
        repeat {
            if enemies.count == enemyCount - 1 {
                if let monster = datasource.getMonster(withExperience: adjustedXPBudget) {
                    monsterFound = true
                    os_log("%@ xp: %ld Sources: %@  Env: %@", log: OSLog.default, type: .debug, monster.name ?? "", monster.experiencePoints(),monster.sources ?? "SRD",monster.environment ?? "SRD")
                    enemies.append(EncounterEnemy(monster: monster))
                    adjustedXPBudget = adjustedXPBudget - monster.experiencePoints()
                } else {
                    monsterFound = false
                }
            } else {
                if let monster = datasource.getMonster(withMinExperience: 10, maxExperience: adjustedXPBudget) {
                    monsterFound = true
                    os_log("%@ xp: %ld Sources: %@  Env: %@", log: OSLog.default, type: .debug, monster.name ?? "", monster.experiencePoints(),monster.sources ?? "SRD",monster.environment ?? "SRD")
                    enemies.append(EncounterEnemy(monster: monster))
                    adjustedXPBudget = adjustedXPBudget - monster.experiencePoints()
                } else {
                    monsterFound = false
                }
            }
        } while (adjustedXPBudget > 0) && (enemies.count < enemyCount) && monsterFound
        
        let encounter = Encounter(enemies: enemies)
        encounter.difficultyLocked = difficultyLocked ?? false
        encounter.boss = bossEncounter ?? false
        encounter.generateTreasure()
        os_log("****** END ******* Adjusted XP: %ld", log: OSLog.default, type: .debug, encounter.adjustedExperiencePoints(forPartySize: party.members.count))
        
        success?(encounter)
    }

    func randomize(encounter:Encounter?, for party:Party, maxEnemies:Int, success: ((_ encounter:Encounter) -> Void)?, failure: ((_ error: Error?) -> Void)? ) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Error getting app delegate")}
        self.getEncounter(forParty: party,
                          maxEnemies: maxEnemies,
                          withEnemies: encounter?.enemies.filter({$0.locked == true}),
                          atDifficulty: (encounter?.difficultyLocked ?? false) ? encounter?.difficultyForParty(PartyDataSource.shared.party) : nil,
                          difficultyLocked: encounter?.difficultyLocked,
                          bossEncounter: encounter?.boss,
                          datasource: appdelegate.monsterDataSource,
                          success: success,
                          failure: failure)
    }
    
    func getEncounter(for party:Party, maxEnemies:Int, success: ((_ encounter:Encounter) -> Void)?, failure: ((_ error: Error?) -> Void)? ) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Error getting app delegate")}
        
        self.getEncounter(forParty: party,
                          maxEnemies: maxEnemies,
                          withEnemies: [],
                          atDifficulty: nil,
                          difficultyLocked: nil,
                          bossEncounter: nil,
                          datasource: appdelegate.monsterDataSource,
                          success: success,
                          failure: failure)
    }
    
    func getBossEncounter(for party:Party, success: ((_ encounter:Encounter) -> Void)?, failure: ((_ error: Error?) -> Void)? ) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Error getting app delegate")}
        
        self.getEncounter(forParty: party,
                          maxEnemies: 1,
                          withEnemies: [],
                          atDifficulty: .hard,
                          difficultyLocked: nil,
                          bossEncounter: true,
                          datasource: appdelegate.monsterDataSource,
                          success: success,
                          failure: failure)
    }
}
