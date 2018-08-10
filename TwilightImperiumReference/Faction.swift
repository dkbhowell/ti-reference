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
    let deviation: Double
    var factionTechs: [Technology]
    let startingTechs: [Technology]
}

extension Faction {
    static let factions = [
        Faction(name: "The Yssaril Tribes", resourcePrefix: "yssaril", deviation: 0.12, factionTechs: Technology.factionSpecific.yssaril.both, startingTechs: [Technology.green.neuralMotivator]),
        Faction(name: "The Federation of Sol", resourcePrefix: "sol", deviation: 1.87, factionTechs: Technology.factionSpecific.sol.both, startingTechs: [Technology.green.neuralMotivator, Technology.blue.antiMass]),
        Faction(name: "The Arborec", resourcePrefix: "arborec", deviation: -0.78, factionTechs: Technology.factionSpecific.arborec.both, startingTechs: [Technology.red.magenDefense]),
        Faction(name: "The Barony of Letnev", resourcePrefix: "barony", deviation: -0.69, factionTechs: Technology.factionSpecific.barony.both, startingTechs: [Technology.red.plasmaScoring, Technology.blue.antiMass]),
        Faction(name: "The Embers of Muaat", resourcePrefix: "embers", deviation: -1.04, factionTechs: Technology.factionSpecific.muaat.both, startingTechs: [Technology.red.plasmaScoring]),
        Faction(name: "The Ghosts of Creuss", resourcePrefix: "ghosts", deviation: -0.03, factionTechs: Technology.factionSpecific.ghosts.both, startingTechs: [Technology.blue.gravityDrive]),
        Faction(name: "The Emirates of Hacan", resourcePrefix: "hacan", deviation: 1.02, factionTechs: Technology.factionSpecific.hacan.both, startingTechs: [Technology.yellow.sarweenTools, Technology.blue.antiMass]),
        Faction(name: "The Universities of Jol-Nar", resourcePrefix: "jolnar", deviation: 1.90, factionTechs: Technology.factionSpecific.jolnar.both, startingTechs: [Technology.red.plasmaScoring, Technology.blue.antiMass, Technology.yellow.sarweenTools, Technology.green.neuralMotivator]),
        Faction(name: "The L1Z1X Mindnet", resourcePrefix: "l1z1x", deviation: -0.08, factionTechs: Technology.factionSpecific.l1z1x.both, startingTechs: [Technology.green.neuralMotivator, Technology.red.plasmaScoring]),
        Faction(name: "The Mentak Coalition", resourcePrefix: "mentak", deviation: -0.42, factionTechs: Technology.factionSpecific.mentak.both, startingTechs: [Technology.yellow.sarweenTools, Technology.red.plasmaScoring]),
        Faction(name: "The Naalu Collective", resourcePrefix: "naalu", deviation: 0.20, factionTechs: Technology.factionSpecific.naalu.both, startingTechs: [Technology.yellow.sarweenTools, Technology.green.neuralMotivator]),
        Faction(name: "The Nekro Virus", resourcePrefix: "nekro", deviation: -0.36, factionTechs: Technology.factionSpecific.nekro.both, startingTechs: [Technology.green.dacxiveAnimators]),
        Faction(name: "The Clan of Saar", resourcePrefix: "saar", deviation: 1.12, factionTechs: Technology.factionSpecific.saar.both, startingTechs: [Technology.blue.antiMass]),
        Faction(name: "The Winnu", resourcePrefix: "winnu", deviation: 0.17, factionTechs: Technology.factionSpecific.winnu.both, startingTechs: [Technology.yellow.sarweenTools]),
        Faction(name: "The XxCha", resourcePrefix: "xxcha", deviation: -1.26, factionTechs: Technology.factionSpecific.xxcha.both, startingTechs: [Technology.yellow.gravitonLaser]),
        Faction(name: "The Yin Brotherhood", resourcePrefix: "yin", deviation: -0.19, factionTechs: Technology.factionSpecific.yin.both, startingTechs: [Technology.yellow.sarweenTools]),
        Faction(name: "The Sardakk N'orr", resourcePrefix: "sardakk", deviation: -1.56, factionTechs: Technology.factionSpecific.sardakk.both, startingTechs: [])
    ]
}

