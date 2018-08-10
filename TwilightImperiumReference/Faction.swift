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

struct Technology {
    let name: String
    let description: String
    let prerequesite: [TechnologyType]
    let type: TechnologyType
}

enum TechnologyType {
    case blue, yellow, red, green
}

extension Technology {
    
    static let allGenerics: [Technology] = Technology.blue.allBlues + Technology.green.allGreens + Technology.yellow.allYellows + Technology.red.allReds
    
    struct blue {
        static let antiMass = Technology(name: "Anti-Mass Deflectors", description: "Your ships can move into and through asteroid fields.\n\n When other players' units use SPACE CANNON against your units, apply -1 to the result of each die roll.", prerequesite: [], type: .blue)
        static let gravityDrive = Technology(name: "Gravity Drive", description: "After you activate a system, apply +1 to the move value of 1 of your ships during this tactical action.", prerequesite: [.blue], type: .blue)
        static let fleetLogistics = Technology(name: "Fleet Logistics", description: "During each of your turns of the action phase, you may perform 2 actions instead of 1", prerequesite: [.blue, .blue], type: .blue)
        
        static let lightwaveDeflectors = Technology(name: "Light/Wave Deflector", description: "Your ships can move through systems that contain other players ships", prerequesite: [.blue, .blue, .blue], type: .blue)
        
        static let allBlues = [
            Technology.blue.antiMass,
            Technology.blue.gravityDrive,
            Technology.blue.fleetLogistics,
            Technology.blue.lightwaveDeflectors
        ]
    }
    
    struct green {
        static let neuralMotivator = Technology(name: "Neural Motivator", description: "During the status phase, draw 2 action cards instead of 1", prerequesite: [], type: .green)
        static let dacxiveAnimators = Technology(name: "Dacxive Animators", description: "After you win a ground combat, you may place 1 infantry from your reinforcements on that planet.", prerequesite: [.green], type: .green)
        static let hyperMetabolism = Technology(name: "Hyper Metabolism", description: "During the status phase, gain 2 command tokens instead of 1", prerequesite: [.green, .green], type: .green)
        static let x89BacterialWeapon = Technology(name: "X-89 Bacterial Weapon", description: "Action: Exhaust this card and choose 1 planet in a system that contains 1 or more of your ships that have BOMBARDMENT; destroy all infantry on that planet", prerequesite: [.green, .green, .green], type: .green)
        static let allGreens = [
            Technology.green.neuralMotivator,
            Technology.green.dacxiveAnimators,
            Technology.green.hyperMetabolism,
            Technology.green.x89BacterialWeapon
        ]
    }
    struct yellow {
        static let sarweenTools = Technology(name: "Sarween Tools", description: "When 1 or more of your units use production, reduce the combined cost of the produced units by 1", prerequesite: [], type: .yellow)
        static let gravitonLaser = Technology(name: "Graviton Laser System", description: "You may exhaust this card before 1 or more of your units use SPACE CANNON; hits produced by those units must be assigned to non-fighter ships if able", prerequesite: [.yellow], type: .yellow)
        static let transitDiodes = Technology(name: "Transit Diodes", description: "You may exhaust this card at the start of your turn during the action phase; remove up to 4 of your ground forces from the game board and place them on 1 or more planets you control", prerequesite: [.yellow, .yellow], type: .yellow)
        static let integratedEconomy = Technology(name: "Integrated Economy", description: "After you gain control of a planet, you may produce any number of units on that planet that have a combined cost equal to or less than that planet's resource value", prerequesite: [.yellow, .yellow, .yellow], type: .yellow)
        static let allYellows = [
            Technology.yellow.sarweenTools,
            Technology.yellow.gravitonLaser,
            Technology.yellow.transitDiodes,
            Technology.yellow.integratedEconomy
        ]
    }
    struct red {
        static let plasmaScoring = Technology(name: "Plasma Scoring", description: "When 1 or more of your units use BOMBARDMENT or SPACE CANNON, 1 of those units may roll 1 additional die", prerequesite: [], type: .red)
        static let magenDefense = Technology(name: "Magen Defense Grid", description: "You may exhaust this card at the start of a round of ground combat on a planet that contains 1 or more of your units that have PLANETARY SHIELD; your opponent cannon make combat rolls during this combat round", prerequesite: [.red], type: .red)
        static let duraniumArmor = Technology(name: "Duranium Armor", description: "During each combat round, after you assign hits to your units, repair 1 of your damaged units tha did not use SUSTAIN DAMAGE during this combat round", prerequesite: [.red, .red], type: .red)
        static let assaultCannon = Technology(name: "Assault Cannon", description: "At the start of a space combat in a system that contains 3 or more of your non-fighter ships, your opponent must destroy 1 of his non-fighter ships", prerequesite: [.red, .red, .red], type: .red)
        static let allReds = [
            Technology.red.plasmaScoring,
            Technology.red.magenDefense,
            Technology.red.duraniumArmor,
            Technology.red.assaultCannon
        ]
    }
}
