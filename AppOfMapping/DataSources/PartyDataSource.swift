//
//  PartyDataSource.swift
//  Slaad
//
//  Created by PJ Gray on 5/5/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation

class PartyDataSource {
    
    var party : Party?
    
    static let shared = PartyDataSource()
    
    init() {
        if let partyData = UserDefaults.standard.object(forKey: "Party") as? Data {
            let decoder = JSONDecoder()
            if let party = try? decoder.decode(Party.self, from: partyData) {
                self.party = party
            }
        } else {
            self.party = Party()
            self.addDefaultMember(atLevel: 4)
            self.addDefaultMember(atLevel: 4)
            self.addDefaultMember(atLevel: 4)
            self.addDefaultMember(atLevel: 4)
        }
    }
    
    func removeMember(atIndex index:Int) {
        self.party?.removeMember(atIndex: index)
        self.saveParty()
    }
    
    func addDefaultMember(atLevel level:Int) {
        let pc = PlayerCharacter()
        let defaultClass = Class()
        defaultClass.level = level
        pc.classes = [defaultClass]
        self.addMember(pc)
    }
    
    func addDefaultMember() {
        self.addDefaultMember(atLevel: self.party?.members.first?.totalLevel() ?? 1)
    }
    
    func addMember(_ pc: PlayerCharacter) {
        self.party?.addMember(pc)
        self.saveParty()
    }
    
    func addMember(_ pc: PlayerCharacter, atIndex index: Int) {
        self.party?.addMember(pc, atIndex: index)
        self.saveParty()
    }
    
    func saveParty() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.party) {
            UserDefaults.standard.set(encoded, forKey: "Party")
            UserDefaults.standard.synchronize()
        }
    }
    
    func refreshParty(success: (() -> Void)?, failure: ((_ error: Error?) -> Void)? ) {
        let localMembers = self.party?.members.filter({$0.externalLink == nil})
        let urls = self.party?.members.compactMap({$0.externalLink})
        let party = Party(members: localMembers ?? [])
        
        let group = DispatchGroup()
        let datasource = DNDBeyondDataSource()
        
        for url in urls ?? [] {
            group.enter()
            datasource.getCharacter(with: url, success: { (pc) in
                party.addMember(pc)
                group.leave()
            }) { (error) in
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.party = party
            self.saveParty()
            success?()
        }
    }
    
    func refreshPartyMember(_ character: PlayerCharacter?, success: ((_ character:PlayerCharacter) -> Void)?, failure: ((_ error: Error?) -> Void)? ) {
        guard let url = character?.externalLink else { fatalError("Error") }

        if let character = character {
            var i = 0
            for pc in self.party?.members ?? [] {
                if pc.externalLink == character.externalLink { break }
                i = i + 1
            }
            self.removeMember(atIndex: i)
            let datasource = DNDBeyondDataSource()
            datasource.getCharacter(with: url, success: { (pc) in
                self.addMember(pc, atIndex: i)
                success?(pc)
            }) { (error) in
                failure?(error)
            }

        }
    }
}