struct Technology: Equatable {
    let name: String
    let description: String
    let prerequesite: [TechnologyType]
    let type: TechnologyType
    
    var prereqString: String {
        let prereqs: String = prerequesite.map {
            switch $0 {
            case .blue:
                return "B"
            case .red:
                return "R"
            case .yellow:
                return "Y"
            case .green:
                return "G"
            case .none:
                return ""
            }
            }.joined()
        return prereqs
    }
    
    func meetsPrereqs(existingTechs techs: [Technology]) -> Bool {
        var pres = prerequesite
        for tech in techs {
            let type = tech.type
            if let index = pres.firstIndex(where: { $0 == type }) {
                pres.remove(at: index)
            }
        }
        return pres.isEmpty
    }
    
    static func ==(lhs: Technology, rhs: Technology) -> Bool {
        return lhs.name == rhs.name
    }
}

enum TechnologyType {
    case blue, yellow, red, green, none
}

extension Technology {
    
    static let allGenerics: [Technology] = Technology.blue.allBlues + Technology.green.allGreens + Technology.yellow.allYellows + Technology.red.allReds
    
    struct blue {
        static let antiMass = Technology(name: "Anti-Mass Deflectors", description: "Your ships can move into and through asteroid fields.\n\nWhen other players' units use SPACE CANNON against your units, apply -1 to the result of each die roll.", prerequesite: [], type: .blue)
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
    
    struct factionSpecific {
        
        struct mentak {
            static let both = [mentak.mirrorComputing, mentak.salvageOperations]
            static let mirrorComputing = Technology(name: "Mirror Computing", description: "When you spend trade goods, each trade good is worth 2 resources or influence instead of 1", prerequesite: [.yellow, .yellow, .yellow], type: .yellow)
            static let salvageOperations = Technology(name: "Salvage Operations", description: "After you win or lose a spae combat, gain 1 trade good; if you won the combat, you may also produce 1 ship in that system of any ship type that was destroyed during the combat", prerequesite: [.yellow, .yellow], type: .yellow)
        }
        
        struct yssaril {
            static let both = [yssaril.mageonImplants, yssaril.transparasteelPlating]
            static let mageonImplants = Technology(name: "Mageon Implants", description: "ACTION: Exhaust this card to look at another player's hand of action cards. Choose 1 of those cards and add it to your hand", prerequesite: [.green, .green, .green], type: .green)
            static let transparasteelPlating = Technology(name: "Transparasteel Plating", description: "During your turn of the action phase, players that have passed cannot play action cards.", prerequesite: [.green], type: .green)
        }
        
        struct hacan {
            static let both = [hacan.quantumDatahub, hacan.productionBiomes]
            static let quantumDatahub = Technology(name: "Quantum Datahub Node", description: "At the end of the strategy phase, you may spend 1 token from your strategy pool and give another player 3 of your trade goods. If you do, give 1 of your strategy cards to that player and take 1 of his strategy cards", prerequesite: [.yellow, .yellow, .yellow], type: .yellow)
            static let productionBiomes = Technology(name: "Production Biomes", description: "ACTION: Exhaust this card and spend 1 token from your strategy pool to gain 4 trade goods and choose 1 other player; that player gains 2 trade goods", prerequesite: [.green, .green], type: .green)
        }
        
        struct yin {
            static let both = [yin.yinSpinner, yin.impulseCore]
            static let yinSpinner = Technology(name: "Yin Spinner", description: "After 1 or more of your units use PRODUCTION, place 1 infantry from your reinforcements on a planet you control in that system", prerequesite: [.green, .green], type: .green)
            static let impulseCore = Technology(name: "Impulse Core", description: "At the start of a space combat, you may destroy 1 of your cruisers or destroyers in the active system to produce 1 hit against your opponent's ships; that hit must be assigned by your opponent to 1 of his non-fighter ships if able", prerequesite: [.yellow, .yellow], type: .yellow)
        }
        
