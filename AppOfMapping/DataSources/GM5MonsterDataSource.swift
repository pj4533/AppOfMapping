//
//  GM5MonsterDataSource.swift
//  Slaad
//
//  Created by PJ Gray on 5/13/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation
import XMLCoder

class GM5MonsterDataSource : MonsterDataSource {
    enum MonsterSize : String, Codable {
        case tiny = "T"
        case small = "S"
        case medium = "M"
        case large = "L"
        case huge = "H"
        case gargantuan = "G"
        var sizeString: String {
            switch self {
            case .tiny: return "Tiny"
            case .small: return "Small"
            case .medium: return "Medium"
            case .large: return "Large"
            case .huge: return "Huge"
            case .gargantuan: return "Gargantuan"
            }
        }
    }
    private var dataArray : [Data] = []
    init(dataArray: [Data]) throws {
        super.init()
        do {
            for data in dataArray {
                let _ = try self.addMonstersFromData(data)
            }
        } catch let error {
            throw error
        }
    }
    
    func persistAllData() {
        UserDefaults.standard.removeObject(forKey: "XMLData")
        UserDefaults.standard.setValue(self.dataArray, forKey: "XMLData")
        UserDefaults.standard.synchronize()
    }
    
    func addMonstersFromData(_ data: Data) throws -> Int {
        var returnValue = 0
        do {
            let monsters = try self.getMonstersFromData(data)
            for monster in monsters {
                if !self.allMonsters.contains(monster) {
                    self.allMonsters.append(monster)
                    returnValue = returnValue + 1
                }
            }
            self.allMonsters = self.allMonsters.sorted(by: { $0.name ?? "" < $1.name ?? "" })
            self.monsters = self.allMonsters
        } catch let error {
            throw error
        }
        self.dataArray.append(data)
        return returnValue
    }
    
