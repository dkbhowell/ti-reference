//
//  PlayerState.swift
//  TwilightImperiumReference
//
//  Created by Dustin Howell on 8/10/18.
//  Copyright © 2018 Dustin Howell. All rights reserved.
//

import UIKit

class PlayerState {
    
    static var shared: PlayerState = PlayerState(withOwnedTechs: [])
    
    var ownedTechnologies: [Technology]
    
    init(withOwnedTechs techs: [Technology]) {
        self.ownedTechnologies = techs
    }
    
    func meetsPrerequisites(forTech tech: Technology) -> Bool {
        var pres = tech.prerequesite
        for tech in ownedTechnologies {
            let type = tech.type
            if let index = pres.firstIndex(where: { $0 == type }) {
                pres.remove(at: index)
            }
        }
        return pres.isEmpty
    }
    
    func getTechString() -> String {
        let types = ownedTechnologies.map { $0.type }
        let redCount = types.reduce(0) { (result, nextType) -> Int in
            return nextType == .red ? result + 1 : result
        }
        let yellowCount = types.reduce(0) { return $1 == .yellow ? $0 + 1 : $0 }
        let greenCount = types.filter { $0 == .green }.count
        let blueCount = types.filter { $0 == .blue }.count
        return "B\(blueCount)  R\(redCount)  G\(greenCount)  Y\(yellowCount)"
    }
}
