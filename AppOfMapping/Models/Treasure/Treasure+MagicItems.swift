//
//  Treasure+MagicItems.swift
//  Slaad
//
//  Created by PJ Gray on 6/4/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation

extension Treasure {
    
    func magicItemsTableA(_ times:Int) -> [String] {
        var returnValue : [String] = []
        for _ in 0..<times { returnValue.append(self.magicItemTableA()) }
        return returnValue
    }

    func magicItemsTableB(_ times:Int) -> [String] {
        var returnValue : [String] = []
        for _ in 0..<times { returnValue.append(self.magicItemTableB()) }
        return returnValue
    }
    
    func magicItemsTableC(_ times:Int) -> [String] {
        var returnValue : [String] = []
        for _ in 0..<times { returnValue.append(self.magicItemTableC()) }
        return returnValue
    }
    
    func magicItemsTableD(_ times:Int) -> [String] {
        var returnValue : [String] = []
        for _ in 0..<times { returnValue.append(self.magicItemTableD()) }
        return returnValue
    }
    
    func magicItemsTableE(_ times:Int) -> [String] {
        var returnValue : [String] = []
        for _ in 0..<times { returnValue.append(self.magicItemTableE()) }
        return returnValue
    }
    
    func magicItemsTableF(_ times:Int) -> [String] {
        var returnValue : [String] = []
        for _ in 0..<times { returnValue.append(self.magicItemTableF()) }
        return returnValue
    }
    
    func magicItemsTableG(_ times:Int) -> [String] {
        var returnValue : [String] = []
        for _ in 0..<times { returnValue.append(self.magicItemTableG()) }
        return returnValue
    }
    
    func magicItemsTableH(_ times:Int) -> [String] {
        var returnValue : [String] = []
        for _ in 0..<times { returnValue.append(self.magicItemTableH()) }
        return returnValue
    }
    
    func magicItemsTableI(_ times:Int) -> [String] {
        var returnValue : [String] = []
        for _ in 0..<times { returnValue.append(self.magicItemTableI()) }
        return returnValue
    }

    private func spellScroll(withLevel level:Int) -> String {
        return SRDSpellDataSource.shared.spells.filter({$0.levelInt == level}).randomElement()?.name ?? ""
    }
    
    private func magicItemTableA() -> String {
        switch Roll.d100() {
        case 1...50: return "Potion of healing"
        case 51...60: return "Spell scroll (cantrip) - \(self.spellScroll(withLevel: 0))"
        case 61...70: return "Potion of climbing"
        case 71...90: return "Spell scroll (1st level) - \(self.spellScroll(withLevel: 1))"
        case 91...94: return "Spell scroll (2nd level) - \(self.spellScroll(withLevel: 2))"
        case 95...98: return "Potion of healing (greater)"
        case 99: return "Bag of holding"
        case 100: return "Driftglobe"
        default:
            return ""
        }
    }
    
    private func magicItemTableB() -> String {
        switch Roll.d100() {
        case 1...15: return "Potion of healing (greater)"
        case 16...22: return "Potion of fire breath"
        case 23...29: return "Potion of resistance"
        case 30...34: return "Ammunition, +1"
        case 35...39: return "Potion of animal friendship"
        case 40...44: return "Potion of hill giant strength"
        case 45...49: return "Potion of growth"
        case 50...54: return "Potion of climbing"
        case 55...59: return "Spell scroll (2nd level) - \(self.spellScroll(withLevel: 2))"
        case 60...64: return "Spell scroll (3rd level) - \(self.spellScroll(withLevel: 3))"
        case 65...67: return "Bag of holding"
        case 68...70: return "Keoghtom’s ointment"
        case 71...73: return "Oil of slipperiness"
        case 74...75: return "Dust of disappearance"
        case 76...77: return "Dust of dryness"
        case 78...79: return "Dust of sneezing and choking"
        case 80...81: return "Elemental gem"
        case 82...83: return "Philter of love"
        case 84: return "Alchemy jug"
        case 85: return "Cap of water breathing"
        case 86: return "Cloak of the manta ray"
        case 87: return "Driftglobe"
        case 88: return "Goggles of night"
        case 89: return "Helm of comprehending languages"
        case 90: return "Immovable rod"
        case 91: return "Lantern of revealing"
        case 92: return "Mariner’s armor"
        case 93: return "Mithral armor"
        case 94: return "Potion of poison"
        case 95: return "Ring of swimming"
        case 96: return "Robe of useful items"
        case 97: return "Rope of climbing"
        case 98: return "Saddle of the cavalier"
        case 99: return "Wand of magic detection"
        case 100: return "Wand of secrets"
        default:
            return ""
        }
    }