        struct winnu {
            static let both = [winnu.lazaxGate, winnu.hegemonicTrade]
            static let lazaxGate = Technology(name: "Lazax Gate Folding", description: "During your tactical actions, if you do not control Mecatol Rex, treat its system as if it contains both an alpha and beta wormhole.\n\nACTION: If you control Mecatol Rex, exhaust this card to place 1 infantry from your reinforcements on Mecatol Rex.", prerequesite: [.blue, .blue], type: .blue)
            static let hegemonicTrade = Technology(name: "Hegemonic Trade Policy", description: "Exhaust this card when 1 or more of your units use PRODUCTION; swap the resource and influence values of 1 planet you control until the end of your turn", prerequesite: [.yellow, .yellow], type: .yellow)
        }
        
        struct nekro {
            static let both = [nekro.valefarAssimilatorX, nekro.valefarAssimilatorY]
            static let valefarAssimilatorX = Technology(name: "Valefar Assimilator X", description: "When you would gain another player's technology using 1 of your faction abilities, you may place the 'X' assimilator token on a faction technology owned by that player instead. While that token is on a technology, this card gains that technology's text. You cannot place an assimilator token on a technology that already has an assimilator token.", prerequesite: [], type: .none)
            static let valefarAssimilatorY = Technology(name: "Valefar Assimilator Y", description: "When you would gain another player's technology using 1 of your faction abilities, you may place the 'Y' assimilator token on a faction technology owned by that player instead. While that token is on a technology, this card gains that technology's text. You cannot place an assimilator token on a technology that already has an assimilator token.", prerequesite: [], type: .none)
        }
        
        struct barony {
            static let both = [barony.l4Disruptors, barony.nonEuclidean]
            static let l4Disruptors = Technology(name: "L4 Disruptors", description: "During an invasion, units cannot use SPACE CANNON aginst your units", prerequesite: [.yellow], type: .yellow)
            static let nonEuclidean = Technology(name: "Non-Euclidean Shieliding", description: "When 1 of your units uses SUSTAIN DAMAGE, cancel 2 hits instead of 1", prerequesite: [.red, .red], type: .red)
        }
        
        struct jolnar {
            static let both = [jolnar.spacialConduit, jolnar.eResSiphons]
            static let spacialConduit = Technology(name: "Spacial Conduit Cylinder", description: "You may exhaust this card after you activate a system that contains 1 or more of your units; that system is adjacent to all other systems that contain 1 or more of your units during this activation", prerequesite: [.blue, .blue], type: .blue)
            static let eResSiphons = Technology(name: "E-Res Siphons", description: "After another player activates a system that contains 1 or more of your ships, gain 4 trade goods", prerequesite: [.yellow, .yellow], type: .yellow)
        }
        
        struct sol {
            static let both = [sol.specOpsII, sol.advancedCarrier]
            static let specOpsII = Technology(name: "Spec Ops II", description: "Your infantry hit on 6 and respawn in home system on 5 when killed", prerequesite: [.green, .green], type: .none)
            static let advancedCarrier = Technology(name: "Advanced Carrier II", description: "Carrier now moves 2, capacity of 8, and can sustain damage", prerequesite: [.blue, .blue], type: .none)
        }
        
        struct naalu {
            static let both = [naalu.hybridCrystalFighterII, naalu.neuroGlaive]
            static let hybridCrystalFighterII = Technology(name: "Hybrid Crystal Figher II", description: "Upgraded Fighter hits on a 7 and no longer requires capacity (though still consumes it). any above capacity count as 1/2 fleet pool each.", prerequesite: [.green, .blue], type: .none)
            static let neuroGlaive = Technology(name: "NeuroGlaive", description: "After another player activates a system that contains 1 or more of your ships, that player removes 1 token from his fleet pool and returns it to his reinforcements", prerequesite: [.green, .green, .green], type: .green)
        }
        
