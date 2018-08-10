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
}
