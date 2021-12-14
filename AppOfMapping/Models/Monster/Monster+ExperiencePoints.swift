//
//  Monster+ExperiencePoints.swift
//  Slaad
//
//  Created by PJ Gray on 5/2/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation

extension Monster {
    func experiencePoints() -> Int {
        switch self.challengeRating {
        case "1/8": return 25
        case "1/4": return 50
        case "1/2": return 100
        case "1": return 200
        case "2": return 450
        case "3": return 700
        case "4": return 1100
        case "5": return 1800
        case "6": return 2300
        case "7": return 2900
        case "8": return 3900
        case "9": return 5000
        case "10": return 5900
        case "11": return 7200
        case "12": return 8400
        case "13": return 10000
        case "14": return 11500
        case "15": return 13000
        case "16": return 15000
        case "17": return 18000
        case "18": return 20000
        case "19": return 22000
        case "20": return 25000
        case "21": return 33000
        case "22": return 41000
        case "23": return 50000
        case "24": return 62000
        case "25": return 75000
        case "26": return 90000
        case "27": return 105000
        case "28": return 120000
        case "29": return 135000
        case "30": return 155000
        default: return 0
        }
    }
    
    class func highestCRUnderXPBudget(_ xpBudget: Int) -> String {
        switch xpBudget {
        case 0...49: return "1/8"
        case 50...99: return "1/4"
        case 100...199: return "1/2"
        case 200...449: return "1"
        case 450...699: return "2"
        case 700...1099: return "3"
        case 1100...1799: return "4"
        case 1800...2299: return "5"
        case 2300...2899: return "6"
        case 2900...3899: return "7"
        case 3900...4999: return "8"
        case 5000...5899: return "9"
        case 5900...7199: return "10"
        case 7200...8399: return "11"
        case 8400...9999: return "12"
        case 10000...11499: return "13"
        case 11500...12999: return "14"
        case 13000...14999: return "15"
        case 15000...17999: return "16"
        case 18000...19999: return "17"
        case 20000...21999: return "18"
        case 22000...24999: return "19"
        case 25000...32999: return "20"
        case 33000...40999: return "21"
        case 41000...49999: return "22"
        case 50000...61999: return "23"
        case 62000...74999: return "24"
        case 75000...89999: return "25"
        case 90000...104999: return "26"
        case 105000...119999: return "27"
        case 120000...134999: return "28"
        case 135000...154999: return "29"
        case 155000...Int.max: return "30"
        default: return "1"
        }

    }

    class func xpBudgetByCR(_ cr: String) -> Int {
        let multiplyFactor = 1.1111111111111        
        switch cr {
        case "1/8": return Int(round(25.0 * multiplyFactor))
        case "1/4": return Int(round(50.0 * multiplyFactor))
        case "1/2": return Int(round(100.0 * multiplyFactor))
        case "1": return Int(round(200.0 * multiplyFactor))
        case "2": return Int(round(450.0 * multiplyFactor))
        case "3": return Int(round(700.0 * multiplyFactor))
        case "4": return Int(round(1100.0 * multiplyFactor))
        case "5": return Int(round(1800.0 * multiplyFactor))
        case "6": return Int(round(2300.0 * multiplyFactor))
        case "7": return Int(round(2900.0 * multiplyFactor))
        case "8": return Int(round(3900.0 * multiplyFactor))
        case "9": return Int(round(5000.0 * multiplyFactor))
        case "10": return Int(round(5900.0 * multiplyFactor))
        case "11": return Int(round(7200.0 * multiplyFactor))
        case "12": return Int(round(8400.0 * multiplyFactor))
        case "13": return Int(round(10000.0 * multiplyFactor))
        case "14": return Int(round(11500.0 * multiplyFactor))
        case "15": return Int(round(13000.0 * multiplyFactor))
        case "16": return Int(round(15000.0 * multiplyFactor))
        case "17": return Int(round(18000.0 * multiplyFactor))
        case "18": return Int(round(20000.0 * multiplyFactor))
        case "19": return Int(round(22000.0 * multiplyFactor))
        case "20": return Int(round(25000.0 * multiplyFactor))
        case "21": return Int(round(33000.0 * multiplyFactor))
        case "22": return Int(round(41000.0 * multiplyFactor))
        case "23": return Int(round(50000.0 * multiplyFactor))
        case "24": return Int(round(62000.0 * multiplyFactor))
        case "25": return Int(round(75000.0 * multiplyFactor))
        case "26": return Int(round(90000.0 * multiplyFactor))
        case "27": return Int(round(105000.0 * multiplyFactor))
        case "28": return Int(round(120000.0 * multiplyFactor))
        case "29": return Int(round(135000.0 * multiplyFactor))
        case "30": return Int(round(155000.0 * multiplyFactor))
        default: return 0
        }
    }

}
