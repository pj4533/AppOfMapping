//
//  Treasure+ArtObjects.swift
//  Slaad
//
//  Created by PJ Gray on 6/4/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation

extension Treasure {
    
    func artObjects25GP() -> String {
        switch Roll.d10() {
        case 1: return "Silver ewer"
        case 2: return "Carved bone statuette"
        case 3: return "Small gold bracelet"
        case 4: return "Cloth-of-gold vestments"
        case 5: return "Black velvet mask stitched with silver thread"
        case 6: return "Copper chalice with silver filigree"
        case 7: return "Pair of engraved bone dice"
        case 8: return "Small mirror set in a painted wooden frame"
        case 9: return "Embroidered silk handkerchief"
        case 10: return "Gold locket with a painted portrait inside"
        default:
            return ""
        }
    }

    func artObjects250GP() -> String {
        switch Roll.d10() {
        case 1: return "Gold ring set with bloodstones"
        case 2: return "Carved ivory statuette"
        case 3: return "Large gold bracelet"
        case 4: return "Silver necklace with a gemstone pendant"
        case 5: return "Bronze crown"
        case 6: return "Silk robe with gold embroidery"
        case 7: return "Large well-made tapestry"
        case 8: return "Brass mug with jade inlay"
        case 9: return "Box of turquoise animal figurines"
        case 10: return "Gold bird cage with electrum filigree"
        default:
            return ""
        }
    }

    func artObjects750GP() -> String {
        switch Roll.d10() {
        case 1: return "Silver chalice set with moonstones"
        case 2: return "Silver-plated steel longsword with jet set in hilt"
        case 3: return "Carved harp of exotic wood with ivory inlay and zircon gems"
        case 4: return "Small gold idol"
        case 5: return "Gold dragon comb set with red garnets as eyes"
        case 6: return "Bottle stopper cork embossed with gold leaf and set with amethysts"
        case 7: return "Ceremonial electrum dagger with a black pearl in the pommel"
        case 8: return "Silver and gold brooch"
        case 9: return "Obsidian statuette with gold fittings and inlay"
        case 10: return "Painted gold war mask"
        default:
            return ""
        }
    }

    func artObjects2500GP() -> String {
        switch Roll.d10() {
        case 1: return "Fine gold chain set with a fire opal"
        case 2: return "Old masterpiece painting"
        case 3: return "Embroidered silk and velvet mantle set with numerous moonstones"
        case 4: return "Platinum bracelet set with a sapphire"
        case 5: return "Embroidered glove set with jewel chips"
        case 6: return "Jeweled anklet"
        case 7: return "Gold music box"
        case 8: return "Gold circlet set with four aquamarines"
        case 9: return "Eye patch with a mock eye set in blue sapphire and moonstone"
        case 10: return "A necklace string of small pink pearls"
        default:
            return ""
        }
    }

    func artObjects7500GP() -> String {
        switch Roll.d8() {
        case 1: return "Jeweled gold crown"
        case 2: return "Jeweled platinum ring"
        case 3: return "Small gold statuette set with rubies"
        case 4: return "Gold cup set with emeralds"
        case 5: return "Gold jewelry box with platinum filigree"
        case 6: return "Painted gold child’s sarcophagus"
        case 7: return "Jade game board with solid gold playing pieces"
        case 8: return "Bejeweled ivory drinking horn with gold filigree"
        default:
            return ""
        }
    }

}
