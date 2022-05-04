//
//  Magnet.swift
//  MazeGame
//
//  Created by Richard Plesnik on 01/09/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit


/// Class for magnet ability
class Magnet {
    private var tileMap: TileMap!
    private var level: Level!

    private var tileSize: CGFloat!

    private var mapWidth: Int!
    private var tiles: [Tile]!

    // TODO: replace with enum
    var canMagnet = 0 // 0 - unclicked, 1 clicked, 2 choosen, 3 accept

    private var screenWidth: CGFloat!
    private var screenHeight: CGFloat!

    
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

    
    /// Function for choosing coin to magnet.
    /// - Parameters:
    ///   - playerX: player x position
    ///   - playerY: player y position
    ///   - fingerPosition: position of click
    ///   - nodes: clicekd notes
    /// - Returns: returns true if tp was correct
    func changeTile(playerX: CGFloat, playerY: CGFloat, fingerPosition: CGPoint, nodes: [SKNode]) -> Bool {
        level.resetMove()

        if canMagnet == 1 {
            canMagnet = 2
            return false
        }
        if nodes.count == 0 {
            return false
        }
        let rX = playerX + (fingerPosition.x - screenWidth / 2)
        let rY = playerY + (fingerPosition.y - screenHeight / 2)

        let tileIndex = getTileByPos(x: rX + tileSize / 2, y: rY + tileSize / 2)
        let tile = tiles[tileIndex]

        if tile.id == 2 {
            tile.disappearTile()
            canMagnet = 0
            level.foundCoin(newIndex: tileIndex)
            level.showNotification(text: "Coin picked up!", time: 750)
            level.reloadScreen()
            return !level.finished
        }
        level.showNotification(text: "Choose a coin", time: 750)
        canMagnet = 2
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
}
