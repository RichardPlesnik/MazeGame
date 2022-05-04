//
//  LoadLevel.swift
//  MazeGame
//
//  Created by Richard Plesnik on 07/08/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import Foundation
import SpriteKit

// TODO: posibly add some generalization, all loader classes are simmilar


/// Structure for saving level data. Matched with json representation.
struct LevelData: Codable {
    var id: Int
    var name: String
    var started: Bool
    var finished: Bool

    var spawnIndex: Int // -1 any, 0 mid, 1-4 top, r, l, bot
    // last visited part and position
    var lastPart: Int
    var lastX: CGFloat!
    var lastY: CGFloat!

    var foundMids: [Bool] // data about found map mids
    var foundGates: [Bool] // true/false for all gate (6 horizontals a 6 verticals)
    var gatePos: [Int] // gate positions on walls

    var coinCount2: Int

    var actualTime: TimeInterval
    var bestTime: TimeInterval

    var mapParts: [MapPart]

    var cooldowns: [Double]
}


/// Structure for saving map part data. Matched with json representation.
struct MapPart: Codable {
    var id: Int
    var name: String

    var spawnFound: Bool
    var exitCount: Int
    var teleportFounds: [Bool]

    var teleportPos: [CGPoint] // positions of gates to teleport

    var coinCount: Int
    var foundCoins: [Int]
}


/// Class used for loading level data from json file.
class LevelLoader {
    private var actualMap: String!
    private var mapPart: MapPart!

    private var partIndex: Int!

    var levelData: LevelData!

    private var levelId: Int!

    private var mapName: String!
    private var mapFileLoader: MapFileLoader!

    
    /// Class constructor
    /// - Parameters:
    ///   - id: level id
    ///   - mapName: name of map
    init(id: Int, mapName: String) {
        print("\n____LOADING LEVEL DATA____")
        levelId = id
        self.mapName = mapName
        mapFileLoader = MapFileLoader()
        loadLevel()
        print("____LEVEL LOADED____\n")
    }
    
    /// Map getter
    /// - Returns: actual map string
    func getMap() -> String {
        return actualMap
    }
    
    /// Coins getter
    /// - Returns: data about found/unfound coins
    func getCoins() -> [Int] {
        return mapPart.foundCoins
    }
    
    /// Map part coin count getter
    /// - Returns: coin count of current map part
    func getCoinCount() -> Int16 {
        return Int16(mapPart.coinCount)
    }
    
    /// Level data coin count getter
    /// - Returns: coin count of current level part
    func getCoinsSum() -> Int {
        return levelData.coinCount2
    }
    