    private func magicItemTableC() -> String {
        switch Roll.d100() {
        case 1...15: return "Potion of healing (superior)"
        case 16...22: return "Spell scroll (4th level) - \(self.spellScroll(withLevel: 4))"
        case 23...27: return "Ammunition, +2"
        case 28...32: return "Potion of clairvoyance"
        case 33...37: return "Potion of diminution"
        case 38...42: return "Potion of gaseous form"
        case 43...47: return "Potion of frost giant strength"
        case 48...52: return "Potion of stone giant strength"
        case 53...57: return "Potion of heroism"
        case 58...62: return "Potion of invulnerability"
        case 63...67: return "Potion of mind reading"
        case 68...72: return "Spell scroll (5th level) - \(self.spellScroll(withLevel: 5))"
        case 73...75: return "Elixir of health"
        case 76...78: return "Oil of etherealness"
        case 79...81: return "Potion of fire giant strength"
        case 82...84: return "Quaal’s feather token"
        case 85...87: return "Scroll of protection"
        case 88...89: return "Bag of beans"
        case 90...91: return "Bead of force"
        case 92: return "Chime of opening"
        case 93: return "Decanter of endless water"
        case 94: return "Eyes of minute seeing"
        case 95: return "Folding boat"
        case 96: return "Heward’s handy haversack"
        case 97: return "Horseshoes of speed"
        case 98: return "Necklace of fireballs"
        case 99: return "Periapt of health"
        case 100: return "Sending stones"
        default:
            return ""
        }
    }

    private func magicItemTableD() -> String {
        switch Roll.d100() {
        case 1...20: return "Potion of healing (supreme)"
        case 21...30: return "Potion of invisibility"
        case 31...40: return "Potion of speed"
        case 41...50: return "Spell scroll (6th level) - \(self.spellScroll(withLevel: 6))"
        case 51...57: return "Spell scroll (7th level) - \(self.spellScroll(withLevel: 7))"
        case 58...62: return "Ammunition, +3"
        case 63...67: return "Oil of sharpness"
        case 68...72: return "Potion of flying"
        case 73...77: return "Potion of cloud giant strength"
        case 78...82: return "Potion of longevity"
        case 83...87: return "Potion of vitality"
        case 88...92: return "Spell scroll (8th level) - \(self.spellScroll(withLevel: 8))"
        case 93...95: return "Horseshoes of a zephyr"
        case 96...98: return "Nolzur’s marvelous pigments"
        case 99: return "Bag of devouring"
        case 100: return "Portable hole"
        default:
            return ""
        }
    }

    private func magicItemTableE() -> String {
        switch Roll.d100() {
        case 1...30: return "Spell scroll (8th level) - \(self.spellScroll(withLevel: 8))"
        case 31...55: return "Potion of storm giant strength"
        case 56...70: return "Potion of healing (supreme)"
        case 71...85: return "Spell scroll (9th level) - \(self.spellScroll(withLevel: 9))"
        case 86...93: return "Universal solvent"
        case 94...98: return "Arrow of slaying"
        case 99...100: return "Sovereign glue"
        default:
            return ""
        }
    }

