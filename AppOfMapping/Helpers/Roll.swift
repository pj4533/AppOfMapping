//
//  Roll.swift
//  Slaad
//
//  Created by PJ Gray on 5/6/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation

struct Roll {

    static func roll(_ rollString:String) -> Int? {
        let diceArray = rollString.split(separator: "d")
        if diceArray.count == 2 {
            let rolls = Int(diceArray[0]) ?? 0
            var returnValue = 0
            for _ in (0..<rolls) {
                switch diceArray[1] {
                case "2": returnValue = returnValue + Roll.d2()
                case "4": returnValue = returnValue + Roll.d4()
                case "6": returnValue = returnValue + Roll.d6()
                case "8": returnValue = returnValue + Roll.d8()
                case "10": returnValue = returnValue + Roll.d10()
                case "12": returnValue = returnValue + Roll.d12()
                case "20": returnValue = returnValue + Roll.d20()
                case "100": returnValue = returnValue + Roll.d100()
                default: continue
                }
            }
            return returnValue
        }
        return nil
    }
    
    static func d(_ dice:Int) -> Int {
        return Int.random(in: 1...dice)
    }
    static func d2() -> Int {
        return self.d(2)
    }
    static func d4() -> Int {
        return self.d(4)
    }
    static func d6() -> Int {
        return self.d(6)
    }
    static func d8() -> Int {
        return self.d(8)
    }
    static func d10() -> Int {
        return self.d(10)
    }
    static func d12() -> Int {
        return self.d(12)
    }
    static func d20() -> Int {
        return self.d(20)
    }
    static func d100() -> Int {
        return self.d(100)
    }
}
