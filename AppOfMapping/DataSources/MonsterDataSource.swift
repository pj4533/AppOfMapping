//
//  MonsterDataSource.swift
//  Slaad
//
//  Created by PJ Gray on 5/2/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation
import os.log

class MonsterDataSource {
    
    enum Source : String {
        case basic = "basic."
        case strahd = "strahd."
        case fiveef = "5ef."
        case hoard = "hoard."
        case hoardsup = "hoardsup."
        case mm = "mm."
        case mmod = "mmod."
        case mad = "mad."
        case neb = "neb."
        case abyss = "abyss."
        case phb = "phb."
        case thulecs = "thulecs."
        case thulegm = "thulegm."
        case apoc = "apoc."
        case apocsup = "apocsup."
        case tiamat = "tiamat."
        case strmking = "strmking."
        case tftyp = "tftyp."
        case tob = "tob."
        case volo = "volo."
        
        var description: String {
            switch self {
            case .basic: return "Basic Rules v1"
            case .strahd: return "Curse of Strahd"
            case .fiveef: return "Fifth Edition Foes"
            case .hoard: return "Hoard of the Dragon Queen"
            case .hoardsup: return "HotDQ supplement"
            case .mm: return "Monster Manual"
            case .mmod: return "Monster Module"
            case .mad: return "Monster-A-Day"
            case .neb: return "Nerzugal's Extended Bestiary"
            case .abyss: return "Out of the Abyss"
            case .phb: return "Player's Handbook"
            case .thulecs: return "Primeval Thule Campaign Setting"
            case .thulegm: return "Primeval Thule Gamemaster's Companion"
            case .apoc: return "Princes of the Apocalypse"
            case .apocsup: return "Princes of the Apocalypse Online Supplement v1.0"
            case .tiamat: return "Rise of Tiamat"
            case .strmking: return "Storm King's Thunder"
            case .tftyp: return "Tales from the Yawning Portal"
            case .tob: return "Tome of Beasts"
            case .volo: return "Volo's Guide to Monsters"
            }
        }
    }
    
    private var groupFilter : [MonsterGroup] = []
    
    var monsters : [Monster] = []
    var allMonsters : [Monster] = []

    init() {
        let customFilters = self.getCustomGroupFilters()
        for group in self.getBuiltInCustomGroups() {
            // cant use normal contains here
            if !customFilters.map({$0.name}).contains(group.name) {
                self.saveCustomGroupFilter(group)
            }
        }
    }
    
    // MARK: Groups
    
    func getSupportedGroups() -> [MonsterGroup] {
        var groups : [MonsterGroup] = []

        let alignments = Array(Set(self.allMonsters.compactMap({$0.alignment?.lowercased()}))).sorted()
        for alignment in alignments {
            let group = MonsterGroup()
            group.groupType = .alignment
            group.values = [alignment]
            groups.append(group)
        }

        let types = Array(Set(self.allMonsters.compactMap({$0.type?.lowercased()}))).sorted()
        for type in types {
            let group = MonsterGroup()
            group.groupType = .type
            group.values = [type]
            groups.append(group)
        }

        let subtypes = Array(Set(self.allMonsters.compactMap({$0.subtype?.lowercased()}).filter({$0 != ""}))).sorted()
        for subtype in subtypes {
            let group = MonsterGroup()
            group.groupType = .subtype
            group.values = [subtype]
            groups.append(group)
        }

        var environmentsSet = Set<String>()
        for environments in self.allMonsters.compactMap({$0.environment}) {
            let environmentsArray = environments.lowercased().split(separator: ",")
            for environment in environmentsArray {
                environmentsSet.insert(String(environment.trimmingCharacters(in: .whitespacesAndNewlines)))
            }
        }
        let allEnvironments = Array(environmentsSet).sorted()
        for environment in allEnvironments {
            let group = MonsterGroup()
            group.groupType = .environment
            group.values = [environment]
            groups.append(group)
        }

        
        groups.append(contentsOf: self.getCustomGroupFilters())

        return groups
    }

