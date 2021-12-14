//
//  Monster.swift
//  Slaad
//
//  Created by PJ Gray on 5/2/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation

class Monster : Codable, CustomStringConvertible, Equatable {
    static func == (lhs: Monster, rhs: Monster) -> Bool {
        return lhs.name == rhs.name
    }
    
    
    // anything added here needs to change in GM5MonsterDataSource too
    
    var name : String?
    var challengeRating : String?
    var environment: String?
    var fid: String?
    var type: String?
    var subtype: String?
    var alignment: String?
    var size : String?
    var armorClass : Int?
    var armorDesc : String?
    var hitPoints : Int?
    var hitDice : String?
    var speed : String?
    
    // Stats
    var strength : Int?
    var dexterity : Int?
    var constitution : Int?
    var intelligence : Int?
    var wisdom : Int?
    var charisma : Int?
    
    // Saves
    var strengthSave : Int?
    var dexteritySave : Int?
    var constitutionSave : Int?
    var intelligenceSave : Int?
    var wisdomSave : Int?
    var charismaSave : Int?
    
    // Skills
    var athletics : Int?
    var acrobatics : Int?
    var sleightOfHand : Int?
    var stealth : Int?
    var arcana : Int?
    var history : Int?
    var investigation : Int?
    var nature : Int?
    var religion : Int?
    var animalHandling : Int?
    var insight : Int?
    var medicine : Int?
    var perception : Int?
    var survival : Int?
    var deception : Int?
    var intimidation : Int?
    var performance : Int?
    var persuasion : Int?
    
    var damageVulnerabilities : String?
    var damageResistances : String?
    var damageImmunities : String?
    var conditionImmunities : String?
    var senses : String?
    var languages : String?
    
    var specialAbilities : [SpecialAbility]?
    var actions : [Action]?
    
    var legendaryDesc : String?
    var legendaryActions : [Action]?
    
    // this is not a very good abstraction -- only used by KFC data
    var sources: String?
    
    func hasAnySavingThrows() -> Bool {
        return (
            (self.strengthSave != nil) ||
            (self.dexteritySave != nil) ||
            (self.constitutionSave != nil) ||
            (self.intelligenceSave != nil) ||
            (self.wisdomSave != nil) ||
            (self.charismaSave != nil)
        )
    }
    
    func hasAnySkills() -> Bool {
        return (
            (self.athletics != nil) ||
            (self.acrobatics != nil) ||
            (self.sleightOfHand != nil) ||
            (self.stealth != nil) ||
            (self.arcana != nil) ||
            (self.history != nil) ||
            (self.investigation != nil) ||
            (self.nature != nil) ||
            (self.religion != nil) ||
            (self.animalHandling != nil) ||
            (self.insight != nil) ||
            (self.medicine != nil) ||
            (self.perception != nil) ||
            (self.survival != nil) ||
            (self.deception != nil) ||
            (self.intimidation != nil) ||
            (self.performance != nil) ||
            (self.persuasion != nil)
        )
    }
}