        struct l1z1x {
            static let both = [l1z1x.superDreadnoughtII, l1z1x.inheritanceSystems]
            static let superDreadnoughtII = Technology(name: "Super-Dreadnought II", description: "Upgraded Dreadnought bombards on 4, hits on 4, moves 2, capacity 2", prerequesite: [.blue, .blue, .yellow], type: .none)
            static let inheritanceSystems = Technology(name: "Inheritance Systems", description: "You may exhaust this card and spend 2 resources when you research a technology; ignore all of that technology's prerequisites.", prerequesite: [.yellow, .yellow], type: .yellow)
        }
        
        struct arborec {
            static let both = [arborec.letaniWarrior, arborec.bioplasmosis]
            static let letaniWarrior = Technology(name: "Letani Warrior II", description: "Upgraded infantry hits has PRODUCTION 2, hits on 7, respawns on 6", prerequesite: [.green, .green], type: .none)
            static let bioplasmosis = Technology(name: "Bioplasmosis", description: "At the end of the status phase, you may remove any number of infantry from the planets you control and place them on 1 or more planets you control in the same or adjacent systems", prerequesite: [.green, .green], type: .green)
        }
        
        struct sardakk {
            static let both = [sardakk.extroriremeII, sardakk.valkyrieParticle]
            static let extroriremeII = Technology(name: "Exotrireme II", description: "Upgraded Dreadnought: After a round of space combat, you may destroy this unit to destroy up to 2 ships in this system. Hits on 5, move 2, capacity 1.", prerequesite: [.blue, .blue, .yellow], type: .none)
            static let valkyrieParticle = Technology(name: "Valkyrie Particle Weave", description: "After making combat rolls during a round of ground combat, if your opponent produced 1 or more hits, you prodcue 1 additional hit.", prerequesite: [.red, .red], type: .red)
        }
        
        struct muaat {
            static let both = [muaat.magmusReactor, muaat.prototypeWarsunII]
            static let magmusReactor = Technology(name: "Magmus Reactor", description: "Your ships can move into supernovas.\n\nAfter 1 or more of your units use PRODUCTION in a system that either contains a war sun or is adjacent to a supernova, gain 1 trade good", prerequesite: [.red, .red], type: .red)
            static let prototypeWarsunII = Technology(name: "Prototype War Sun II", description: "Epic Cost 10 Move 3 War Sun.", prerequesite: [.red, .red, .red, .yellow], type: .none)
        }
        
        struct saar {
            static let both = [saar.floatingFactoryII, saar.chaosMapping]
            static let floatingFactoryII = Technology(name: "Floating Factory II", description: "Upgraded Floating Factory: Move 2, Production 7, Capacity 5", prerequesite: [.yellow, .yellow], type: .none)
            static let chaosMapping = Technology(name: "Chaos Mapping", description: "Other players cannot activate asteroid fields that contain 1 or more of your ships.\n\nAt the start of your turn during the action phase, you may produce 1 unit in a system that contains at least 1 of your units that has PRODUCTION", prerequesite: [.blue], type: .blue)
        }
        
        struct ghosts {
            static let both = [ghosts.wormholeGenerator, ghosts.dimensionalSplicer]
            static let wormholeGenerator = Technology(name: "Wormhole Generator", description: "At the start of the status phase, place or move a Creuss wormhole token into either a system that contains a planet you control or a non-home system that does not contain another player's ships", prerequesite: [.blue, .blue], type: .blue)
            static let dimensionalSplicer = Technology(name: "Dimensional Splicer", description: "At the start of a space combatin a system that contains a wormhole and 1 or more of your ships, you may produce 1 hit and assign it to 1 of your opponent's ships", prerequesite: [.red], type: .red)
        }
        
        struct xxcha {
            static let both = [xxcha.instinctTraining, xxcha.nullificationField]
            static let instinctTraining = Technology(name: "Instinct Training", description: "You may exhaust this card and spend 1 token from your strategy pool when another player plays an action card; cancel that action card", prerequesite: [.green], type: .green)
            static let nullificationField = Technology(name: "Nullification Field", description: "After another player activates a system that contains 1 or more of your ships, you may exhaust this card and spend 1 otken from your stategy pool; immediately end that player's turn.", prerequesite: [.yellow, .yellow], type: .yellow)
        }
        
    }
}
