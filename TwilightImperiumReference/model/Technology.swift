//
//  Technology.swift
//  TwilightImperiumReference
//
//  Created by Dustin Howell on 8/24/18.
//  Copyright © 2018 Dustin Howell. All rights reserved.
//

import Foundation

struct Technology: Equatable, Codable, CustomDebugStringConvertible {
    
    static var allGenerics: [Technology] = {
        return loadGenericTechs()
    }()
    
    let id: String
    let name: String
    let description: String
    let prerequisites: [TechnologyType]
    let type: TechnologyType
    
    var debugDescription: String {
        return name
    }
    
    var prereqString: String {
        return prerequisites.map { $0.rawValue }.joined()
    }
    
    static func ==(lhs: Technology, rhs: Technology) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Technology {
    private static func loadGenericTechs() -> [Technology] {
        guard let path = Bundle(for: FactionTableViewController.self).path(forResource: "ti_generic_tech", ofType: "json") else {
            fatalError("No generic tech resource found")
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let jsonResult = try JSONDecoder().decode(TechnologyData.self, from: data)
            return jsonResult.generic_technologies
        } catch {
            fatalError("Failed to Load Technologies Data")
        }
    }
}

enum TechnologyType: String, Codable {
    case blue = "B", yellow = "Y", red = "R", green = "G", unit = "U"
}

struct TechnologyData: Codable {
    let generic_technologies: [Technology]
}
