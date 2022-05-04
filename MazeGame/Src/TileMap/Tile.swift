//
//  Tile.swift
//  MazeGame
//
//  Created by Richard Plesnik on 04/03/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit

/// Class for representing tile
class Tile {
    var size: Int!
    var id: Int!

    let isSolid: Bool!
    var node: SKSpriteNode!

    var x = 0
    var y = 0

    var leftXBoundary: Int!
    var rightXBoundary: Int!
    var leftYBoundary: Int!
    var rightYBoundary: Int!
    
    /// Cllass constructor
    /// - Parameters:
    ///   - x: x position
    ///   - y: y position
    ///   - size: tile size
    ///   - id: tile id
    ///   - texture: tile texture
    ///   - isSolid: true if tile is solid
    init(x: Int, y: Int, size: Int, id: Int, texture: String, isSolid: Bool) {
        self.id = id
        self.isSolid = isSolid
        self.size = size
        self.x = x
        self.y = y
        node = SKSpriteNode(imageNamed: texture)
        node.position.x = CGFloat(x)
        node.position.y = CGFloat(y)
        node.setScale(CGFloat(size) / 32.0)
        // self.node.anchorPoint = CGPoint(x: 0, y: 0)
        // self.node.zRotation = CGFloat(deg2rad(45))
    }

    
    /// Sets tile position on screen based on screen offset
    /// - Parameters:
    ///   - xOffset: x offset
    ///   - yOffset: y offset
    func setNodePosition(xOffset: CGFloat, yOffset: CGFloat) {
        node.position.x = CGFloat(x) - xOffset
        node.position.y = CGFloat(y) - yOffset
    }
    
    /// Convert angle from degrees to radians
    /// - Parameter number: degrees
    /// - Returns: radians
    func deg2rad(_ number: Float) -> Float {
        return Float(number * .pi / 180)
    }
    
    /// Dissappear tile
    func disappearTile() {
        if id == 2 || id == -1 {
            node.texture = SKTexture(imageNamed: "grayFloor32.png")
            id = 0
        }
    }

    /// Dissappear tile
    func disappearTile2() {
        if id == 0 {
            node.texture = SKTexture(imageNamed: "grayFloor32.png")
            id = 0
        }
    }
    
    /// Mark tile
    func markTile() {
        if id == 0 {
            node.texture = SKTexture(imageNamed: "markedTile2.png")
            id = -1
        }
    }
    
    /// Get tile node
    /// - Returns: tile node
    func getNode() -> SKSpriteNode {
        return node
    }
}
