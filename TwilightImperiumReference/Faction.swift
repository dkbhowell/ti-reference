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
        Faction(name: "The Federation of Sol", resourcePrefix: "sol")
    ]
}
