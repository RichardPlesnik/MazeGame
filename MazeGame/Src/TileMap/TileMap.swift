//
//  TileMap.swift
//  MazeGame
//
//  Created by Richard Plesnik on 04/03/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit

/// Class representing map of tiles
class TileMap {
    var tiles = Array<Tile>()
    let width: Int!
    let height: Int!
    let tileSize: Int!

    let textures = ["grayFloor32.png", "wallTile.png", "coinTile.png", "door1.png", "door2.png", "door3.png", "door4.png", "BlueTeleport", "InactiveTeleport32", "wall0", "wall1", "wall2", "wall3", "wall4", "wall5", "wall6", "wall7", "wall8", "blueCoinTile.png"] // ["floorTile.png", "wallTile.png"]
    let solidness = [false, true, false, true, true, true, true, false, false, true, true, true, true, true, true, true, true, true, false]

    let map: String!

    var spawnIndex: Int!

    private var coins: [Int]!
    var coinIndexes: [Int]!

    
    /// Class constructor
    /// - Parameters:
    ///   - name: map name
    ///   - tileSize: tile size
    ///   - coins: array of coins
    ///   - spawnIndex: spawn index
    ///   - level: level pointer
    init(name: String, tileSize: Int, coins: [Int], spawnIndex: Int, level: Level) {
        map = name

        self.tileSize = tileSize
        self.spawnIndex = spawnIndex

        let mapLoader = MapLoader()
        mapLoader.loadMap(name: map)
        width = mapLoader.getMapWidth()
        height = mapLoader.getMapHeight()

        self.coins = coins
        coinIndexes = []
        createMap(mapArray: mapLoader.getMap())
        
        setSpawn(level: level)
        setTeleports(level: level)
    }
    
    /// Create tile map based on map array
    /// - Parameter mapArray: array of map tile numbers
    func createMap(mapArray: [[Int]]) {
        var coinIndex = 0 // idnexed left->right, top->bottom
        for (i, row) in mapArray.reversed().enumerated() {
            for (j, value) in row.enumerated() {
                if value == 2 { // teleport - disabled by efault (8-7)
                    createTile(x: j * tileSize, y: i * tileSize, size: tileSize, id: 8)
                    continue
                }
                if value == 3 { // coin
                    coinIndexes.append(Int(j) + Int(i * width))
                    if coins[coinIndex] == 0 {
                        createTile(x: j * tileSize, y: i * tileSize, size: tileSize, id: 2)
                    } else if coins[coinIndex] == 2 {
                        createTile(x: j * tileSize, y: i * tileSize, size: tileSize, id: 2)
                        tiles.last?.node.texture = SKTexture(imageNamed: "blueCoinTile.png")
                    } else {
                        createTile(x: j * tileSize, y: i * tileSize, size: tileSize, id: 0)
                    }
                    coinIndex += 1
                    continue
                }
                if value > 3 && value < 8 { // doors
                    createTile(x: j * tileSize, y: i * tileSize, size: tileSize, id: value - 1)
                    continue
                }
                if value > 7 {
                    createTile(x: j * tileSize, y: i * tileSize, size: tileSize, id: value + 1)
                    continue
                }
                createTile(x: j * tileSize, y: i * tileSize, size: tileSize, id: value)
            }
        }
    }
    
    /// Create new tile in map
    /// - Parameters:
    ///   - x: x posiiton
    ///   - y: y position
    ///   - size: tile size
    ///   - id: tile id
    func createTile(x: Int, y: Int, size: Int, id: Int) {
        tiles.append(Tile(x: x, y: y, size: size, id: id, texture: textures[id], isSolid: solidness[id]))
    }

    /// Update tiles with coins.
    /// - Parameter index: coin index
    /// - Returns: true if coin was picked up first time, fald otherwise
    func updateCoins(index: Int) -> Bool{
      //picked up first time -> id == 0, otherwise == 2
        for (i, ind) in coinIndexes.enumerated() {
            if ind == index {
                let oldIndex = coins[i];
                coins[i] = 3
                return oldIndex == 0;
            }
        }
        return false
    }
    
    /// Set tile map spawn point
    /// - Parameter level: level pointer
    func setSpawn(level: Level) {
        if spawnIndex == 0 {
            for tile in tiles {
                if tile.id == 8 {
                    level.setSpawn(x: width * tileSize / 2 - 16, y: height * tileSize / 2 - 16)
                    return
                }
            }
        }
        let border = (width - 3) * tileSize
        for tile in tiles {
            if tile.id == 5 {
                if spawnIndex == 1 && tile.y > border { // top spawn
                    level.setSpawn(x: tile.x + 16, y: tile.y - 48)
                    return
                }
                if spawnIndex == 2 && tile.x > border { // right spawn
                    level.setSpawn(x: tile.x - 48, y: tile.y + 16)
                    return
                }
                if spawnIndex == 3 && tile.y < 64 { // bottom spawn
                    level.setSpawn(x: tile.x + 16, y: tile.y + 80)
                    return
                }
                if spawnIndex == 4 && tile.x < 64 { // left spawn
                    level.setSpawn(x: tile.x + 80, y: tile.y + 16)
                    return
                }
            }
        }
    }
    
    /// Set teleport tiles
    /// - Parameter level: level pointer
    func setTeleports(level: Level) {
        let teleports = level.getTeleports()

        let border = (width - 3) * tileSize - 32
        for tile in tiles {
            if tile.id == 8 {
                if tile.y > border && teleports[1] { // top tp
                    tile.node.texture = SKTexture(imageNamed: "BlueTeleport")
                    continue
                }
                if tile.x > border && teleports[2] { // right tp
                    tile.node.texture = SKTexture(imageNamed: "BlueTeleport")
                    continue
                }
                if tile.y < 96 && teleports[3] { // bottom tp
                    tile.node.texture = SKTexture(imageNamed: "BlueTeleport")
                    continue
                }
                if tile.x < 93 && teleports[4] { // left tp
                    tile.node.texture = SKTexture(imageNamed: "BlueTeleport")
                    continue
                }
                if tile.x > 99 && tile.y > 93 && tile.x < border && tile.y < border && teleports[0] { // mid
                    tile.node.texture = SKTexture(imageNamed: "BlueTeleport")
                }
            }
        }
    }

    
    /// Calculates middle position
    /// - Returns: <#description#>
    func getMidPos() -> CGPoint {
        return CGPoint(x: width / 2 * TILE_SIZE, y: height / 2 * TILE_SIZE)
    }
    
    // Getters and setters

    func setSpawnIndex(index: Int) {
        spawnIndex = index
    }
    
    func getWidth() -> Int {
        return width
    }

    func getHeight() -> Int {
        return height
    }

    func getTiles() -> [Tile] {
        return tiles
    }
    
    func getCoins() -> [Int] {
        return coins
    }
}
