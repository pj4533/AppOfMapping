//
//  Treasure.swift
//  Slaad
//
//  Created by PJ Gray on 5/10/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation

class Treasure : Codable {
    
    enum Gems : Int, Codable {
        case gems10gp = 10
        case gems50gp = 50
        case gems100gp = 100
        case gems500gp = 500
        case gems1000gp = 1000
        case gems5000gp = 5000
    }

    enum ArtObjects : Int, Codable {
        case art25gp = 25
        case art250gp = 250
        case art750gp = 750
        case art2500gp = 2500
        case art7500gp = 7500
    }

    var cp : Int?
    var sp : Int?
    var ep : Int?
    var gp : Int?
    var pp : Int?
    var gems : [Gems]?
    
    private var internalArtObjects : [ArtObjects]?
    var artObjects : [ArtObjects]? {
        get { return self.internalArtObjects }
        set(newArtObjects) {
            self.internalArtObjects = newArtObjects
            self.artObjectDescriptions = []
            switch self.internalArtObjects?.first ?? .art25gp {
            case .art25gp: for _ in 0..<(self.internalArtObjects?.count ?? 0) { self.artObjectDescriptions?.append(self.artObjects25GP()) }
            case .art250gp: for _ in 0..<(self.internalArtObjects?.count ?? 0) { self.artObjectDescriptions?.append(self.artObjects250GP()) }
            case .art750gp: for _ in 0..<(self.internalArtObjects?.count ?? 0) { self.artObjectDescriptions?.append(self.artObjects750GP()) }
            case .art2500gp: for _ in 0..<(self.internalArtObjects?.count ?? 0) { self.artObjectDescriptions?.append(self.artObjects2500GP()) }
            case .art7500gp: for _ in 0..<(self.internalArtObjects?.count ?? 0) { self.artObjectDescriptions?.append(self.artObjects7500GP()) }
            }
        }
    }
    
    var artObjectDescriptions : [String]?
    var magicItems : [String]?
    
    init(_ cp:Int, sp:Int, ep:Int, gp:Int, pp:Int) {
        self.cp = cp
        self.sp = sp
        self.ep = ep
        self.gp = gp
        self.pp = pp
    }
    
    init(_ monster: Monster, _ isHoard: Bool) {
        
        switch monster.challengeRating {
        case "1/8": self.challenge0to4(isHoard)
        case "1/4": self.challenge0to4(isHoard)
        case "1/2": self.challenge0to4(isHoard)
        case "1": self.challenge0to4(isHoard)
        case "2": self.challenge0to4(isHoard)
        case "3": self.challenge0to4(isHoard)
        case "4": self.challenge0to4(isHoard)
        case "5": self.challenge5to10(isHoard)
        case "6": self.challenge5to10(isHoard)
        case "7": self.challenge5to10(isHoard)
        case "8": self.challenge5to10(isHoard)
        case "9": self.challenge5to10(isHoard)
        case "10": self.challenge5to10(isHoard)
        case "11": self.challenge11to16(isHoard)
        case "12": self.challenge11to16(isHoard)
        case "13": self.challenge11to16(isHoard)
        case "14": self.challenge11to16(isHoard)
        case "15": self.challenge11to16(isHoard)
        case "16": self.challenge11to16(isHoard)
        case "17": self.challenge17Plus(isHoard)
        case "18": self.challenge17Plus(isHoard)
        case "19": self.challenge17Plus(isHoard)
        case "20": self.challenge17Plus(isHoard)
        case "21": self.challenge17Plus(isHoard)
        case "22": self.challenge17Plus(isHoard)
        case "23": self.challenge17Plus(isHoard)
        case "24": self.challenge17Plus(isHoard)
        case "25": self.challenge17Plus(isHoard)
        case "26": self.challenge17Plus(isHoard)
        case "27": self.challenge17Plus(isHoard)
        case "28": self.challenge17Plus(isHoard)
        case "29": self.challenge17Plus(isHoard)
        case "30": self.challenge17Plus(isHoard)
        default: self.challenge0to4(isHoard)
        }

        
    }
    
