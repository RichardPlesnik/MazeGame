//
//  LoadLevel.swift
//  MazeGame
//
//  Created by Richard Plesnik on 07/08/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import Foundation
import SpriteKit


/// Structure for saving Maps data. Matched with json representation.
struct Maps: Codable {
    var mapsData: [MapData]
}


/// Structure for saving ,map data. Matched with json representation.
struct MapData: Codable {
    var id: Int
    var status: Int // unlocked 0, in progress 1, locked 2, completed+inProgress 3, completed 4,
    var name: String
    var file: String

    var size: Int

    var actualTime: TimeInterval
    var bestTime: TimeInterval

    // var started: Bool
    var finished: Bool

    var coinCount: Int

    var abilityIndexes: [Int]
}

/// Class used for loading map data from json file.
class MapFileLoader {
    private var maps: Maps!

    /// Class constructor
    init() {
        print("\n____LOADING MAPS DATA____")
        loadData()
        print("____MAPS DATA LOADED____\n")
    }

    /// Function used for loading from json data file
    func loadData() {
        let decoder = JSONDecoder()

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("MapData.json")
            print(fileURL)

            do {
                let data = try Data(contentsOf: fileURL)
                maps = try decoder.decode(Maps.self, from: data)

            } catch {
                print("Decoding error \(error)")
                print("Creating new file")
                initSaveFile()
            }
        }
    }

    /// Creates new json file based on template in Res folder
    func initSaveFile() {
        if let filepath = Bundle.main.path(forResource: "DefaultMapData", ofType: "json") {
            do {
                let contents = try String(contentsOfFile: filepath)
                print(contents)
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let fileURL = dir.appendingPathComponent("MapData.json")
                    do {
                        try contents.write(to: fileURL, atomically: false, encoding: .utf8)
                    } catch {
                        print("failed to write")
                    }
                }
            } catch {
                print("Default data cannot be loaded")
            }
        } else {
            print("File not found")
        }
        // TODO: add counter/something to prevent infinate loop if file template is missing
        loadData()
    }

    /// Save actual map data from struct to json file
    func saveData() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let data = try! encoder.encode(maps)
        // print(String(data: data, encoding: .utf8)!)
        let dataString = String(data: data, encoding: .utf8)!

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("MapData.json")

            do {
                try dataString.write(to: fileURL, atomically: false, encoding: .utf8)
            } catch {
                print("failed to write")
            }
        }
    }
    
    /// Update level data
    /// - Parameters:
    ///   - status: level status
    ///   - coinCount: coin count
    ///   - mapId: map id
    ///   - actualTime: actual time
    func updateLevel(status: Int, coinCount: Int, mapId: Int, actualTime: TimeInterval) {
        updateMap(mps: &maps, status: status, coinCount: coinCount, mapId: mapId, actualTime: actualTime)
    }
    
    /// Realize saving of map data to struct
    /// - Parameters:
    ///   - mps: maps
    ///   - status: level status
    ///   - coinCount: coin count
    ///   - mapId: map id
    ///   - actualTime: actual time
    func updateMap(mps: inout Maps, status: Int, coinCount: Int, mapId: Int, actualTime: TimeInterval) {
        mps.mapsData[mapId].status = status
        mps.mapsData[mapId].coinCount = coinCount
        mps.mapsData[mapId].actualTime = actualTime
    }
    
    /// Abilities data getter
    /// - Parameter mapId: map id
    /// - Returns: abilities data
    func getAbilities(mapId: Int) -> [Int] {
        return maps.mapsData[mapId].abilityIndexes
    }
    
    /// Change abilities data
    /// - Parameters:
    ///   - mapId: map id
    ///   - abilities: abilities data
    func changeAbilities(mapId: Int, abilities: [Int]) {
        changeAbilities2(mps: &maps, mapId: mapId, abilities: abilities)
    }
    
    /// Realize saving of abilities data to struct
    /// - Parameters:
    ///   - mps: maps
    ///   - mapId: map id
    ///   - abilities: abilities data
    func changeAbilities2(mps: inout Maps, mapId: Int, abilities: [Int]) {
        mps.mapsData[mapId].abilityIndexes = abilities
    }
    
    /// Ends timer
    /// - Parameters:
    ///   - mapId: map id
    ///   - time: time
    func endTime(mapId: Int, time: TimeInterval) {
        endTime2(mps: &maps, mapId: mapId, time: time)
    }
    
    /// Realize ending of timer
    /// - Parameters:
    ///   - mps: maps
    ///   - mapId: map id
    ///   - time: time
    func endTime2(mps: inout Maps, mapId: Int, time: TimeInterval) {
        if mps.mapsData[mapId].bestTime == 0 || mps.mapsData[mapId].bestTime >= time {
            mps.mapsData[mapId].bestTime = time
        }
    }
    
    /// Maps getter
    /// - Returns: maps data
    func getMaps() -> [MapData] {
        return maps.mapsData
    }
}
