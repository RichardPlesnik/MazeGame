//
//  mapPlan.swift
//  MazeGame
//
//  Created by Richard Plesnik on 11/08/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit

/// Class for representing map part image
class PartImage {
    var part: SKSpriteNode!
    var frame: SKSpriteNode!
    var middle: SKSpriteNode!

    var label: SKLabelNode!

    private var partIndex: Int!

    var teleports: [SKSpriteNode]!

    var scene: GameScene!
    private var level: Level!

    var name: String

    var mapWidth: Int!
    var mapHeight: Int!

    let portColor = UIColor(red: 115 / 255, green: 255 / 255, blue: 254 / 255, alpha: 1)

    private var borderSize: Int

    private var teleportFounds: [Bool]!
    
    /// Class constructor
    /// - Parameters:
    ///   - scene: game scene
    ///   - level: level pointer
    ///   - size: map size
    ///   - xPos: x position
    ///   - yPos: y position
    ///   - borderSize: border size
    ///   - name: name
    ///   - partIndex: part index
    init(scene: GameScene, level: Level, size: CGFloat, xPos: Int, yPos: Int, borderSize: Int, name: String, partIndex: Int) {
        self.scene = scene
        self.level = level
        self.name = name
        self.borderSize = borderSize
        self.partIndex = partIndex

        part = SKSpriteNode()
        part.name = name
        part.color = UIColor(red: 56 / 255, green: 62 / 255, blue: 101 / 255, alpha: 1) // 383e65
        part.size = CGSize(width: size, height: size)
        part.anchorPoint = CGPoint(x: 0, y: 0)
        part.position = CGPoint(x: xPos, y: yPos)
        part.zPosition = 5

        frame = SKSpriteNode()
        frame.name = "border"
        frame.color = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27
        frame.size = CGSize(width: Int(size) + borderSize, height: Int(size) + borderSize)
        frame.anchorPoint = CGPoint(x: 0, y: 0)
        frame.position = CGPoint(x: xPos - borderSize / 2, y: yPos - borderSize / 2)
        frame.zPosition = 4

        middle = SKSpriteNode()
        middle.name = "mid" // parse podle Name
        middle.color = UIColor.red
        middle.size = CGSize(width: size / 10, height: size / 10)
        middle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        middle.position = CGPoint(x: CGFloat(xPos) + size / 2, y: CGFloat(yPos) + size / 2)
        middle.zPosition = 5

        label = SKLabelNode(fontNamed: "Arial") // Courier Oblique 68   w.0
        label.fontSize = size / 5
        label.fontColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27
        label.position = CGPoint(x: part.position.x + size / 2, y: part.position.y + size / 2 + size / 10)
        label.zPosition = 6

        teleports = []
        let topPort = SKSpriteNode()
        topPort.name = "topPort"
        let rightPort = SKSpriteNode()
        rightPort.name = "rightPort"
        let botPort = SKSpriteNode()
        botPort.name = "botPort"
        let leftPort = SKSpriteNode()
        leftPort.name = "leftPort"
        teleports.append(topPort)
        teleports.append(rightPort)
        teleports.append(botPort)
        teleports.append(leftPort)

        for port in teleports {
            port.color = portColor // UIColor(red: 115, green: 255 / 255, blue: 254 / 255, alpha: 1) // 73fffe  UIColor.blue
            port.size = CGSize(width: size / 10, height: size / 10)
            port.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            port.zPosition = 6
            port.position.x = 0
            port.position.y = 0
        }

        // part.lineWidth = 20

        // part.drawBorder(color: UIColor.red, width: 20)
    }
    
    /// Add map plan to scene
    func addToScene() {
        scene.addChild(part)
        scene.addChild(frame)
        scene.addChild(middle)
        scene.addChild(label)
        for port in teleports {
            if port.position.x != 0 {
                scene.addChild(port)
            }
        }
    }