    /// Function used for loading from json data file
    func loadData() {
        let decoder = JSONDecoder()

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(mapName)
            print(fileURL)

            do {
                let data = try Data(contentsOf: fileURL)
                levelData = try decoder.decode(LevelData.self, from: data)

            } catch {
                print("Decoding error \(error)")
                print("Creating new file")
                initSaveFile()
            }
        }
    }
    
    /// Creates new json file based on template in Res folder
    func initSaveFile() {
        if let filepath = Bundle.main.path(forResource: mapName, ofType: "json") {
            do {
                let contents = try String(contentsOfFile: filepath)
                print(contents)
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let fileURL = dir.appendingPathComponent(mapName)
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
    
    /// Save actual levelData from struct to json file
    func saveData() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let data = try! encoder.encode(levelData)
        // print(String(data: data, encoding: .utf8)!)
        let dataString = String(data: data, encoding: .utf8)!

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(mapName)

            do {
                try dataString.write(to: fileURL, atomically: false, encoding: .utf8)
            } catch {
                print("failed to write")
            }
        }
        saveToMaps()
    }
    
    /// Save data from map part
    func saveToMaps() {
        var coinSum = 0
        for part in levelData.mapParts {
            coinSum += part.coinCount
        }
        var status = 1
        if coinSum == COINS_TO_WIN { // 90
            status = 4
        }
        if mapFileLoader.getMaps()[levelId].status == 3 || mapFileLoader.getMaps()[levelId].status == 4 {
            status = 3
            if coinSum == COINS_TO_WIN { // 90
                status = 4
            }
        }
        if levelData.actualTime == 0 {
            status = 1
            if mapFileLoader.getMaps()[levelId].status == 3 || mapFileLoader.getMaps()[levelId].status == 4 {
                status = 4
            }
        }

        mapFileLoader.updateLevel(status: status, coinCount: coinSum, mapId: levelId, actualTime: levelData.actualTime)

        mapFileLoader.saveData()
    }
    
    /// Change coin data
    /// - Parameters:
    ///   - coins: coin values
    ///   - coinCount: coin count
    func changeCoins(coins: [Int], coinCount: Int16) {
        changeCoins2(level: &levelData, coins: coins, coinCount: coinCount, mapIndex: levelId, partIndex: partIndex)
    }
    
    /// Realize saving of coin data to struct
    /// - Parameters:
    ///   - level: level data
    ///   - coins: coin values
    ///   - coinCount: coin count
    ///   - mapIndex: current map index
    ///   - partIndex: current map part index
    func changeCoins2(level: inout LevelData, coins: [Int], coinCount: Int16, mapIndex: Int, partIndex: Int) {
        level.mapParts[partIndex].foundCoins = coins
        level.mapParts[partIndex].coinCount = Int(coinCount)
        level.coinCount2 += 1
    }
    
    /// Change cooldowns data
    /// - Parameter cooldowns: cooldowns data
    func changeCooldowns(cooldowns: [Double]) {
        changeCooldowns2(level: &levelData, cooldowns: cooldowns)
    }
    
    /// Realize saving of cooldowns data to struct
    /// - Parameters:
    ///   - level: level data
    ///   - cooldowns: cooldowns data
    func changeCooldowns2(level: inout LevelData, cooldowns: [Double]) {
        level.cooldowns = cooldowns
    }
    
    /// Change actual map part
    /// - Parameters:
    ///   - newPartIndex: new part index
    ///   - spawnIndex: new spawn index
    func changePart(newPartIndex: Int, spawnIndex: Int) {
        changePart2(level: &levelData, newPartIndex: newPartIndex, spawnIndex: spawnIndex)
    }
    
    /// Realize saving of map part to struct
    /// - Parameters:
    ///   - level: level data
    ///   - newPartIndex: new part index
    ///   - spawnIndex: new spawn index
    func changePart2(level: inout LevelData, newPartIndex: Int, spawnIndex: Int) {
        level.lastPart = newPartIndex
        level.spawnIndex = spawnIndex
    }
    
    /// change teleport data
    /// - Parameters:
    ///   - teleportIndex: teleport index
    ///   - x: x position
    ///   - y: y position
    func changeTeleport(teleportIndex: Int, x: Int, y: Int) {
        changeTeleport2(level: &levelData, teleportIndex: teleportIndex, x: x, y: y)
    }
    
    /// Realize saving of teleport data to struct
    /// - Parameters:
    ///   - level: level data
    ///   - teleportIndex: teleport index
    ///   - x: x position
    ///   - y: y position
    func changeTeleport2(level: inout LevelData, teleportIndex: Int, x: Int, y: Int) {
        level.mapParts[partIndex].teleportFounds[teleportIndex] = true
        if teleportIndex != 0 {
            level.mapParts[partIndex].teleportPos[teleportIndex - 1] = CGPoint(x: x, y: y)
        }
    }
    
    /// Load level and map part
    func loadLevel() {
        loadData()

        partIndex = levelData.lastPart // index of curent map part
        actualMap = levelData.mapParts[partIndex].name
        mapPart = levelData.mapParts[partIndex]
    }
    
    /// Reset current level. Previously picked up coins are blue to avoid infinate farming.
    /// - Parameter mapIndex: index of map
    func resetLevel(mapIndex: Int) {
        var coinBackups = [[Int]](repeating: [Int](repeating: 0, count: 10), count: 9)
        for i in 0...8 {
          var localBackup = levelData.mapParts[i].foundCoins
          for j in 0 ... (localBackup.count - 1) {
              if localBackup[j] == 3 {
                  localBackup[j] = 2
              }
          }
          coinBackups[i] = localBackup
        }


        initSaveFile()
        saveToMaps()

        for i in 0...8 {
              changeCoins2(level: &levelData, coins: coinBackups[i], coinCount: 0, mapIndex: levelId, partIndex: i)
        }
        saveData()
      
    }
    
    /// Part index getter
    /// - Returns: part index
    func getPartIndex() -> Int {
        return partIndex
    }
    
    /// Spawn index getter
    /// - Returns: spawn index
    func getSpawnIndex() -> Int {
        return levelData.spawnIndex
    }
    
    /// Teleports getter
    /// - Returns: teleports
    func getTeleports() -> [Bool] {
        return levelData.mapParts[partIndex].teleportFounds
    }
    
    /// Parts getter
    /// - Returns: parts
    func getParts() -> [MapPart] {
        return levelData.mapParts
    }
    
    /// Change time data
    /// - Parameter newTime: time data
    func changeTime(newTime: TimeInterval) {
        changeTime2(level: &levelData, newTime: newTime)
    }
    
    /// Realize saving of time data to struct
    /// - Parameters:
    ///   - level: level data
    ///   - newTime: time data
    func changeTime2(level: inout LevelData, newTime: TimeInterval) {
        level.actualTime = newTime
    }
    
    /// Time getter
    /// - Returns: actual time
    func getTime() -> TimeInterval {
        return levelData.actualTime
    }
    
    /// Map loader getter
    /// - Returns: pointer to map lader object
    func getMapFileLoader() -> MapFileLoader {
        return mapFileLoader
    }
    
    /// coodowns getter
    /// - Returns: cooldowns
    func getCooldowns() -> [Double] {
        return levelData.cooldowns
    }
}
