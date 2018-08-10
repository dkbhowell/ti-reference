//
//  Faction.swift
//  TwilightImperiumReference
//
//  Created by Dustin Howell on 8/9/18.
//  Copyright © 2018 Dustin Howell. All rights reserved.
//

import Foundation

struct Faction {
    let name: String
    let resourcePrefix: String
}

extension Faction {
    static let factions = [
        Faction(name: "The Yssaril Tribes", resourcePrefix: "yssaril"),
        Faction(name: "The Federation of Sol", resourcePrefix: "sol"),
        Faction(name: "The Arborec", resourcePrefix: "arborec"),
        Faction(name: "The Barony of Letnev", resourcePrefix: "barony"),
        Faction(name: "The Embers of Muaat", resourcePrefix: "embers"),
        Faction(name: "The Ghosts of Creuss", resourcePrefix: "ghosts"),
        Faction(name: "The Emirates of Hacan", resourcePrefix: "hacan"),
        Faction(name: "The Universities of Jol-Nar", resourcePrefix: "jolnar"),
        Faction(name: "The L1Z1X Mindnet", resourcePrefix: "l1z1x"),
        Faction(name: "The Mentak Coalition", resourcePrefix: "mentak"),
        Faction(name: "The Naalu Collective", resourcePrefix: "naalu"),
        Faction(name: "The Nekro Virus", resourcePrefix: "nekro"),
        Faction(name: "The Clan of Saar", resourcePrefix: "saar"),
        Faction(name: "The Winnu", resourcePrefix: "winnu"),
        Faction(name: "The XxCha", resourcePrefix: "xxcha"),
        Faction(name: "The Yin Brotherhood", resourcePrefix: "yin"),
    ]
}