    private func challenge0to4(_ isHoard: Bool) {
        if isHoard {
            self.cp = (Roll.roll("6d6") ?? 0) * 100
            self.sp = (Roll.roll("3d6") ?? 0) * 100
            self.gp = (Roll.roll("2d6") ?? 0) * 10
            switch Roll.d100() {
            case 7...16: self.gems = Array(repeating: .gems10gp, count: Roll.roll("2d6") ?? 0)
            case 17...26: self.artObjects = Array(repeating: .art25gp, count: Roll.roll("2d4") ?? 0)
            case 27...36: self.gems = Array(repeating: .gems50gp, count: Roll.roll("2d6") ?? 0)
            case 37...44:
                self.gems = Array(repeating: .gems10gp, count: Roll.roll("2d6") ?? 0)
                self.magicItems = self.magicItemsTableA(Roll.d6())
            case 45...52:
                self.artObjects = Array(repeating: .art25gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableA(Roll.d6())
            case 53...60:
                self.gems = Array(repeating: .gems50gp, count: Roll.roll("2d6") ?? 0)
                self.magicItems = self.magicItemsTableA(Roll.d6())
            case 61...65:
                self.gems = Array(repeating: .gems10gp, count: Roll.roll("2d6") ?? 0)
                self.magicItems = self.magicItemsTableB(Roll.d4())
            case 66...70:
                self.artObjects = Array(repeating: .art25gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableB(Roll.d4())
            case 71...75:
                self.gems = Array(repeating: .gems50gp, count: Roll.roll("2d6") ?? 0)
                self.magicItems = self.magicItemsTableB(Roll.d4())
            case 76...78:
                self.gems = Array(repeating: .gems10gp, count: Roll.roll("2d6") ?? 0)
                self.magicItems = self.magicItemsTableC(Roll.d4())
            case 79...80:
                self.artObjects = Array(repeating: .art25gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableC(Roll.d4())
            case 81...85:
                self.gems = Array(repeating: .gems50gp, count: Roll.roll("2d6") ?? 0)
                self.magicItems = self.magicItemsTableC(Roll.d4())
            case 86...92:
                self.artObjects = Array(repeating: .art25gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableF(Roll.d4())
            case 93...97:
                self.gems = Array(repeating: .gems50gp, count: Roll.roll("2d6") ?? 0)
                self.magicItems = self.magicItemsTableF(Roll.d4())
            case 98...99:
                self.artObjects = Array(repeating: .art25gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableG(1)
            case 100:
                self.gems = Array(repeating: .gems50gp, count: Roll.roll("2d6") ?? 0)
                self.magicItems = self.magicItemsTableG(1)
            default:
                return
            }
        } else {
            switch Roll.d100() {
            case 1...30:
                self.cp = Roll.roll("5d6")
            case 31...60:
                self.sp = Roll.roll("4d6")
            case 61...70:
                self.ep = Roll.roll("3d6")
            case 71...95:
                self.gp = Roll.roll("3d6")
            case 96...100:
                self.pp = Roll.roll("1d6")
            default:
                return
            }
        }
    }
    
    private func challenge5to10(_ isHoard: Bool) {
        if isHoard {
            self.cp = (Roll.roll("2d6") ?? 0) * 100
            self.sp = (Roll.roll("2d6") ?? 0) * 1000
            self.gp = (Roll.roll("6d6") ?? 0) * 100
            self.pp = (Roll.roll("3d6") ?? 0) * 10
            switch Roll.d100() {
            case 5...10: self.artObjects = Array(repeating: .art25gp, count: Roll.roll("2d4") ?? 0)
            case 11...16: self.gems = Array(repeating: .gems50gp, count: Roll.roll("3d6") ?? 0)
            case 17...22: self.gems = Array(repeating: .gems100gp, count: Roll.roll("3d6") ?? 0)
            case 23...28: self.artObjects = Array(repeating: .art250gp, count: Roll.roll("2d4") ?? 0)
            case 29...32:
                self.artObjects = Array(repeating: .art25gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableA(Roll.d6())
            case 33...36:
                self.gems = Array(repeating: .gems50gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableA(Roll.d6())
            case 37...40:
                self.gems = Array(repeating: .gems100gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableA(Roll.d6())
            case 41...44:
                self.artObjects = Array(repeating: .art250gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableA(Roll.d6())
            case 45...49:
                self.artObjects = Array(repeating: .art25gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableB(Roll.d4())
            case 50...54:
                self.gems = Array(repeating: .gems50gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableB(Roll.d4())
            case 55...59:
                self.gems = Array(repeating: .gems100gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableB(Roll.d4())
            case 60...63:
                self.artObjects = Array(repeating: .art250gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableB(Roll.d4())
            case 64...66:
                self.artObjects = Array(repeating: .art25gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableC(Roll.d4())
            case 67...69:
                self.gems = Array(repeating: .gems50gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableC(Roll.d4())
            case 70...72:
                self.gems = Array(repeating: .gems100gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableC(Roll.d4())
            case 73...74:
                self.artObjects = Array(repeating: .art250gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableC(Roll.d4())
            case 75...76:
                self.artObjects = Array(repeating: .art25gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableD(1)
            case 77...78:
                self.gems = Array(repeating: .gems50gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableD(1)
            case 79:
                self.gems = Array(repeating: .gems100gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableD(1)
            case 80:
                self.artObjects = Array(repeating: .art250gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableD(1)
            case 81...84:
                self.artObjects = Array(repeating: .art25gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableF(Roll.d4())
            case 85...88:
                self.gems = Array(repeating: .gems50gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableF(Roll.d4())
            case 89...91:
                self.gems = Array(repeating: .gems100gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableF(Roll.d4())
            case 92...94:
                self.artObjects = Array(repeating: .art250gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableF(Roll.d4())
            case 95...96:
                self.gems = Array(repeating: .gems100gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableG(Roll.d4())
            case 97...98:
                self.artObjects = Array(repeating: .art250gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableG(Roll.d4())
            case 99:
                self.gems = Array(repeating: .gems100gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableH(1)
            case 100:
                self.artObjects = Array(repeating: .art250gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableH(1)
            default:
                return
            }
        } else {
            switch Roll.d100() {
            case 1...30:
                self.cp = (Roll.roll("4d6") ?? 0) * 100
                self.ep = (Roll.roll("1d6") ?? 0) * 10
            case 31...60:
                self.sp = (Roll.roll("6d6") ?? 0) * 10
                self.gp = (Roll.roll("2d6") ?? 0 ) * 10
            case 61...70:
                self.ep = (Roll.roll("3d6") ?? 0) * 10
                self.gp = (Roll.roll("2d6") ?? 0 ) * 10
            case 71...95:
                self.gp = (Roll.roll("4d6") ?? 0) * 10
            case 96...100:
                self.gp = (Roll.roll("2d6") ?? 0 ) * 10
                self.pp = Roll.roll("3d6")
            default:
                return
            }
        }
    }
    
    private func challenge11to16(_ isHoard: Bool) {
        if isHoard {
            self.gp = (Roll.roll("4d6") ?? 0) * 1000
            self.pp = (Roll.roll("5d6") ?? 0) * 100
            switch Roll.d100() {
            case 4...6: self.artObjects = Array(repeating: .art250gp, count: Roll.roll("2d4") ?? 0)
            case 7...9: self.artObjects = Array(repeating: .art750gp, count: Roll.roll("2d4") ?? 0)
            case 10...12: self.gems = Array(repeating: .gems500gp, count: Roll.roll("3d6") ?? 0)
            case 13...15: self.gems = Array(repeating: .gems1000gp, count: Roll.roll("3d6") ?? 0)
            case 16...19:
                self.artObjects = Array(repeating: .art250gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableA(Roll.d4()) + self.magicItemsTableB(Roll.d6())
            case 20...23:
                self.artObjects = Array(repeating: .art750gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableA(Roll.d4()) + self.magicItemsTableB(Roll.d6())
            case 24...26:
                self.gems = Array(repeating: .gems500gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableA(Roll.d4()) + self.magicItemsTableB(Roll.d6())
            case 27...29:
                self.gems = Array(repeating: .gems1000gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableA(Roll.d4()) + self.magicItemsTableB(Roll.d6())
            case 30...35:
                self.artObjects = Array(repeating: .art250gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableC(Roll.d6())
            case 36...40:
                self.artObjects = Array(repeating: .art750gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableC(Roll.d6())
            case 41...45:
                self.gems = Array(repeating: .gems500gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableC(Roll.d6())
            case 46...50:
                self.gems = Array(repeating: .gems1000gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableC(Roll.d6())
            case 51...54:
                self.artObjects = Array(repeating: .art250gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableD(Roll.d4())
            case 55...58:
                self.artObjects = Array(repeating: .art750gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableD(Roll.d4())
            case 59...62:
                self.gems = Array(repeating: .gems500gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableD(Roll.d4())
            case 63...66:
                self.gems = Array(repeating: .gems1000gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableD(Roll.d4())
            case 67...68:
                self.artObjects = Array(repeating: .art250gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableE(1)
            case 69...70:
                self.artObjects = Array(repeating: .art750gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableE(1)
            case 71...72:
                self.gems = Array(repeating: .gems500gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableE(1)
            case 73...74:
                self.gems = Array(repeating: .gems1000gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableE(1)
            case 75...76:
                self.artObjects = Array(repeating: .art250gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableF(1) + self.magicItemsTableG(Roll.d4())
            case 77...78:
                self.artObjects = Array(repeating: .art750gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableF(1) + self.magicItemsTableG(Roll.d4())
            case 79...80:
                self.gems = Array(repeating: .gems500gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableF(1) + self.magicItemsTableG(Roll.d4())
            case 81...82:
                self.gems = Array(repeating: .gems1000gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableF(1) + self.magicItemsTableG(Roll.d4())
            case 83...85:
                self.artObjects = Array(repeating: .art250gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableH(Roll.d4())
            case 86...88:
                self.artObjects = Array(repeating: .art750gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableH(Roll.d4())
            case 89...90:
                self.gems = Array(repeating: .gems500gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableH(Roll.d4())
            case 91...92:
                self.gems = Array(repeating: .gems1000gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableH(Roll.d4())
            case 93...94:
                self.artObjects = Array(repeating: .art250gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableI(1)
            case 95...96:
                self.artObjects = Array(repeating: .art750gp, count: Roll.roll("2d4") ?? 0)
                self.magicItems = self.magicItemsTableI(1)
            case 97...98:
                self.gems = Array(repeating: .gems500gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableI(1)
            case 99...100:
                self.gems = Array(repeating: .gems1000gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableI(1)
            default:
                return
            }
        } else {
            switch Roll.d100() {
            case 1...20:
                self.sp = (Roll.roll("4d6") ?? 0) * 100
                self.gp = (Roll.roll("1d6") ?? 0 ) * 100
            case 21...35:
                self.ep = (Roll.roll("1d6") ?? 0 ) * 100
                self.gp = (Roll.roll("1d6") ?? 0 ) * 100
            case 36...75:
                self.gp = (Roll.roll("2d6") ?? 0 ) * 100
                self.pp = (Roll.roll("1d6") ?? 0 ) * 10
            case 76...100:
                self.gp = (Roll.roll("2d6") ?? 0 ) * 100
                self.pp = (Roll.roll("2d6") ?? 0 ) * 10
            default:
                return
            }
        }
    }
    
    private func challenge17Plus(_ isHoard: Bool) {
        if isHoard {
            self.gp = (Roll.roll("12d6") ?? 0) * 1000
            self.pp = (Roll.roll("8d6") ?? 0) * 1000
            switch Roll.d100() {
            case 3...5:
                self.gems = Array(repeating: .gems1000gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableC(Roll.d8())
            case 6...8:
                self.artObjects = Array(repeating: .art2500gp, count: Roll.roll("1d10") ?? 0)
                self.magicItems = self.magicItemsTableC(Roll.d8())
            case 9...11:
                self.artObjects = Array(repeating: .art7500gp, count: Roll.roll("1d4") ?? 0)
                self.magicItems = self.magicItemsTableC(Roll.d8())
            case 12...14:
                self.gems = Array(repeating: .gems5000gp, count: Roll.roll("1d8") ?? 0)
                self.magicItems = self.magicItemsTableC(Roll.d8())
            case 15...22:
                self.gems = Array(repeating: .gems1000gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableD(Roll.d6())
            case 23...30:
                self.artObjects = Array(repeating: .art2500gp, count: Roll.roll("1d10") ?? 0)
                self.magicItems = self.magicItemsTableD(Roll.d6())
            case 31...38:
                self.artObjects = Array(repeating: .art7500gp, count: Roll.roll("1d4") ?? 0)
                self.magicItems = self.magicItemsTableD(Roll.d6())
            case 39...46:
                self.gems = Array(repeating: .gems5000gp, count: Roll.roll("1d8") ?? 0)
                self.magicItems = self.magicItemsTableD(Roll.d6())
            case 47...52:
                self.gems = Array(repeating: .gems1000gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableE(Roll.d6())
            case 53...58:
                self.artObjects = Array(repeating: .art2500gp, count: Roll.roll("1d10") ?? 0)
                self.magicItems = self.magicItemsTableE(Roll.d6())
            case 59...63:
                self.artObjects = Array(repeating: .art7500gp, count: Roll.roll("1d4") ?? 0)
                self.magicItems = self.magicItemsTableE(Roll.d6())
            case 64...68:
                self.gems = Array(repeating: .gems5000gp, count: Roll.roll("1d8") ?? 0)
                self.magicItems = self.magicItemsTableE(Roll.d6())
            case 69:
                self.gems = Array(repeating: .gems1000gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableG(Roll.d4())
            case 70:
                self.artObjects = Array(repeating: .art2500gp, count: Roll.roll("1d10") ?? 0)
                self.magicItems = self.magicItemsTableG(Roll.d4())
            case 71:
                self.artObjects = Array(repeating: .art7500gp, count: Roll.roll("1d4") ?? 0)
                self.magicItems = self.magicItemsTableG(Roll.d4())
            case 72:
                self.gems = Array(repeating: .gems5000gp, count: Roll.roll("1d8") ?? 0)
                self.magicItems = self.magicItemsTableG(Roll.d4())
            case 73...74:
                self.gems = Array(repeating: .gems1000gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableH(Roll.d4())
            case 75...76:
                self.artObjects = Array(repeating: .art2500gp, count: Roll.roll("1d10") ?? 0)
                self.magicItems = self.magicItemsTableH(Roll.d4())
            case 77...78:
                self.artObjects = Array(repeating: .art7500gp, count: Roll.roll("1d4") ?? 0)
                self.magicItems = self.magicItemsTableH(Roll.d4())
            case 79...80:
                self.gems = Array(repeating: .gems5000gp, count: Roll.roll("1d8") ?? 0)
                self.magicItems = self.magicItemsTableH(Roll.d4())
            case 81...85:
                self.gems = Array(repeating: .gems1000gp, count: Roll.roll("3d6") ?? 0)
                self.magicItems = self.magicItemsTableI(Roll.d4())
            case 86...90:
                self.artObjects = Array(repeating: .art2500gp, count: Roll.roll("1d10") ?? 0)
                self.magicItems = self.magicItemsTableI(Roll.d4())
            case 91...95:
                self.artObjects = Array(repeating: .art7500gp, count: Roll.roll("1d4") ?? 0)
                self.magicItems = self.magicItemsTableI(Roll.d4())
            case 96...100:
                self.gems = Array(repeating: .gems5000gp, count: Roll.roll("1d8") ?? 0)
                self.magicItems = self.magicItemsTableI(Roll.d4())
            default:
                return
            }
        } else {
            switch Roll.d100() {
            case 1...15:
                self.ep = (Roll.roll("2d6") ?? 0) * 1000
                self.gp = (Roll.roll("8d6") ?? 0 ) * 100
            case 16...55:
                self.gp = (Roll.roll("1d6") ?? 0 ) * 1000
                self.pp = (Roll.roll("1d6") ?? 0 ) * 100
            case 56...100:
                self.gp = (Roll.roll("1d6") ?? 0 ) * 1000
                self.pp = (Roll.roll("2d6") ?? 0 ) * 100
            default:
                return
            }
        }
    }
    
    class func totalGPValue(_ treasure: Treasure?) -> Int {
        let silverAsCP = ((treasure?.sp ?? 0) * 10)
        let electrumAsCP = ((treasure?.ep ?? 0) * 50)
        let goldAsCP = ((treasure?.gp ?? 0) * 100)
        let gemsAsCP = ((treasure?.gems?.map({$0.rawValue}).reduce(0, +) ?? 0) * 100)
        let artAsCP = ((treasure?.artObjects?.map({$0.rawValue}).reduce(0, +) ?? 0) * 100)
        let platinumAsCP = ((treasure?.pp ?? 0) * 1000)
        var totalCP = (treasure?.cp ?? 0) +  silverAsCP + electrumAsCP + goldAsCP + platinumAsCP
        totalCP = totalCP + gemsAsCP + artAsCP
        return Int(totalCP / 100)
    }
}
