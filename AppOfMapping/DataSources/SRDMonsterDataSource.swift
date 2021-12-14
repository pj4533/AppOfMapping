//
//  SRDMonsterDataSource.swift
//  Slaad
//
//  Created by PJ Gray on 5/2/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation

class SRDMonsterDataSource : MonsterDataSource {
    static let shared = SRDMonsterDataSource()
    
    private override init() {
        super.init()
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            // This is kinda weird, but leaving it for now.  I load monsters using only the SRD monsters
            // but then load the KFC monsters and use that for environment filters.
            let url = Bundle.main.url(forResource: "5e_srd_monsters", withExtension: "json")!
            let data = try Data(contentsOf: url)
            self.allMonsters = try decoder.decode([Monster].self, from: data)
            self.monsters = self.allMonsters

            let kfcData = try Data(contentsOf: Bundle.main.url(forResource: "kfc_master_monster_list", withExtension: "json")!)
            decoder.keyDecodingStrategy = .useDefaultKeys
            let kfcMonsters = try decoder.decode([Monster].self, from: kfcData)
            for monster in self.monsters {
                let kfcMonster = kfcMonsters.first(where: { (thisMonster) -> Bool in
                    return thisMonster.name == monster.name
                })
                monster.sources = kfcMonster?.sources
                monster.environment = kfcMonster?.environment
            }
        } catch let error {
            fatalError("Error decoding monsters: \(error)")
        }
    }

}
