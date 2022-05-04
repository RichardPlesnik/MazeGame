//
//  Screen.swift
//  MazeGame
//
//  Created by Richard Plesnik on 04/03/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit

/// Class representing game screen
class Screen {

    // TODO: optimalize class performance
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var screenWidthInTiles: Int!
    var screenHeightInTiles: Int!

    var xOffset: CGFloat!
    var yOffset: CGFloat!

    var tiles = Array<Tile>()
    var displayedTiles = Array<Tile>()
    var scene: SKScene!
    var player: Player!

    let tileSize = 32

    let mapWidth: Int! // in tiles
    let mapHeight: Int!

    // indexy tilu nactenych na okrajich
    var leftX = 0
    var rightX = 0
    var lowerY = 0
    var upperY = 0
    
    /// Screen constructor
    /// - Parameters:
    ///   - width: screen width
    ///   - height: screen height
    ///   - scene: screen scene
    ///   - player: player object
    ///   - tileMap: tile map object
    init(width: CGFloat, height: CGFloat, scene: SKScene, player: Player, tileMap: TileMap) {
        screenWidth = width
        screenHeight = height
        self.scene = scene
        self.player = player
        screenWidthInTiles = Int(Int(screenWidth) / tileSize) + 1
        screenHeightInTiles = Int(Int(screenHeight) / tileSize) + 1
        tiles = tileMap.tiles
        mapWidth = tileMap.width
        mapHeight = tileMap.height
    }
    
    /// Updates screen
    func tick() {
        // update offsetu
        // updateOffset()

        // clearScreen()
        fillScreen()
        // refreshMap(angle: angle)
    }
    
    /// Update screen offset on map
    func updateOffset() {
        xOffset = player.xPos - screenWidth / 2
        yOffset = player.yPos - screenHeight / 2        
        for tile in displayedTiles {
            tile.setNodePosition(xOffset: xOffset, yOffset: yOffset)
        }
    }
    
    /// Refresh map
    /// - Parameter angle: player angle
    func refreshMap(angle: CGFloat) {
        let startX = Int(player.xPos - screenWidth / 2)
        let endX = startX + Int(screenWidth) // Int(player.xPos + screenWidth/2)
        let startY = Int(player.yPos - screenHeight / 2)
        let endY = startY + Int(screenHeight) // Int(player.yPos + screenHeight/2)

        // Remove old tiles. Refresh tiles position.
        var indexesToRemove = [Int]()
        var nodesToRemove = [SKSpriteNode]()
        for (i, tile) in displayedTiles.enumerated() {
            if tile.x < startX - tileSize || tile.x > endX + tileSize {
                nodesToRemove.append(tile.node)
                indexesToRemove.append(i)
            } else if tile.y < startY - tileSize || tile.y > endY + tileSize {
                nodesToRemove.append(tile.node)
                indexesToRemove.append(i)
            }
        }
        scene.removeChildren(in: nodesToRemove)
        var indexOffset = 0
        for i in indexesToRemove {
            displayedTiles.remove(at: i - indexOffset)
            indexOffset += 1
        }

        // Screen edges
        var newLeftX = startX / tileSize
        var newRightX = newLeftX + screenWidthInTiles
        var newLowerY = startY / tileSize
        var newUpperY = newLowerY + screenHeightInTiles

        if newLowerY < 0 {
            newLowerY = 0
        }
        if newUpperY >= mapHeight {
            newUpperY = mapHeight - 1
        }
        if newLeftX < 0 {
            newLeftX = 0
        }
        if newRightX >= mapWidth {
            newRightX = mapWidth - 1
        }

        if newLeftX < leftX {
            // New left column
            for y in newLowerY ... newUpperY {
                let i = y * mapWidth + newLeftX
                let actualTile = tiles[i]
                actualTile.setNodePosition(xOffset: xOffset, yOffset: yOffset)
                scene.addChild(actualTile.node)
                displayedTiles.append(actualTile)
            }
        } else if newRightX > rightX {
            // New right column
            for y in newLowerY ... newUpperY {
                let i = y * mapWidth + newRightX
                let actualTile = tiles[i]
                actualTile.setNodePosition(xOffset: xOffset, yOffset: yOffset)
                scene.addChild(actualTile.node)
                displayedTiles.append(actualTile)
            }
        }
        if newLowerY < lowerY {
            // New bottom column
            for x in newLeftX ... newRightX {
                let i = newLowerY * mapWidth + x
                let actualTile = tiles[i]
                actualTile.setNodePosition(xOffset: xOffset, yOffset: yOffset)
                scene.addChild(actualTile.node)
                displayedTiles.append(actualTile)
            }
        } else if newUpperY > newUpperY {
            // New left top
            for x in newLeftX ... newRightX {
                let i = newUpperY * mapWidth + x
                let actualTile = tiles[i]
                actualTile.setNodePosition(xOffset: xOffset, yOffset: yOffset)
                scene.addChild(actualTile.node)
                displayedTiles.append(actualTile)
            }
        }

        leftX = newLeftX
        rightX = newRightX
        lowerY = newLowerY
        upperY = newUpperY
    }
    
    /// Clear tiles on screen
    func clearScreen() {
        displayedTiles = []
    }
    
    /// Old unoptimized fillSCcreen function
    func fillScreen2() {
        xOffset = player.xPos - screenWidth / 2
        yOffset = player.yPos - screenHeight / 2
        let startIndex = 0
        let endIndex = mapWidth * mapHeight - 1
        for i in startIndex ... endIndex {
            let actualTile = tiles[i]
            actualTile.setNodePosition(xOffset: xOffset, yOffset: yOffset)
            scene.addChild(actualTile.node)
            displayedTiles.append(actualTile)
        }
    }
    
    /// Initalize screen
    func fillScreen() {
        // TODO: scale on diferent displays
        var startX = Int(player.xPos - screenWidth / 2) / tileSize
        var startY = Int(player.yPos - screenHeight / 2) / tileSize

        if startX < 0 {
            startX = 0
        }
        if startY < 0 {
            startY = 0
        }

        xOffset = player.xPos - screenWidth / 2
        yOffset = player.yPos - screenHeight / 2

        // stop rendering under map
        let sY = Int(player.yPos - screenHeight / 2) / tileSize - 1
        // TODO: calculate from screen size
        var maxR = 14
        if sY < 0 {
            maxR += sY
        }
        // stop rendering before left edge
        var renderOffset = 0
        let sX = Int(player.xPos - screenWidth / 2) / tileSize - 1
        if sX < 0 {
            renderOffset = sX
        }

        let startIndex = startY * mapWidth + startX
        var pocet = 0
        for r in 0 ... maxR {
            let row = startIndex + r * mapWidth
            if row >= tiles.count {
                continue
            }
            var max = row + screenWidthInTiles + 1 + renderOffset
            if max >= tiles.count {
                max = tiles.count - 1
            }
            for i in row ... max {
                pocet += 1
                if i >= tiles.count || i < 0 {
                    break
                }
                let actualTile = tiles[i]
                actualTile.setNodePosition(xOffset: xOffset, yOffset: yOffset)
                scene.addChild(actualTile.node)
                if (i + 1) % mapWidth == 0 {
                    break
                }
            }
        }        
    }
}
