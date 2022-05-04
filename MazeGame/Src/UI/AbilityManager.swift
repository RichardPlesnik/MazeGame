//
//  AbilityManager.swift
//  MazeGame
//
//  Created by Richard Plesnik on 29/08/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit

// TODO: refactor for easier adding of new abilities

/// Class for managing in game abilities
class AbilityManager {
    private var screenWidth: CGFloat!
    private var screenHeight: CGFloat!

    private var scene: GameScene!
    private var level: Level!

    // Abilities:
    private var coinPath: CoinPath!
    private var magnet: Magnet!
    private var teleport: Teleport!

    private var tpActivated = false
    private var magnetActivated = false

    private var magnetNode: SKSpriteNode!

    private var buttonSize = CGFloat(50)
    private var frameSize = CGFloat(50)
    private var borederSize = CGFloat(6) // 4
    private var gridYPos = CGFloat(140)

    private var orangeColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27
    private var greenColor = UIColor(red: 0 / 255, green: 204 / 255, blue: 0 / 255, alpha: 1) // ff6e27

    private var topFrame: SKShapeNode!
    private var centerFrame: SKShapeNode!
    private var botFrame: SKShapeNode!

    var frames: [SKShapeNode] = []
    var fills: [SKSpriteNode] = []
    var buttons: [SKSpriteNode] = []
    private var textureNames = ["coinAbility-64", "magnetAbility-64", "teleportAbility-64", "backAbility-64"]
    private var maxCooldowns = [45.0, 15.0, 20.0, 5.0]
    private var lastUsed = [0.0, 0.0, 0.0, 0.0]

    private var midX: CGFloat!
    private var midY: CGFloat!

    private var abilityIndexes: [Int]
    private var abilityButtons: [AbilityButton] = []

    // private var abilityButton: SKSpriteNode!

    private var lastTime: TimeInterval = -10
    