    // Remove map plan from scene
    func removeFromScene() {
        part.removeFromParent()
        frame.removeFromParent()
        middle.removeFromParent()
        label.removeFromParent()
        for port in teleports {
            if port.position.x != 0 {
                port.removeFromParent()
            }
        }
    }

    // Calculate teleports
    func tick(fingerPosition: CGPoint, nodesArray: [SKNode], button: SKNode) {
        var spawnIndex = -1

        if button == middle && teleportFounds[0] && middle.color != UIColor.green { // zamezi teleportu na cervene a zelene
            // print("Tp mid")
            spawnIndex = 0
        } else if button == teleports[0] && teleports[0].color != UIColor.green {
            // print("Tp up")
            spawnIndex = 1
        } else if button == teleports[1] && teleports[1].color != UIColor.green {
            // print("Tp right")
            spawnIndex = 2
        } else if button == teleports[2] && teleports[2].color != UIColor.green {
            // print("Tp down")
            spawnIndex = 3
        } else if button == teleports[3] && teleports[3].color != UIColor.green {
            // print("Tp left")
            spawnIndex = 4
        }
        if spawnIndex != -1 {
            scene.resetMove()
            level.travel(partIndex: partIndex, spawnIndex: spawnIndex)
            level.reloadScreen()
        }
    }

    
    /// Steped on teleport
    /// - Parameter dataPart: map part
    func stepped(dataPart: MapPart) {
        resetColors()
        for (i, found) in dataPart.teleportFounds.enumerated() {
            if found && i != 0 {
                // calculate relative position
                let absX = dataPart.teleportPos[i - 1].x
                let absY = dataPart.teleportPos[i - 1].y
                let relX = part.position.x + (absX / CGFloat(mapWidth)) * part.size.width
                let relY = part.position.y + (absY / CGFloat(mapHeight)) * part.size.height

                teleports[i - 1].position.x = relX
                teleports[i - 1].position.y = relY
            } else if found {
                middle.color = portColor
            }
        }

        label.text = "\(dataPart.coinCount)/10₵" // ¢₵₵₵₵¢₵
        if dataPart.coinCount == 10 {
            label.fontColor = UIColor.green
        }

        teleportFounds = dataPart.teleportFounds
    }

    
    /// Reset teleport colors
    func resetColors() {
        for port in teleports {
            port.color = portColor
        }
    }
}


/// Class making one map from all the parts
class MapPicture {
    var mapParts: [PartImage]!
    // pole jmen?
    var names = ["part0", "part1", "part2", "part3", "part4", "part5", "part6", "part7", "part8"]
    private var screenWidth: CGFloat!
    private var screenHeight: CGFloat!
    private var scene: GameScene!
    private var size = CGFloat(100.0)

    private var level: Level!
    private var ui: UI!

    var cancelButton: SKSpriteNode!