    private func magicItemTableF() -> String {
        switch Roll.d100() {
        case 1...15: return "Weapon, +1"
        case 16...18: return "Shield, +1"
        case 19...21: return "Sentinel shield"
        case 22...23: return "Amulet of proof against detection and location"
        case 24...25: return "Boots of elvenkind"
        case 26...27: return "Boots of striding and springing"
        case 28...29: return "Bracers of archery"
        case 30...31: return "Brooch of shielding"
        case 32...33: return "Broom of flying"
        case 34...35: return "Cloak of elvenkind"
        case 36...37: return "Cloak of protection"
        case 38...39: return "Gauntlets of ogre power"
        case 40...41: return "Hat of disguise"
        case 42...43: return "Javelin of lightning"
        case 44...45: return "Pearl of power"
        case 46...47: return "Rod of the pact keeper, +1"
        case 48...49: return "Slippers of spider climbing"
        case 50...51: return "Staff of the adder"
        case 52...53: return "Staff of the python"
        case 54...55: return "Sword of vengeance"
        case 56...57: return "Trident of fish command"
        case 58...59: return "Wand of magic missiles"
        case 60...61: return "Wand of the war mage, +1"
        case 62...63: return "Wand of web"
        case 64...65: return "Weapon of warning"
        case 66: return "Adamantine armor (chain mail)"
        case 67: return "Adamantine armor (chain shirt)"
        case 68: return "Adamantine armor (scale mail)"
        case 69: return "Bag of tricks (gray)"
        case 70: return "Bag of tricks (rust)"
        case 71: return "Bag of tricks (tan)"
        case 72: return "Boots of the winterlands"
        case 73: return "Circlet of blasting"
        case 74: return "Deck of illusions"
        case 75: return "Eversmoking bottle"
        case 76: return "Eyes of charming"
        case 77: return "Eyes of the eagle"
        case 78: return "Figurine of wondrous power (silver raven)"
        case 79: return "Gem of brightness"
        case 80: return "Gloves of missile snaring"
        case 81: return "Gloves of swimming and climbing"
        case 82: return "Gloves of thievery"
        case 83: return "Headband of intellect"
        case 84: return "Helm of telepathy"
        case 85: return "Instrument of the bards (Doss lute)"
        case 86: return "Instrument of the bards (Fochlucan bandore)"
        case 87: return "Instrument of the bards (Mac-Fuimidh cittern)"
        case 88: return "Medallion of thoughts"
        case 89: return "Necklace of adaptation"
        case 90: return "Periapt of wound closure"
        case 91: return "Pipes of haunting"
        case 92: return "Pipes of the sewers"
        case 93: return "Ring of jumping"
        case 94: return "Ring of mind shielding"
        case 95: return "Ring of warmth"
        case 96: return "Ring of water walking"
        case 97: return "Quiver of Ehlonna"
        case 98: return "Stone of good luck (luckstone)"
        case 99: return "Wind fan"
        case 100: return "Winged boots"
        default:
            return ""
        }
    }

    private func magicItemTableG() -> String {
        switch Roll.d100() {
        case 1...11: return "Weapon, +2"
        case 12...14:
            switch Roll.d8() {
            case 1: return "Figurine of wondrous power (Bronze griffon)"
            case 2: return "Figurine of wondrous power (Ebony fly)"
            case 3: return "Figurine of wondrous power (Golden lions)"
            case 4: return "Figurine of wondrous power (Ivory goats)"
            case 5: return "Figurine of wondrous power (Marble elephant)"
            case 6...7: return "Figurine of wondrous power (Onyx dog)"
            case 8: return "Figurine of wondrous power (Serpentine owl)"
            default: return ""
            }
        case 15: return "Adamantine armor (breastplate)"
        case 16: return "Adamantine armor (splint)"
        case 17: return "Amulet of health"
        case 18: return "Armor of vulnerability"
        case 19: return "Arrow-catching shield"
        case 20: return "Belt of dwarvenkind"
        case 21: return "Belt of hill giant strength"
        case 22: return "Berserker axe"
        case 23: return "Boots of levitation"
        case 24: return "Boots of speed"
        case 25: return "Bowl of commanding water elementals"
        case 26: return "Bracers of defense"
        case 27: return "Brazier of commanding fire elementals"
        case 28: return "Cape of the mountebank"
        case 29: return "Censer of controlling air elementals"
        case 30: return "Armor, +1 chain mail"
        case 31: return "Armor of resistance (chain mail)"
        case 32: return "Armor, +1 chain shirt"
        case 33: return "Armor of resistance (chain shirt)"
        case 34: return "Cloak of displacement"
        case 35: return "Cloak of the bat"
        case 36: return "Cube of force"
        case 37: return "Daern’s instant fortress"
        case 38: return "Dagger of venom"
        case 39: return "Dimensional shackles"
        case 40: return "Dragon slayer"
        case 41: return "Elven chain"
        case 42: return "Flame tongue"
        case 43: return "Gem of seeing"
        case 44: return "Giant slayer"
        case 45: return "Glamoured studded leather"
        case 46: return "Helm of teleportation"
        case 47: return "Horn of blasting"
        case 48: return "Horn of Valhalla (silver or brass)"
        case 49: return "Instrument of the bards (Canaith mandolin)"
        case 50: return "Instrument of the bards (Cli lyre)"
        case 51: return "Ioun stone (awareness)"
        case 52: return "Ioun stone (protection)"
        case 53: return "Ioun stone (reserve)"
        case 54: return "Ioun stone (sustenance)"
        case 55: return "Iron bands of Bilarro"
        case 56: return "Armor, +1 leather"
        case 57: return "Armor of resistance (leather)"
        case 58: return "Mace of disruption"
        case 59: return "Mace of smiting"
        case 60: return "Mace of terror"
        case 61: return "Mantle of spell resistance"
        case 62: return "Necklace of prayer beads"
        case 63: return "Periapt of proof against poison"
        case 64: return "Ring of animal influence"
        case 65: return "Ring of evasion"
        case 66: return "Ring of feather falling"
        case 67: return "Ring of free action"
        case 68: return "Ring of protection"
        case 69: return "Ring of resistance"
        case 70: return "Ring of spell storing"
        case 71: return "Ring of the ram"
        case 72: return "Ring of X-ray vision"
        case 73: return "Robe of eyes"
        case 74: return "Rod of rulership"
        case 75: return "Rod of the pact keeper, +2"
        case 76: return "Rope of entanglement"
        case 77: return "Armor, +1 scale mail"
        case 78: return "Armor of resistance (scale mail)"
        case 79: return "Shield, +2"
        case 80: return "Shield of missile attraction"
        case 81: return "Staff of charming"
        case 82: return "Staff of healing"
        case 83: return "Staff of swarming insects"
        case 84: return "Staff of the woodlands"
        case 85: return "Staff of withering"
        case 86: return "Stone of controlling earth elementals"
        case 87: return "Sun blade"
        case 88: return "Sword of life stealing"
        case 89: return "Sword of wounding"
        case 90: return "Tentacle rod"
        case 91: return "Vicious weapon"
        case 92: return "Wand of binding"
        case 93: return "Wand of enemy detection"
        case 94: return "Wand of fear"
        case 95: return "Wand of fireballs"
        case 96: return "Wand of lightning bolts"
        case 97: return "Wand of paralysis"
        case 98: return "Wand of the war mage, +2"
        case 99: return "Wand of wonder"
        case 100: return "Wings of flying"
        default:
            return ""
        }
    }