    /// Constructor
    /// - Parameters:
    ///   - scene: game scene
    ///   - level: level pointer
    ///   - screenWidth: screen width
    ///   - screenHeight: scree heigh
    ///   - abilityIndexes: ability indexes
    init(scene: GameScene, level: Level, screenWidth: CGFloat, screenHeight: CGFloat, abilityIndexes: [Int]) {
        self.scene = scene
        self.level = level
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight

        coinPath = CoinPath(tileMap: level.getTileMap())
        magnet = Magnet(tileMap: level.getTileMap(), screenWidth: screenWidth, screenHeight: screenHeight, level: level)
        teleport = Teleport(tileMap: level.getTileMap(), screenWidth: screenWidth, screenHeight: screenHeight, level: level)

        midX = screenWidth / 2
        midY = screenHeight / 2

        gridYPos = midY - 40

        magnetNode = SKSpriteNode(texture: SKTexture(imageNamed: "magnet.png"))
        magnetNode.size = CGSize(width: 32, height: 32)
        magnetNode.position = CGPoint(x: midX, y: midY)
        magnetNode.zPosition = 5

        self.abilityIndexes = abilityIndexes

        initMaxCooldowns()
        var frameIndex = 0
        for index in abilityIndexes {
            let abilityButton = AbilityButton(abilityId: index, frameOrder: frameIndex, screenWidth: screenWidth, screenHeight: screenHeight, scene: scene, maxCooldown: maxCooldowns[index])
            abilityButtons.append(abilityButton)
            frameIndex += 1
        }

        addToScene()
    }

    
    /// Calculate abilities
    /// - Parameter fingerPosition:finger position
    func tick(fingerPosition: CGPoint) {
        let nodesArray = scene.nodes(at: fingerPosition)
        let buttonName = nodesArray.first?.name

        let actualIndex = getIndexByName(aName: buttonName ?? "none")
        
        // change?
        var actualAbility: AbilityButton = AbilityButton(abilityId: 0, frameOrder: 0, screenWidth: 0, screenHeight: 0, scene: scene, maxCooldown: maxCooldowns[0])
        if actualIndex != -1 {
            actualAbility = abilityButtons[actualIndex]
        }

        if buttonName == "coinAbility-64" {
            scene.resetMove()

            if !actualAbility.getCooldown() {
                level.showNotification(text: "No cooldown", time: 1000)
                return
            }

            if level.getCoinCount() >= 10 {
                level.showNotification(text: "All 10 coins found", time: 1000)
                return
            }

            let pPos = level.getPlayerPos()
            coinPath.findPath(xPos: pPos.x, yPos: pPos.y)

            actualAbility.redFrame()
            actualAbility.setLastUsed(time: level.getTime())

            level.setCooldowns()
        }
        if buttonName == "magnetAbility-64" {
            // dekativace predchozi ability
            if teleport.canTeleport != 0 {
                teleport.canTeleport = 0
                teleport.resetMark()
                tpActivated = false
            }

            scene.resetMove()
            if !actualAbility.getCooldown() {
                level.showNotification(text: "No cooldown", time: 1000)
                return
            }

            if magnet.canMagnet != 0 {
                magnet.canMagnet = 0
                magnetActivated = false
                magnetNode.removeFromParent()
                // actualAbility.setLastUsed(time: level.getTime())
                actualAbility.redFrame()
            } else {
                magnet.canMagnet = 1

                // frames[aIndex].strokeColor = UIColor.red
                // lastUsed[aIndex] = level.getTime()

                magnetActivated = true
                actualAbility.blueFrame()
            }
        }
        if buttonName == "teleportAbility-64" {
            // dekativace predchozi ability
            if magnet.canMagnet != 0 {
                magnet.canMagnet = 0
                magnetActivated = false
                magnetNode.removeFromParent()
            }

            scene.resetMove()
            if !actualAbility.getCooldown() {
                level.showNotification(text: "No cooldown", time: 1000)
                return
            }

            if teleport.canTeleport != 0 {
                teleport.canTeleport = 0
                teleport.resetMark()
                tpActivated = false

                actualAbility.redFrame()
                // actualAbility.setLastUsed(time: level.getTime())
            } else {
                teleport.canTeleport = 1

                tpActivated = true
                actualAbility.blueFrame()
            }
        }
        if buttonName == "backAbility-64" {
            scene.resetMove()
            if !actualAbility.getCooldown() {
                level.showNotification(text: "No cooldown", time: 1000)
                return
            }
            actualAbility.redFrame()
            actualAbility.setLastUsed(time: level.getTime())
            print("back ability activated")
            level.playerOnSpawn()
            level.resetMove()
        }

        teleportTick(fingerPosition: fingerPosition)
        magnetTick(fingerPosition: fingerPosition)
    }
    
    /// Calculate teleport ability
    /// - Parameter fingerPosition: finger position
    func teleportTick(fingerPosition: CGPoint) {
        if teleport.canTeleport != 0 {
            let pos = level.getPlayerPos()
            if teleport.changeTile(playerX: pos.x, playerY: pos.y, fingerPosition: fingerPosition, nodes: scene.nodes(at: fingerPosition)) {
                let actualIndex = getIndexByName(aName: "teleportAbility-64")
                let actualAbility = abilityButtons[actualIndex]
                actualAbility.setLastUsed(time: level.getTime())
                actualAbility.redFrame()
                level.setCooldowns()
                tpActivated = false
            }
        }
    }

