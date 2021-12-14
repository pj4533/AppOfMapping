//
//  DungeonMap.swift
//  Slaad
//
//  Created by PJ Gray on 5/3/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation
import os.log
import CoreGraphics

// this is a model representing a Dungeon
class DungeonMap : Codable {
    var columns : Int = 30
    var rows : Int = 30

    var name : String?
    var nameLocked : Bool?
    
    var dungeonDescription : String?
    
    static var currentNumberRooms : Int = 0
    
    var rooms : [Room] = []
    var hallways : [MapGeometryObject] = []
    var doors : [Door] = []
    
    private var leaves : [Leaf] = []

    init() {
    }
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
    }

    private enum CodingKeys: String, CodingKey {
        case columns
        case rows
        case rooms
        case hallways
        case doors
        case name
        case nameLocked
        case dungeonDescription
    }

    func generateEncounters(success: (() -> Void)?, failure: ((_ error: Error?) -> Void)? ) {
        if let party = PartyDataSource.shared.party {
            let datasource = EncounterDataSource()
            os_log("********************************", log: OSLog.default, type: .debug)
            var startingRoom = true
            let group = DispatchGroup()
            
            for room in self.rooms {
                if room.roomLocked == true { continue }
                room.trap = nil
                room.encounter = nil
                if !startingRoom  && (Roll.d100() > 3) {
                    group.enter()
                    datasource.getEncounter(for: party, maxEnemies: 3, success: { (encounter) in
                        os_log("XP: %ld / AdjustedXP: %ld", log: OSLog.default, type: .debug, encounter.experiencePoints(), encounter.adjustedExperiencePoints(forPartySize: party.members.count))
                        os_log("********************************", log: OSLog.default, type: .debug)
                        room.encounter = encounter
                        room.name = nil
                        group.leave()
                    }, failure: nil)
                } else {
                    room.encounter = Encounter(enemies: [])
                }
                startingRoom = false
            }

            group.notify(queue: DispatchQueue.main) {
                let trapRoom = self.rooms.filter({ $0.shouldBeTrapRoom }).first
                let trapDataSource = TrapDataSource()
                trapDataSource.getRandomTrap(success: { (trap) in
                    trapRoom?.encounter = nil
                    trapRoom?.trap = trap
                }, failure: nil)
                
                let bossRoom = self.rooms.filter({ $0.shouldBeBossRoom }).first
                datasource.getBossEncounter(for: party, success: { (encounter) in
                    os_log("XP: %ld / AdjustedXP: %ld", log: OSLog.default, type: .debug, encounter.experiencePoints(), encounter.adjustedExperiencePoints(forPartySize: party.members.count))
                    os_log("********************************", log: OSLog.default, type: .debug)
                    bossRoom?.encounter = encounter
                    bossRoom?.name = datasource.getRandomRoomName(forEncounter: encounter)
                    bossRoom?.encounter?.boss = true
                }, failure: nil)
                
                
                if !(self.nameLocked ?? false) {
                    self.name = self.getRandomMapName()
                }
                
                let enemy = self.rooms.filter({$0.encounter?.boss == true}).first?.encounter?.enemies.first
                self.dungeonDescription = self.getMapDescriptionWithBossEnemy(enemy)
                success?()
            }
        } else {
            os_log("!!!: No party found, skipping encounter generation", log: OSLog.default, type: .debug)
            failure?(NSError(domain: "No party found, skipping encounter generation", code: -999, userInfo: nil))
        }
    }
    
    func getRandomMapName() -> String? {
        do {
            let dungeonWordsArray = try String(contentsOf: Bundle.main.url(forResource: "dungeon_words", withExtension: "txt")!, encoding: .utf8).split(separator: "\n")
            let adjectiveWordsArray = try String(contentsOf: Bundle.main.url(forResource: "adjective_words", withExtension: "txt")!, encoding: .utf8).split(separator: "\n")
            let nounWordsArray = try String(contentsOf: Bundle.main.url(forResource: "noun_words", withExtension: "txt")!, encoding: .utf8).split(separator: "\n")
            return "The \(dungeonWordsArray.randomElement()?.capitalized ?? "") of \(adjectiveWordsArray.randomElement()?.capitalized ?? "") \(nounWordsArray.randomElement()?.capitalized ?? "")"
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }

    func generateMap() {
        self.rooms = [];
        self.hallways = [];
        self.leaves = [];
        
        DungeonMap.currentNumberRooms = 0
        
        let maxLeafSize = 20
        
        // First, create leaf to be root of all leaves
        let root = Leaf(X: 0, Y: 0, W: self.columns, H: self.rows);
        self.leaves.append(root)
        
        var didSplit:Bool = true;
        
        // Loop through every Leaf in array until no more can be split
        while (didSplit) {
            didSplit = false;
            for leaf in self.leaves {
                if leaf.leftChild == nil && leaf.rightChild == nil { // If not split
                    // If this leaf is too big, or 75% chance
                    if leaf.width > maxLeafSize || leaf.height > maxLeafSize || Int.random(in: 0..<100) > 25 {
                        if (leaf.split()) { // split the leaf
                            // If split worked, push child leaves into array
                            self.leaves.append(leaf.leftChild!)
                            self.leaves.append(leaf.rightChild!)
                            didSplit = true
                        }
                    }
                }
            }
        }
        // Next, iterate through each leaf and create room in each one
        root.createRooms()
        
        for leaf in self.leaves {
            // Then draw room and hallway (if there is one)
            if leaf.room != nil {
                self.drawRoom(room: leaf.room!)
            }
            if leaf.hallways.isEmpty != true {
                self.drawHall(hallRect: leaf.hallways)
            }
        }
        
    }
    
    // Is "Draw" right here?
    //
    // Get rooms and append them to an array to be drawn in
    private func drawRoom(room: Room) {
        self.rooms.append(room)
        room.roomId = self.rooms.count
    }
    
    // Get hallways and append them to an array to be drawn in
    private func drawHall(hallRect: [MapGeometryObject]) {
        for rect in hallRect {
            self.hallways.append(rect)
        }
    }

}