    private func magicItemTableH() -> String {
        switch Roll.d100() {
        case 1...10: return "Weapon, +3"
        case 11...12: return "Amulet of the planes"
        case 13...14: return "Carpet of flying"
        case 15...16: return "Crystal ball (very rare version)"
        case 17...18: return "Ring of regeneration"
        case 19...20: return "Ring of shooting stars"
        case 21...22: return "Ring of telekinesis"
        case 23...24: return "Robe of scintillating colors"
        case 25...26: return "Robe of stars"
        case 27...28: return "Rod of absorption"
        case 29...30: return "Rod of alertness"
        case 31...32: return "Rod of security"
        case 33...34: return "Rod of the pact keeper, +3"
        case 35...36: return "Scimitar of speed"
        case 37...38: return "Shield, +3"
        case 39...40: return "Staff of fire"
        case 41...42: return "Staff of frost"
        case 43...44: return "Staff of power"
        case 45...46: return "Staff of striking"
        case 47...48: return "Staff of thunder and lightning"
        case 49...50: return "Sword of sharpness"
        case 51...52: return "Wand of polymorph"
        case 53...54: return "Wand of the war mage, +3"
        case 55: return "Adamantine armor (half plate)"
        case 56: return "Adamantine armor (plate)"
        case 57: return "Animated shield"
        case 58: return "Belt of fire giant strength"
        case 59: return "Belt of frost giant strength (or stone)"
        case 60: return "Armor, +1 breastplate"
        case 61: return "Armor of resistance (breastplate)"
        case 62: return "Candle of invocation"
        case 63: return "Armor, +2 chain mail"
        case 64: return "Armor, +2 chain shirt"
        case 65: return "Cloak of arachnida"
        case 66: return "Dancing sword"
        case 67: return "Demon armor"
        case 68: return "Dragon scale mail"
        case 69: return "Dwarven plate"
        case 70: return "Dwarven thrower"
        case 71: return "Efreeti bottle"
        case 72: return "Figurine of wondrous power (obsidian steed)"
        case 73: return "Frost brand"
        case 74: return "Helm of brilliance"
        case 75: return "Horn of Valhalla (bronze)"
        case 76: return "Instrument of the bards (Anstruth harp)"
        case 77: return "Ioun stone (absorption)"
        case 78: return "Ioun stone (agility)"
        case 79: return "Ioun stone (fortitude)"
        case 80: return "Ioun stone (insight)"
        case 81: return "Ioun stone (intellect)"
        case 82: return "Ioun stone (leadership)"
        case 83: return "Ioun stone (strength)"
        case 84: return "Armor, +2 leather"
        case 85: return "Manual of bodily health"
        case 86: return "Manual of gainful exercise"
        case 87: return "Manual of golems"
        case 88: return "Manual of quickness of action"
        case 89: return "Mirror of life trapping"
        case 90: return "Nine lives stealer"
        case 91: return "Oathbow"
        case 92: return "Armor, +2 scale mail"
        case 93: return "Spellguard shield"
        case 94: return "Armor, +1 splint"
        case 95: return "Armor of resistance (splint)"
        case 96: return "Armor, +1 studded leather"
        case 97: return "Armor of resistance (studded leather)"
        case 98: return "Tome of clear thought"
        case 99: return "Tome of leadership and influence"
        case 100: return "Tome of understanding"
        default:
            return ""
        }
    }