    /// Calculate magnet ability
    /// - Parameter fingerPosition: finger position
    func magnetTick(fingerPosition: CGPoint) {
        if magnet.canMagnet != 0 {
            tickRotation(fingerPosition: fingerPosition)
            let pos = level.getPlayerPos()
            if magnet.changeTile(playerX: pos.x, playerY: pos.y, fingerPosition: fingerPosition, nodes: scene.nodes(at: fingerPosition)) {
                let actualIndex = getIndexByName(aName: "magnetAbility-64")
                let actualAbility = abilityButtons[actualIndex]
                actualAbility.setLastUsed(time: level.getTime())
                magnetActivated = false
                level.setCooldowns()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.magnetNode.removeFromParent()
                    self.tickRotation(fingerPosition: CGPoint(x: self.midX + 1, y: self.midY))
                }
            }
        }
    }

    /// Calculate lcation ability
    /// - Parameter fingerPosition: finger position
    func tickRotation(fingerPosition: CGPoint) {
        if magnet.canMagnet != 0 {
            let rotationAngle = -atan2(fingerPosition.x - midX, fingerPosition.y - midY)
            let movementAngle = atan2(fingerPosition.y - midY, fingerPosition.x - midX)
            magnetNode.zRotation = rotationAngle
            magnetNode.position.x = midX + 30 * cos(movementAngle)
            magnetNode.position.y = midY + 30 * sin(movementAngle)
        }
    }

    /// Calculate ability cooldowns
    func tickTime() {
        let actualTime = level.getTime()

        for abilityButton in abilityButtons {
            abilityButton.tickCooldowns(time: actualTime)
        }

        if tpActivated {
            let actualIndex = getIndexByName(aName: "teleportAbility-64")
            let actualAbility = abilityButtons[actualIndex]
            actualAbility.blueFrame()
            // botFrame.strokeColor = UIColor.blue
        }
        if magnetActivated {
            let actualIndex = getIndexByName(aName: "magnetAbility-64")
            let actualAbility = abilityButtons[actualIndex]
            actualAbility.blueFrame()
        }
    }
    
    /// Add ability manager to scene
    func addToScene() {
        for abilityButton in abilityButtons {
            abilityButton.addToScene()
        }
        if magnetActivated {
            scene.addChild(magnetNode)
        }
    }
    
    /// Remove from scene
    func removeFromScene() {
        centerFrame.removeFromParent()
    }

    
    /// Reset teleport
    func tpReset() {
        tpActivated = false
    }
    
    /// Remove path after finding coin
    func foundCoin() {
        coinPath.removePath()
    }
    
    /// Calculate teleport cooldown
    func tpCooldown() {
        let actualIndex = getIndexByName(aName: "teleportAbility-64")
        let actualAbility = abilityButtons[actualIndex]

        actualAbility.setLastUsed(time: level.getTime())
        // lastUsed[aIndex] = level.getTime()
        level.setCooldowns()
        tpActivated = false
    }
    
    /// Initalazie cooldowns
    func initMaxCooldowns() {
        let profileLoader = ProfileLoader()
        let levels = profileLoader.getUnclocks()

        for (i, level) in levels.enumerated() {
            maxCooldowns[i] = Double(ABILITY_COOLDOWNS[i][level])
        }
    }
    
    //Getters and setters:
    
    func getIndexByName(aName: String) -> Int {
        var abilityId = -1 //
        for (i, name) in textureNames.enumerated() {
            if name == aName {
                abilityId = i
                break
            }
        }
        for (i, id) in abilityIndexes.enumerated() {
            if id == abilityId {
                return i
            }
        }
        return -1
    }

    func getAbilityById(id: Int) -> Int {
        for (i, abilityButton) in abilityButtons.enumerated() {
            if abilityButton.getId() == id {
                return i
            }
        }
        return -1
    }
    
    func getCooldowns() -> [Double] {
        for index in abilityIndexes {
            if index < 3 {
                lastUsed[index] = abilityButtons[index].getLastUsed()
            }
        }
        return lastUsed
    }

    func setCooldowns(cooldowns: [Double]) {
        lastUsed = cooldowns
        for (index, lst) in lastUsed.enumerated() {
            let i = getAbilityById(id: index)
            if i != -1 {
                abilityButtons[i].setLastUsed(time: lst)
            }
        }
    }
    
}
