//
//  Teleport.swift
//  MazeGame
//
//  Created by Richard Plesnik on 30/08/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit


/// Class for teleport ability
class Teleport {
    private var tileMap: TileMap!
    private var level: Level!

    private var tileSize: CGFloat!

    private var mapWidth: Int!
    private var tiles: [Tile]!

    // TODO: replace by enum
    var canTeleport = 0 // 0 - unclicked, 1 clicked, 2 choosen, 3 accepted to tp

    private var screenWidth: CGFloat!
    private var screenHeight: CGFloat!

    private var tileIndex = -1

    
    /// Class constructor
    /// - Parameters:
    ///   - tileMap:  map of level tiles
    ///   - screenWidth: width of screen
    ///   - screenHeight: height of screen
    ///   - level: pointer to Level object
    init(tileMap: TileMap, screenWidth: CGFloat, screenHeight: CGFloat, level: Level) { // nastaveni poromenych
        self.tileMap = tileMap
        self.level = level

        tileSize = CGFloat(tileMap.tileSize)
        mapWidth = tileMap.width
        tiles = tileMap.getTiles()

        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
    }

    
    /// Function for choosing of file to teleport.
    /// - Parameters:
    ///   - playerX: player x position
    ///   - playerY: player y position
    ///   - fingerPosition: position of click
    ///   - nodes: clicekd notes
    /// - Returns: returns true if tp was correct
    func changeTile(playerX: CGFloat, playerY: CGFloat, fingerPosition: CGPoint, nodes: [SKNode]) -> Bool {
        // TODO: devide into multiple functions
        level.resetMove()

        if canTeleport == 1 {
            canTeleport = 2
            return false
        }
        if nodes.count == 0 {
            return false
        }
        let rX = playerX + (fingerPosition.x - screenWidth / 2)
        let rY = playerY + (fingerPosition.y - screenHeight / 2)

        if tileIndex >= 0 {
            tiles[tileIndex].disappearTile2()
        }

        if canTeleport == 2 { // choosing tile to teleport
            tileIndex = getTileByPos(x: rX + tileSize / 2, y: rY + tileSize / 2)
            let tile = tiles[getTileByPos(x: rX + tileSize / 2, y: rY + tileSize / 2)]
            if tile.id == 0 {
                tile.getNode().texture = SKTexture(imageNamed: "blueFloor32.png")
                canTeleport = 3
            } else {
                level.showNotification(text: "Choose floor", time: 750)
                canTeleport = 2
                tileIndex = -1
                return false
            }
        } else if canTeleport == 3 { // acepting tile and teleporting / back to choosing
            let newIndex = getTileByPos(x: rX + tileSize / 2, y: rY + tileSize / 2)
            let tile = tiles[newIndex]
            if tileIndex == newIndex && tile.id == 0 {
                tile.disappearTile2()
                level.travelOnTile(tileIndex: getTileByPos(x: rX + tileSize / 2, y: rY + tileSize / 2))
                canTeleport = 0
                return true
            } else {
                tileIndex = newIndex
                if tile.id == 0 {
                    canTeleport = 3
                    tile.getNode().texture = SKTexture(imageNamed: "blueFloor32.png")
                } else {
                    canTeleport = 2
                    level.showNotification(text: "Choose floor", time: 750)
                    return false
                }
            }
        }
        return false
    }

    
    /// Find tile on given position
    /// - Parameters:
    ///   - x: x position
    ///   - y: y position
    /// - Returns: index of a tile in tileMap
    func getTileByPos(x: CGFloat, y: CGFloat) -> Int {
        let tileIndex = Int(y / tileSize) * tileMap.width + Int(x / tileSize)
        return tileIndex
    }

    
    /// Cancel mark on floor
    func resetMark() {
        if tileIndex >= 0 {
            tiles[tileIndex].disappearTile2()
        }
    }
}