    private func magicItemTableI() -> String {
        switch Roll.d100() {
        case 1...5: return "Defender"
        case 6...10: return "Hammer of thunderbolts"
        case 11...15: return "Luck blade"
        case 16...20: return "Sword of answering"
        case 21...23: return "Holy avenger"
        case 24...26: return "Ring of djinni summoning"
        case 27...29: return "Ring of invisibility"
        case 30...32: return "Ring of spell turning"
        case 33...35: return "Rod of lordly might"
        case 36...38: return "Staff of the magi"
        case 39...41: return "Vorpal sword"
        case 42...43: return "Belt of cloud giant strength"
        case 44...45: return "Armor, +2 breastplate"
        case 46...47: return "Armor, +3 chain mail"
        case 48...49: return "Armor, +3 chain shirt"
        case 50...51: return "Cloak of invisibility"
        case 52...53: return "Crystal ball (legendary version)"
        case 54...55: return "Armor, +1 half plate"
        case 56...57: return "Iron flask"
        case 58...59: return "Armor, +3 leather"
        case 60...61: return "Armor, +1 plate"
        case 62...63: return "Robe of the archmagi"
        case 64...65: return "Rod of resurrection"
        case 66...67: return "Armor, +1 scale mail"
        case 68...69: return "Scarab of protection"
        case 70...71: return "Armor, +2 splint"
        case 72...73: return "Armor, +2 studded leather"
        case 74...75: return "Well of many worlds"
        case 76:
            switch Roll.d12() {
            case 1...2: return "Armor, +2 half plate"
            case 3...4: return "Armor, +2 plate"
            case 5...6: return "Armor, +3 studded leather"
            case 7...8: return "Armor, +3 breastplate"
            case 9...10: return "Armor, +3 splint"
            case 11: return "Armor, +3 half plate"
            case 12: return "Armor, +3 plate"
            default: return ""
            }
        case 77: return "Apparatus of Kwalish"
        case 78: return "Armor of invulnerability"
        case 79: return "Belt of storm giant strength"
        case 80: return "Cubic gate"
        case 81: return "Deck of many things"
        case 82: return "Efreeti chain"
        case 83: return "Armor of resistance (half plate)"
        case 84: return "Horn of Valhalla (iron)"
        case 85: return "Instrument of the bards (Ollamh harp)"
        case 86: return "Ioun stone (greater absorption)"
        case 87: return "Ioun stone (mastery)"
        case 88: return "Ioun stone (regeneration)"
        case 89: return "Plate armor of etherealness"
        case 90: return "Armor of resistance (plate)"
        case 91: return "Ring of air elemental command"
        case 92: return "Ring of earth elemental command"
        case 93: return "Ring of fire elemental command"
        case 94: return "Ring of three wishes"
        case 95: return "Ring of water elemental command"
        case 96: return "Sphere of annihilation"
        case 97: return "Talisman of pure good"
        case 98: return "Talisman of the sphere"
        case 99: return "Talisman of ultimate evil"
        case 100: return "Tome of the stilled tongue"
        default:
            return ""
        }
    }

}
