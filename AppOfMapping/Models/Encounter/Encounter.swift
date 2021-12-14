//
//  Encounter.swift
//  Slaad
//
//  Created by PJ Gray on 5/2/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation
import UIKit

class Encounter : Codable, CustomStringConvertible {
    enum Difficulty : String, Codable, CaseIterable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
        case deadly = "Deadly"
    }
    
    private(set) var enemies : [EncounterEnemy]
    var difficultyLocked : Bool = false
    
    var boss : Bool = false
    var treasureHoard : Treasure?
    
    init(enemies: [EncounterEnemy]) {
        self.enemies = enemies
        self.relabelEnemies()
    }

    private func relabelEnemies() {
        self.enemies.forEach({
            if !($0.locked ?? false) {
                $0.label = $0.monster?.name
            }            
        })
        
        let similarEnemies = Dictionary(grouping: self.enemies, by: {$0.label})
        for group in similarEnemies.keys {
            if (similarEnemies[group]?.count ?? 0) > 1 {
                var index = 1
                for enemy in similarEnemies[group] ?? [] {
                    enemy.label = "\(enemy.monster?.name ?? "") \(index)"
                    index = index + 1
                }
            }
        }
    }
    
    func treasure() -> Treasure {
        if self.boss, let treasure = self.treasureHoard {
            return treasure
        }
        
        var cp = 0
        var sp = 0
        var ep = 0
        var gp = 0
        var pp = 0
        for treasure in self.enemies.map({$0.treasure}) {
            cp = cp + (treasure?.cp ?? 0)
            sp = sp + (treasure?.sp ?? 0)
            ep = ep + (treasure?.ep ?? 0)
            gp = gp + (treasure?.gp ?? 0)
            pp = pp + (treasure?.pp ?? 0)
        }

        return Treasure(cp, sp: sp, ep: ep, gp: gp, pp: pp)
    }
    
    func treasureDescription() -> String {
        var treasureArray : [String] = []
        
        if let cp = self.treasure().cp, cp > 0 { treasureArray.append("\(cp) cp")}
        if let sp = self.treasure().sp, sp > 0 { treasureArray.append("\(sp) sp")}
        if let ep = self.treasure().ep, ep > 0 { treasureArray.append("\(ep) ep")}
        if let gp = self.treasure().gp, gp > 0 { treasureArray.append("\(gp) gp")}
        if let pp = self.treasure().pp, pp > 0 { treasureArray.append("\(pp) pp")}
        
        var desc = treasureArray.joined(separator: ", ")
        if self.treasure().artObjects != nil {
            var descriptionArray : [String] = []
            var counts: [String: Int] = [:]
            self.treasure().artObjectDescriptions?.forEach({ counts[$0, default: 0] += 1 })
            for (key,value) in counts {
                descriptionArray.append(value > 1 ? "\(key) x\(value) (\(self.treasure().artObjects?.first?.rawValue ?? 0) gp each)" : "\(key) (\(self.treasure().artObjects?.first?.rawValue ?? 0) gp)")
            }
            
            desc.append("\n\n\(descriptionArray.joined(separator: ", "))")
        }
        if self.treasure().gems != nil {
            desc.append("\n\n\(self.treasure().gems?.first?.rawValue ?? 0) gp gem(s) x\(self.treasure().gems?.count ?? 0)")
        }
        if self.treasure().magicItems != nil {
            var descriptionArray : [String] = []
            var counts: [String: Int] = [:]
            self.treasure().magicItems?.forEach({ counts[$0, default: 0] += 1 })
            for (key,value) in counts {
                descriptionArray.append(value > 1 ? "\(key) x\(value)" : key)
            }

            desc.append("\n\n\(descriptionArray.joined(separator: ", "))")
        }
        return desc
    }
    
    func addEnemy(_ enemy:EncounterEnemy) {
        self.enemies.append(enemy)
        self.relabelEnemies()
    }
    
    func removeEnemy(_ index:Int) {
        self.enemies.remove(at: index)
        self.relabelEnemies()
    }
    
    func experiencePoints() -> Int {
        return self.enemies.map({$0.monster?.experiencePoints() ?? 0}).reduce(0, +)
    }

    func enemiesDescriptionArray() -> [String] {
        return self.enemiesDescriptionArray(includeSource: false)
    }
    
    func enemiesDescriptionArray(includeSource: Bool) -> [String] {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Error getting app delegate")}

        let enemyNamesArray = self.enemies.map({$0.monster?.name ?? ""})
        let sourcesDict = self.enemies.reduce(into: [String:String?]()) {
            $0[$1.monster?.name] = appdelegate.monsterDataSource.getSourcesForDisplay($1.monster)
        }
        var descriptionArray : [String] = []
        var counts: [String: Int] = [:]
        enemyNamesArray.forEach({ counts[$0, default: 0] += 1 })
        for (key,value) in counts {
            if includeSource {
                var enemyString = value > 1 ? "\(key) x\(value)" : key
                let source = sourcesDict[key] ?? ""
                if let source = source, source.count > 0 {
                    enemyString = enemyString + " (\(source))"
                }
                descriptionArray.append(enemyString)
            } else {
                descriptionArray.append(value > 1 ? "\(key) x\(value)" : key)
            }
        }
        return descriptionArray
    }
    
    func enemiesDescription() -> String {
        return self.enemiesDescriptionArray().sorted().joined(separator: ", ")
    }
    
    func difficultyForParty(_ party: Party?) -> Difficulty {
        guard let party = party else { fatalError("Party not found") }
        switch self.adjustedExperiencePoints(forPartySize: party.members.count) {
        case Int.min..<party.xpThreshhold(withEncounterDifficulty: .medium): return .easy
        case party.xpThreshhold(withEncounterDifficulty: .medium)..<party.xpThreshhold(withEncounterDifficulty: .hard): return .medium
        case party.xpThreshhold(withEncounterDifficulty: .hard)..<party.xpThreshhold(withEncounterDifficulty: .deadly): return .hard
        case party.xpThreshhold(withEncounterDifficulty: .deadly)...Int.max: return .deadly
        default:
            fatalError("error getting difficulty")
        }
    }
    
    func generateTreasure() {
        if self.boss {
            let maxCREnemy = self.enemies.max { (a, b) -> Bool in
                (Int(a.monster?.challengeRating ?? "") ?? 0) < (Int(b.monster?.challengeRating ?? "") ?? 0)
                }
            if let monster = maxCREnemy?.monster {
                self.treasureHoard = Treasure(monster, true)
            }
        } else {
            self.enemies.forEach { (enemy) in
                if let monster = enemy.monster {
                    enemy.treasure = Treasure(monster, false)
                }
            }
        }
    }
}
