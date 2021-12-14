//
//  RoomDataSource.swift
//  Slaad
//
//  Created by PJ Gray on 6/5/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation

class RoomDataSource {
    
    func randomize(_ room:Room?, for party:Party, success: (() -> Void)?, failure: ((_ error: Error?) -> Void)? ) {
        // rolled above 80
        // room name not locked
        // room not locked
        // no enemies are locked
        // not a boss room
        if (Roll.d100() > 80) && (room?.nameLocked != true) && (room?.roomLocked != true) && (room?.encounter?.enemies.filter({$0.locked == true}).count == 0) && (room?.encounter?.boss != true) {
            let datasource = TrapDataSource()
            datasource.getRandomTrap(success: { (trap) in
                room?.encounter = nil
                room?.trap = trap
                success?()
            }, failure: failure)
        } else {
            let datasource = EncounterDataSource()
            datasource.randomize(encounter: room?.encounter, for: party, maxEnemies: 3, success: { (encounter) in
                room?.trap = nil
                room?.encounter = encounter
                if !(room?.nameLocked == true) && (room?.encounter?.boss ?? false) {
                    room?.name = datasource.getRandomRoomName(forEncounter: encounter)
                }
                success?()
            }, failure: failure)
        }
    }
}