    func setGroupFilter(_ groups:[MonsterGroup]) {
        self.groupFilter = groups
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.groupFilter) {
            UserDefaults.standard.set(encoded, forKey: "groupFilter")
            UserDefaults.standard.synchronize()
        }
        self.filter()
    }
    
    func removeGroupFiltersOfType(_ groupType: MonsterGroup.GroupType?) {
        let filteredGroupFilters = self.groupFilter.filter({$0.groupType != groupType})
        self.groupFilter = filteredGroupFilters
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.groupFilter) {
            UserDefaults.standard.set(encoded, forKey: "groupFilter")
            UserDefaults.standard.synchronize()
        }
        self.filter()
    }
    
    func removeGroupFilter(_ group: MonsterGroup) {
        if let index = self.groupFilter.firstIndex(of: group) {
            self.groupFilter.remove(at: index)
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.groupFilter) {
            UserDefaults.standard.set(encoded, forKey: "groupFilter")
            UserDefaults.standard.synchronize()
        }
        self.filter()
    }

    func getGroupFilter() -> [MonsterGroup] {
        return self.groupFilter
    }
    
    func addGroupFilter(_ group: MonsterGroup) {
        self.groupFilter.append(group)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.groupFilter) {
            UserDefaults.standard.set(encoded, forKey: "groupFilter")
            UserDefaults.standard.synchronize()
        }
        self.filter()
    }

    func getBuiltInCustomGroups() -> [MonsterGroup] {
        let goblinWarrens = MonsterGroup()
        goblinWarrens.name = "Goblin Warrens"
        goblinWarrens.groupId = UUID().uuidString
        goblinWarrens.groupType = .custom
        goblinWarrens.values = [
            "Hobgoblin",
            "Goblin",
            "Bugbear",
            "Gnoll"
        ]

        let banditCamp = MonsterGroup()
        banditCamp.name = "Bandit Camp"
        banditCamp.groupId = UUID().uuidString
        banditCamp.groupType = .custom
        banditCamp.values = [
            "Bandit",
            "Bandit Captain",
            "Assassin",
            "Thug",
            "Commoner",
            "Guard",
            "Mage",
            "Scout",
            "Spy",
            "Veteran"
        ]

        return [
            goblinWarrens,
            banditCamp
        ]
    }
    
    func getCustomGroupFilters() -> [MonsterGroup] {
        if let customGroupFilterData = UserDefaults.standard.object(forKey: "customGroupFilters") as? Data {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([MonsterGroup].self, from: customGroupFilterData) {
                return decoded
            }
        }
        return []
    }
    
    func deleteCustomGroupFilter(atIndex index: Int) {
        var customGroupFilters = self.getCustomGroupFilters()
        customGroupFilters.remove(at: index)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(customGroupFilters) {
            UserDefaults.standard.set(encoded, forKey: "customGroupFilters")
            UserDefaults.standard.synchronize()
        }
    }
    
    func saveCustomGroupFilter(_ group: MonsterGroup?) {
        if let group = group {
            var customGroupFilters = self.getCustomGroupFilters()
            if let index = customGroupFilters.firstIndex(of: group) {
                customGroupFilters.remove(at: index)
                customGroupFilters.insert(group, at: index)
            } else {
                customGroupFilters.append(group)
            }
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(customGroupFilters) {
                UserDefaults.standard.set(encoded, forKey: "customGroupFilters")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func filter() {
        self.monsters = self.allMonsters
        
        if (self.getGroupFilter().count > 0) {
            self.monsters = self.monsters.filter({                
                for group in self.getGroupFilter() {
                    // dry this up?
                    if group.groupType == .alignment {
                        if group.values?.contains($0.alignment ?? "") ?? false  { return true }
                    }
                    if group.groupType == .type {
                        if group.values?.contains($0.type ?? "") ?? false  { return true }
                    }
                    if group.groupType == .subtype {
                        if group.values?.contains($0.subtype ?? "") ?? false  { return true }
                    }
                    if group.groupType == .environment {
                        if group.values?.contains($0.environment ?? "") ?? false  { return true }
                    }
                    if group.groupType == .custom {
                        if group.values?.contains($0.name ?? "") ?? false  { return true }
                    }
                }
                return false
            })
        }
    }
    
    func getMonster(named name:String) -> Monster? {
        guard monsters.count > 0 else { fatalError("Monsters Not Loaded")}
        
        return self.monsters.first(where: { (monster) -> Bool in
            return monster.name == name
        })
    }
    
    func getMonster(withExperience experience:Int) -> Monster? {
        var monsters : [Monster] = []
        
        os_log("*** Looking for monster of xp: %ld", log: OSLog.default, type: .debug, experience)

        var delta = 0
        repeat {
            delta = delta + 10
            os_log("*** Filtering between XP %ld and %ld", log: OSLog.default, type: .debug, experience-delta, experience)
            monsters = self.monsters.filter({
                ($0.experiencePoints() > (experience-delta)) && ($0.experiencePoints() < experience) && ($0.challengeRating != "0")
            })
            if (experience-delta < 0) { break }
        } while monsters.count == 0
        
        return monsters.randomElement()
    }
    
    func getMonster(withMinExperience minExperience:Int, maxExperience:Int) -> Monster? {
        return self.monsters.filter({
            ($0.experiencePoints() > minExperience) && ($0.experiencePoints() < maxExperience) && ($0.challengeRating != "0")
        }).randomElement()
    }
    
    func getSourcesForDisplay(_ monster:Monster?) -> String? {
        if let monster = monster {
            var returnArray : [String] = []
            let sourcesArray = monster.sources?.split(separator: ",")
            for source in sourcesArray ?? [] {
                let thisSourceArray = source.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ":")
                for activeSource in [Source.mm,Source.volo] {
                    if thisSourceArray.first?.trimmingCharacters(in: .whitespacesAndNewlines) == activeSource.description {
                        returnArray.append("\(activeSource.rawValue.replacingOccurrences(of: ".", with: "")) \(thisSourceArray.last?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")")
                    }
                }
            }
            return returnArray.joined(separator: ",")
        }
        return nil
    }
    
}