    private var borderSize = 10

    
    /// Class constructor
    /// - Parameters:
    ///   - scene: game scene
    ///   - level: level pointer
    ///   - ui: ui pointer
    ///   - screenWidth: screen width
    ///   - screenHeight: screen height
    init(scene: GameScene, level: Level, ui: UI, screenWidth: CGFloat, screenHeight: CGFloat) {
        self.scene = scene
        self.level = level
        self.ui = ui
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight

        mapParts = []

        // set position to whole map by middle value
        let xMid = screenWidth / 2
        let yMid = screenHeight / 2
        let x1 = Int(xMid - size * 1.5)
        let x2 = Int(xMid - size * 0.5) + Int(borderSize / 2)
        let x3 = Int(xMid + size * 0.5) + Int(borderSize)
        let y1 = Int(yMid - size * 1.5)
        let y2 = Int(yMid - size * 0.5) + Int(borderSize / 2)
        let y3 = Int(yMid + size * 0.5) + Int(borderSize)

        mapParts.append(PartImage(scene: scene, level: level, size: size, xPos: x1, yPos: y3, borderSize: borderSize, name: names[0], partIndex: 0))
        mapParts.append(PartImage(scene: scene, level: level, size: size, xPos: x2, yPos: y3, borderSize: borderSize, name: names[1], partIndex: 1))
        mapParts.append(PartImage(scene: scene, level: level, size: size, xPos: x3, yPos: y3, borderSize: borderSize, name: names[2], partIndex: 2))

        mapParts.append(PartImage(scene: scene, level: level, size: size, xPos: x1, yPos: y2, borderSize: borderSize, name: names[3], partIndex: 3))
        mapParts.append(PartImage(scene: scene, level: level, size: size, xPos: x2, yPos: y2, borderSize: borderSize, name: names[4], partIndex: 4))
        mapParts.append(PartImage(scene: scene, level: level, size: size, xPos: x3, yPos: y2, borderSize: borderSize, name: names[5], partIndex: 5))

        mapParts.append(PartImage(scene: scene, level: level, size: size, xPos: x1, yPos: y1, borderSize: borderSize, name: names[6], partIndex: 6))
        mapParts.append(PartImage(scene: scene, level: level, size: size, xPos: x2, yPos: y1, borderSize: borderSize, name: names[7], partIndex: 7))
        mapParts.append(PartImage(scene: scene, level: level, size: size, xPos: x3, yPos: y1, borderSize: borderSize, name: names[8], partIndex: 8))

        for mapPart in mapParts {
            mapPart.mapWidth = level.getMapWidth()
            mapPart.mapHeight = level.getMapHeight()
        }

        cancelButton = SKSpriteNode()
        cancelButton.name = "cancelButton"
        // cancelButton.color = UIColor(red: 1, green: 0, blue: 0, alpha: 1) // ff0000
        cancelButton.texture = SKTexture(imageNamed: "cross32")
        cancelButton.size = CGSize(width: size / 4, height: size / 4)
        cancelButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        cancelButton.position = CGPoint(x: x1, y: y3 + Int(size))
        cancelButton.zPosition = 5
    }
    
    /// Add to scene
    func addToScene() {
        for part in mapParts {
            part.addToScene()
        }
        scene.addChild(cancelButton)
    }
    
    /// Remove from scene
    func removeFromScene() {
        for part in mapParts {
            part.removeFromScene()
        }
        cancelButton.removeFromParent()
    }
    
    /// Calculates map clicks
    /// - Parameters:
    ///   - fingerPosition: click posiiton
    ///   - nodesArray: array of nodes
    ///   - button: clicked node
    func tick(fingerPosition: CGPoint, nodesArray: [SKNode], button: SKNode) {
        let buttonName = button.name

        if buttonName == "cancelButton" {
            print("Cancel pressed")
            ui.teleportPause = false

            level.stillRender = false
            level.unpause()

            scene.resetMove()
            level.reloadScreen()
        }

        for part in mapParts {
            part.tick(fingerPosition: fingerPosition, nodesArray: nodesArray, button: button)
        }
    }

    
    /// Called after steping on teleport
    func steped() {
        let dataParts = level.getParts()
        for (i, part) in mapParts.enumerated() {
            part.stepped(dataPart: dataParts[i])
        }

        let border = CGFloat((level.getMapWidth() - 3 * TILE_SIZE) - 32)
        let x = level.getPlayerPos().x
        let y = level.getPlayerPos().y
        var teleportIndex = 0

        if y > border { // top spawn
            teleportIndex = 1
        } else if x > border { // right spawn
            teleportIndex = 2
        } else if y < 96 { // bottom spawn
            teleportIndex = 3
        } else if x < 93 { // left spawn
            teleportIndex = 4
        }
        if teleportIndex == 0 {
            mapParts[level.getPartIndex()].middle.color = UIColor.green
        } else {
            mapParts[level.getPartIndex()].teleports[teleportIndex - 1].color = UIColor.green
        }
    }
}
