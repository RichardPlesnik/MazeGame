//
//  Player.swift
//  MazeGame
//
//  Created by Richard Plesnik on 04/02/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit

/// CLass for representingplayer
class Player {
    private var TILE_SIZE: CGFloat!
    private var collisionOffset: CGFloat!

    var tiles = Array<Tile>()

    var node: SKSpriteNode!
    var titleNode: SKLabelNode!
    var hitbox: SKShapeNode!

    var tickCounter = 0
    var speed = CGFloat(256) // points per second (32 = 1 tile/sec)

    var mapWidth: CGFloat!
    var mapHeight: CGFloat!

    var mapWidth2: Int!

    var xPos: CGFloat!
    var yPos: CGFloat!

    private var screenWidth: CGFloat!
    private var screenHeight: CGFloat!

    private var scene: SKScene!
    private var level: Level!
    
    private var onTeleport: Bool = true
    private var onTravel: Bool = false

    private var spawning: Bool = true

    
    // CONSIDERING REPLACING ROTATION WITH 8 SPRITES AND WALK ANIMATION
    private var animationIndex = 0
    private var animationCount = 4
    private var fromLastAnim = CGFloat(0)
    private var animationRate = CGFloat(30)
    
    /// Constructor
    /// - Parameters:
    ///   - scene: pointer to scene
    ///   - level: pointer to level
    ///   - x: x position
    ///   - y: y position
    ///   - screenWidth: screen width
    ///   - screenHeight: screen height
    ///   - mapSize: map size
    ///   - tileSize: tile size
    init(scene: SKScene, level: Level, x: CGFloat, y: CGFloat, screenWidth: CGFloat, screenHeight: CGFloat, mapSize: (width: Int, height: Int), tileSize: Int) {
        self.scene = scene
        self.level = level

        self.screenWidth = screenWidth
        self.screenHeight = screenHeight

        mapWidth = CGFloat(mapSize.width * tileSize - tileSize)
        mapHeight = CGFloat(mapSize.height * tileSize - tileSize)
        mapWidth2 = mapSize.width

        TILE_SIZE = CGFloat(tileSize)
        collisionOffset = TILE_SIZE / 2

        xPos = x
        yPos = y

        node = SKSpriteNode(imageNamed: "ship.png")
        node.setScale(0.5)
        node.position.x = screenWidth / 2
        node.position.y = screenHeight / 2
        node.zPosition = 1

        // Pixel in middle of a screen
        hitbox = SKShapeNode(rectOf: CGSize(width: 1, height: 1))
        hitbox.setScale(4)
        hitbox.fillColor = SKColor.blue
        hitbox.lineWidth = 0
        hitbox.position.x = screenWidth / 2
        hitbox.position.y = screenHeight / 2
        hitbox.zPosition = 3

        addToScene()

        // self.node.anchorPoint = CGPoint(0.5, 0.5)
    }
    
    /// Tick player movement.
    /// - Parameters:
    ///   - deltaTime: time interval from previous tick
    ///   - movementAngle: movement angle from joystick
    ///   - rotationAngle:  movement angle from joystick
    ///   - canMove: can move (true/false)
    func tick(deltaTime: TimeInterval, movementAngle: CGFloat, rotationAngle: CGFloat, canMove: Bool) {
        if canMove {
            rotate(angle: rotationAngle)
            move(angle: movementAngle, deltaTime: deltaTime)
        }
    }
    
    /// Rotates player by given angle
    /// - Parameter angle: rotration angle
    func rotate(angle: CGFloat) {
        node.zRotation = -angle

        var degrees = Float(angle * 180 / .pi)
        if degrees < 0 {
            degrees = 360 + degrees
        }

        // CONSIDERING REPLACING ROTATION WITH 8 SPRITES AND WALK ANIMATION
        /*
         if degrees < 22.5 {
             node.texture = SKTexture(imageNamed: "ManUp.png")
         } else if degrees < 67.5 {
             let rightMovement = ["ManR0.png", "ManR0-1.png", "ManR0.png", "ManR0-2.png"]
             node.texture = SKTexture(imageNamed: rightMovement[animationIndex])
         } else if degrees < 112.5 {
             let rightMovement = ["ManRight.png", "ManRight1.png", "ManRight.png", "ManRight2.png"]
             node.texture = SKTexture(imageNamed: rightMovement[animationIndex])
         } else if degrees < 157.5 {
             node.texture = SKTexture(imageNamed: "ManR1.png")
         } else if degrees < 202.5 {
             node.texture = SKTexture(imageNamed: "ManDown.png")
         } else if degrees < 247.5 {
             node.texture = SKTexture(imageNamed: "ManR2.png")
         } else if degrees < 292.5 {
             node.texture = SKTexture(imageNamed: "ManLeft.png")
         } else if degrees < 327.5 {
             node.texture = SKTexture(imageNamed: "ManR3.png")
         } else {
             node.texture = SKTexture(imageNamed: "ManUp.png")
         }*/

    }
    
    /// Add pplayer noides to scene
    func addToScene() {
        scene.addChild(node)
        // scene.addChild(titleNode)
        // scene.addChild(hitbox)
    }
    
    /// Move player by baseed on given angle
    /// - Parameters:
    ///   - angle: movement angle
    ///   - deltaTime: time from prevoous tick
    func move(angle: CGFloat, deltaTime: TimeInterval) {
        let xMove = (speed * CGFloat(deltaTime)) * cos(angle)
        let yMove = (speed * CGFloat(deltaTime)) * sin(angle)
        moveWithCollision(xMov: xMove, yMov: yMove)
    }
    
