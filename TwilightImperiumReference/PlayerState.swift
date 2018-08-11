//
//  PlayerState.swift
//  TwilightImperiumReference
//
//  Created by Dustin Howell on 8/10/18.
//  Copyright © 2018 Dustin Howell. All rights reserved.
//

import UIKit

class PlayerState {
    private static let filename = "playerState.txt"
    static var shared: PlayerState = {
        if let storedTechs = readFromFile() {
            return PlayerState(withOwnedTechs: storedTechs)
        }
        return PlayerState(withOwnedTechs: [])
    }()
    
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
    
    func writeToFile() {
        guard let encodedData = try? JSONEncoder().encode(ownedTechnologies) else {
            print("error writing to file")
            return
        }
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("error fetching directory (for write)")
            return
        }
        let fileURL = dir.appendingPathComponent(PlayerState.filename)
        do {
            try encodedData.write(to: fileURL)
            print("Successfully wrote data to disk")
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    static func readFromFile() -> [Technology]? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("error fetching directory (for read)")
            return nil
        }
        let fileURL = dir.appendingPathComponent(filename)
        guard let data = FileManager.default.contents(atPath: fileURL.path) else {
            print("Error fetching contents of \(fileURL.path)")
            return nil
        }
        do {
            let model = try JSONDecoder().decode(Array<Technology>.self, from: data)
            print("Successfully loaded data from file:\n\(model)")
            return model
        }catch {
            print("ERROR: \(error.localizedDescription)")
        }
        return nil
    }
}
