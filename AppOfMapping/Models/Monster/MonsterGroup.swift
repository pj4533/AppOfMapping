//
//  File.swift
//  Slaad
//
//  Created by PJ Gray on 5/17/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation

class MonsterGroup : Codable, Equatable {
    static func == (lhs: MonsterGroup, rhs: MonsterGroup) -> Bool {
        if (lhs.groupId != nil) || (rhs.groupId != nil) {
            return (
                (lhs.groupId == rhs.groupId)
            )
        } else {
            return (
                    (lhs.groupType == rhs.groupType) &&
                    (lhs.values?.elementsEqual(rhs.values ?? []) ?? false)
            )
        }
    }
    
    enum GroupType : String, Codable, CaseIterable {
        case custom
        case alignment
        case environment
        case type
        case subtype
    }
    var groupType : GroupType?
    var values : [String]?
    var name : String?
    var groupId : String?
}
