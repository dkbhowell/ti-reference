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
    let quote: String
    let abilities: [FactionAbility]
    let resourcePrefix: String
    let deviation: Double
    let flagship: Flagship
    let commodities: Int
    var factionTechs: [Technology]
    let startingTechs: [Technology]
    
    enum CodingKeys: String, CodingKey {
        case name
        case quote
        case abilities
        case resourcePrefix = "resource_prefix"
        case deviation
        case flagship
        case commodities
        case factionTechs = "technologies"
        case startingTechs = "starting_tech"
    }
}

extension Faction: CustomDebugStringConvertible {
    var debugDescription: String {
        return name
    }
}

extension Faction: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        quote = try values.decode(String.self, forKey: .quote)
        abilities = try values.decode(Array<FactionAbility>.self, forKey: .abilities)
        resourcePrefix = try values.decode(String.self, forKey: .resourcePrefix)
        deviation = try values.decode(Double.self, forKey: .deviation)
        flagship = try values.decode(Flagship.self, forKey: .flagship)
        commodities = try values.decode(Int.self, forKey: .commodities)
        factionTechs = try values.decode(Array<Technology>.self, forKey: .factionTechs)
        let techIds = try values.decode(Array<String>.self, forKey: .startingTechs)
        startingTechs = Technology.allGenerics.filter { techIds.contains($0.id) }
    }
}

extension Faction: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: CodingKeys.name)
        try container.encode(quote, forKey: CodingKeys.quote)
        try container.encode(abilities, forKey: CodingKeys.abilities)
        try container.encode(resourcePrefix, forKey: CodingKeys.resourcePrefix)
        try container.encode(deviation, forKey: CodingKeys.deviation)
        try container.encode(flagship, forKey: CodingKeys.flagship)
        try container.encode(commodities, forKey: CodingKeys.commodities)
        try container.encode(factionTechs, forKey: CodingKeys.factionTechs)
        let startingTechIds = startingTechs.map { $0.id }
        try container.encode(startingTechIds, forKey: CodingKeys.startingTechs)
    }
}

struct FactionData: Codable {
    let factions: [Faction]
}

struct Flagship: Codable {
    let name: String
    let hitValue: Int
    let numberOfRolls: Int
    let capacity: Int
    let move: Int
    let ability: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case hitValue = "hit_value"
        case numberOfRolls = "number_of_rolls"
        case capacity
        case move
        case ability
    }
}

struct FactionAbility: Codable {
    let name: String
    let description: String
}
