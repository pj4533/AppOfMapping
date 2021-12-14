//
//  SRDSpellDataSource.swift
//  Slaad
//
//  Created by PJ Gray on 6/4/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation

class SRDSpellDataSource {
    
    var spells : [Spell] = []
    
    static let shared = SRDSpellDataSource()
    
    init() {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            // This is kinda weird, but leaving it for now.  I load monsters using only the SRD monsters
            // but then load the KFC monsters and use that for environment filters.
            let url = Bundle.main.url(forResource: "5e_srd_spells", withExtension: "json")!
            let data = try Data(contentsOf: url)
            self.spells = try decoder.decode([Spell].self, from: data)
        } catch let error {
            fatalError("Error decoding spells: \(error)")
        }
    }
    
}