    /// Move player and checks the collision
    /// - Parameters:
    ///   - xMov: x to move by
    ///   - yMov: y to move by
    func moveWithCollision(xMov: CGFloat, yMov: CGFloat) {
        // TODO: divide into multiple functions

        let oldOnTeleport = onTeleport
        onTeleport = false
        let oldOnTravel = onTravel
        onTravel = false

        // center of Player: xPos, yPos
        // corners: (list of offsets from center [0, 0])
        let corners = [[-8, -8], [8, -8], [-8, 8], [8, 8]] // [[0, 0]]

        let xBefore = CGFloat(xPos)
        let yBefore = CGFloat(yPos)

        var xMove = xMov
        var yMove = yMov

        var xDir = CGFloat(1)
        if xMove < 0 {
            xDir = -1
        }
        var yDir = CGFloat(1)
        if yMove < 0 {
            yDir = -1
        }

        let lastMoveX = abs(xMove).truncatingRemainder(dividingBy: 1) * xDir
        let lastMoveY = abs(yMove).truncatingRemainder(dividingBy: 1) * yDir
        // move by 1 to avoid skiping small obstacles in high speed
        while xMove != 0 || yMove != 0 {
            var xCollision = true
            var yCollision = true
            if abs(xMove) < 1 {
                xMove = 0
                xCollision = false
            }
            if abs(yMove) < 1 {
                yMove = 0
                yCollision = false
            }
            // check colision for all hitboxes (corners)
            for offset in corners {
                xCollision = xCollision && checkXCollision(xOff: offset[0], yOff: offset[1], xMove: xDir)
                yCollision = yCollision && checkYCollision(xOff: offset[0], yOff: offset[1], yMove: yDir)
            }
            if xCollision {
                xPos += xDir
                xMove -= xDir
            } else {
                xMove = 0
            }
            if yCollision {
                yPos += yDir
                yMove -= yDir
            } else {
                yMove = 0
            }
        }
        // Move by rest < 1
        var xCollision = true
        var yCollision = true
        // check colision for all hitboxes (corners)
        for offset in corners {
            xCollision = xCollision && checkXCollision(xOff: offset[0], yOff: offset[1], xMove: lastMoveX)
            yCollision = yCollision && checkYCollision(xOff: offset[0], yOff: offset[1], yMove: lastMoveY)
        }

        if xCollision {
            xPos += lastMoveX
        }
        if yCollision {
            yPos += lastMoveY
        }

        // Move animation
        let xChange = CGFloat(abs(xBefore - xPos))
        let yChange = CGFloat(abs(yBefore - yPos))
        fromLastAnim += xChange + yChange
        if fromLastAnim >= animationRate {
            animationIndex += 1
            if animationIndex == animationCount {
                animationIndex = 0
            }
            fromLastAnim -= animationRate
        }

        if onTravel && !oldOnTravel { // to step travel only once
            print("Found doors")
            level.foundDoor(x: Int(xPos), y: Int(yPos))
        } else if onTeleport && !oldOnTeleport { // to step on teleport only once
            print("Found teleport")
            level.foundTeleport(x: Int(xPos), y: Int(yPos))
        }
    }
    
    /// Check colllision on x axis
    /// - Parameters:
    ///   - xOff: current x
    ///   - yOff: current y
    ///   - xMove: x to move by
    /// - Returns: if no colision occured
    func checkXCollision(xOff: Int, yOff: Int, xMove: CGFloat) -> Bool {
        var newIndex: Int
        if xMove != 0 {
            let xMagic = xPos + collisionOffset + CGFloat(xOff) + xMove
            let yMagic = yPos + collisionOffset + CGFloat(yOff)
            newIndex = Int(yMagic / TILE_SIZE) * mapWidth2 + Int(xMagic / TILE_SIZE)
            if tiles[newIndex].id == 2 ||  tiles[newIndex].id == 18{ // coin
                print("Found coin")
                tiles[newIndex].disappearTile()
                level.foundCoin(newIndex: newIndex)
            }
            if tiles[newIndex].id == 8 {                
                onTeleport = true                
            }
            if tiles[newIndex].id > 2 && tiles[newIndex].id < 7 { // doors
                onTravel = true                
            }
            if tiles[newIndex].isSolid {
                return false // Collision detected
            }
        }
        return true
    }
    
    /// Check colllision on y axis
    /// - Parameters:
    ///   - xOff: current x
    ///   - yOff: current y
    ///   - yMove: y to move by
    /// - Returns: if no colision occured
    func checkYCollision(xOff: Int, yOff: Int, yMove: CGFloat) -> Bool {
        var newIndex: Int
        if yMove != 0 {
            let xMagic = xPos + collisionOffset + CGFloat(xOff)
            let yMagic = yPos + collisionOffset + CGFloat(yOff) + yMove
            newIndex = Int(yMagic / TILE_SIZE) * mapWidth2 + Int(xMagic / TILE_SIZE)
            if tiles[newIndex].id == 2 {                
                tiles[newIndex].disappearTile()
                level.foundCoin(newIndex: newIndex)
            }
            if tiles[newIndex].id == 8 {                
                onTeleport = true                
            }
            if tiles[newIndex].id > 2 && tiles[newIndex].id < 7 { // doors
                onTravel = true                
            }
            if tiles[newIndex].isSolid {
                return false // Collision detected
            }
        }
        return true
    }
    
    /// Moves player to tile on if index
    /// - Parameter tileIndex: index of tile
    func travelOnTile(tileIndex: Int) {
        let tile = tiles[tileIndex]
        xPos = CGFloat(tile.x)
        yPos = CGFloat(tile.y)
    }

    // Getters and setters:

    func setTiles(tiles: [Tile]) {
        self.tiles = tiles
    }

    func getX() -> CGFloat {
        return xPos
    }

    func getY() -> CGFloat {
        return yPos
    }

    func setOnTeleport() {
        onTeleport = true
    }
}