    private func getMonstersFromData(_ data: Data) throws -> [Monster] {
        var monsters : [Monster] = []
        do {
            let decoder = XMLDecoder()
            struct Trait : Codable {
                var name : String?
                var text : [String?]?
            }

            struct XMLAction : Codable {
                var name : String?
                var text : [String?]?
                var attack : [String?]?
            }

            struct XMLMonster : Codable {
                var name : String?
                var cr : String?
                var type : String?
                var alignment : String?
                var size : MonsterSize?
                var ac : String?
                var hp : String?
                var speed : String?
                var str : Int?
                var dex : Int?
                var con : Int?
                var int : Int?
                var wis : Int?
                var cha : Int?
                var save : String?
                var skill : [String?]?
                var vulnerable : String?
                var resist : String?
                var immune : String?
                var conditionImmune : String?
                var senses : String?
                var passive : Int?
                var languages : String?
                var trait : [Trait]?
                var action : [XMLAction]?
                var legendary : [XMLAction]?
            }
            struct Compendium: Codable {
                var monsters: [XMLMonster]?
                enum CodingKeys: String, CodingKey {
                    case monsters = "monster"
                }
            }
            
            let compendium = try decoder.decode(Compendium.self, from: data)
            for xmlmonster in compendium.monsters ?? [] {
                let monster = Monster()
                monster.size = xmlmonster.size?.sizeString
                monster.name = xmlmonster.name
                monster.challengeRating = xmlmonster.cr
                monster.alignment = xmlmonster.alignment
                monster.speed = xmlmonster.speed
                let typeAndSubtype = xmlmonster.type?.split(separator: ",").first
                monster.type = typeAndSubtype?.split(separator: "(").first?.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
                monster.subtype = typeAndSubtype?.split(separator: "(").last?.replacingOccurrences(of: ")", with: "")
                if monster.type == monster.subtype { monster.subtype = nil }
                
                let acArray = xmlmonster.ac?.split(separator: " ")
                monster.armorClass = Int(acArray?.first ?? "") ?? 0
                if xmlmonster.ac?.contains("(") ?? false {
                    monster.armorDesc = xmlmonster.ac?.split(separator: "(").last?.replacingOccurrences(of: ")", with: "")
                }
                
                let hpArray = xmlmonster.hp?.split(separator: " ")
                monster.hitPoints = Int(hpArray?.first ?? "") ?? 0
                if xmlmonster.hp?.contains("(") ?? false {
                    monster.hitDice = xmlmonster.hp?.split(separator: "(").last?.replacingOccurrences(of: ")", with: "")
                }

                monster.strength = xmlmonster.str
                monster.dexterity = xmlmonster.dex
                monster.constitution = xmlmonster.con
                monster.intelligence = xmlmonster.int
                monster.wisdom = xmlmonster.wis
                monster.charisma = xmlmonster.cha
                
                if let saves = xmlmonster.save {
                    let saveArray = saves.split(separator: ",")
                    for save in saveArray {
                        let saveValue : Int = Int(String(save.split(separator: "+").last ?? "")) ?? 0
                        if save.contains("Str") { monster.strengthSave = saveValue }
                        if save.contains("Dex") { monster.dexteritySave = saveValue }
                        if save.contains("Con") { monster.constitutionSave = saveValue }
                        if save.contains("Int") { monster.intelligenceSave = saveValue }
                        if save.contains("Wis") { monster.wisdomSave = saveValue }
                        if save.contains("Cha") { monster.charismaSave = saveValue }
                    }
                }
                
                if let skills = xmlmonster.skill {
                    for skillEntry in skills {
                        if let skillArray = skillEntry?.split(separator: ",") {
                            for skill in skillArray {
                                let skillValue : Int = Int(String(skill.split(separator: "+").last ?? "")) ?? 0
                                if skill.contains("Athletics") { monster.athletics = skillValue }
                                if skill.contains("Acrobatics") { monster.acrobatics = skillValue }
                                if skill.contains("Sleight Of Hand") { monster.sleightOfHand = skillValue }
                                if skill.contains("Stealth") { monster.stealth = skillValue }
                                if skill.contains("Arcana") { monster.arcana = skillValue }
                                if skill.contains("History") { monster.history = skillValue }
                                if skill.contains("Investigation") { monster.investigation = skillValue }
                                if skill.contains("Nature") { monster.nature = skillValue }
                                if skill.contains("Religion") { monster.religion = skillValue }
                                if skill.contains("Animal Handling") { monster.animalHandling = skillValue }
                                if skill.contains("Insight") { monster.insight = skillValue }
                                if skill.contains("Medicine") { monster.medicine = skillValue }
                                if skill.contains("Perception") { monster.perception = skillValue }
                                if skill.contains("Survival") { monster.survival = skillValue }
                                if skill.contains("Deception") { monster.deception = skillValue }
                                if skill.contains("Intimidation") { monster.intimidation = skillValue }
                                if skill.contains("Performance") { monster.performance = skillValue }
                                if skill.contains("Persuasion") { monster.persuasion = skillValue }
                            }
                        }
                    }
                }

                monster.damageVulnerabilities = xmlmonster.vulnerable
                monster.damageImmunities = xmlmonster.immune
                monster.damageResistances = xmlmonster.resist
                monster.conditionImmunities = xmlmonster.conditionImmune
                
                monster.senses = xmlmonster.senses
                if let passive = xmlmonster.passive {
                    let passivePerception = "passive Perception \(passive)"
                    if let senses = monster.senses {
                        monster.senses = "\(senses), \(passivePerception)"
                    } else {
                        monster.senses = passivePerception
                    }
                }
                monster.languages = xmlmonster.languages

                var abilities : [SpecialAbility]? = nil
                if (xmlmonster.trait != nil) {
                    abilities = []
                }
                for trait in xmlmonster.trait ?? [] {
                    let ability = SpecialAbility()
                    ability.name = trait.name
                    ability.desc = trait.text?.map({$0 ?? ""}).joined(separator: "\n")
                    abilities?.append(ability)
                }
                monster.specialAbilities = abilities

                var actions : [Action]? = nil
                if (xmlmonster.action != nil) {
                    actions = []
                }
                for xmlaction in xmlmonster.action ?? [] {
                    let action = Action()
                    action.name = xmlaction.name
                    action.desc = xmlaction.text?.map({$0 ?? ""}).joined(separator: "\n")
                    for attack in xmlaction.attack ?? [] {
                        let attackArray = attack?.split(separator: "|")
                        if attackArray?.count == 3 {
                            action.attackBonus = Int(String(attackArray?[1] ?? "")) ?? 0
                            action.damageDice = String(attackArray?[2] ?? "")
                        }
                    }
                    actions?.append(action)
                }
                monster.actions = actions

                var legendaryActions : [Action]? = nil
                if (xmlmonster.legendary != nil) {
                    legendaryActions = []
                }
                for xmlaction in xmlmonster.legendary ?? [] {
                    let action = Action()
                    action.name = xmlaction.name
                    action.desc = xmlaction.text?.map({$0 ?? ""}).joined(separator: "\n")
                    for attack in xmlaction.attack ?? [] {
                        let attackArray = attack?.split(separator: "|")
                        if attackArray?.count == 3 {
                            action.attackBonus = Int(String(attackArray?[1] ?? "")) ?? 0
                            action.damageDice = String(attackArray?[2] ?? "")
                        }
                    }
                    legendaryActions?.append(action)
                }
                monster.legendaryActions = legendaryActions

                
                monsters.append(monster)
            }
            
            let jsondecoder = JSONDecoder()
            let kfcData = try Data(contentsOf: Bundle.main.url(forResource: "kfc_master_monster_list", withExtension: "json")!)
            let kfcMonsters = try jsondecoder.decode([Monster].self, from: kfcData)
            for monster in monsters {
                let kfcMonster = kfcMonsters.first(where: { (thisMonster) -> Bool in
                    return thisMonster.name == monster.name
                })
                monster.sources = kfcMonster?.sources
                monster.environment = kfcMonster?.environment
            }
        } catch let error {
            throw error
        }
        return monsters
    }
}
