//
//  AbilityButton.swift
//  MazeGame
//
//  Created by Richard Plesnik on 26/09/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit


/// Class representing single ability button in ability panel
class AbilityButton {
    private var scene: GameScene!
    private var screenWidth: CGFloat!
    private var screenHeight: CGFloat!

    private var greenColor = UIColor(red: 0 / 255, green: 204 / 255, blue: 0 / 255, alpha: 1) // ff6e27

    private var abilityId: Int!
    private var frameOrder: Int!

    private var frame: SKShapeNode!
    private var img: SKSpriteNode!
    private var fill: SKSpriteNode!

    private var textureNames = ["coinAbility-64", "magnetAbility-64", "teleportAbility-64", "backAbility-64"]
    private var maxCooldowns = [45.0, 15.0, 20.0, 5.0]
    private var maxCooldown: Double!
    private var gotCooldown = true
    private var lastUsed = 0.0

    private var buttonSize = CGFloat(50)
    private var frameSize = CGFloat(50)
    private var borederSize = CGFloat(6) // 4
    private var gridYPos = CGFloat(140)
    private var yStart: CGFloat!
    
    /// Class constructor
    /// - Parameters:
    ///   - abilityId: ability id
    ///   - frameOrder: frame order in panel
    ///   - screenWidth: screen width
    ///   - screenHeight: screen heiht
    ///   - scene: game scene
    ///   - maxCooldown: ability cooldown
    init(abilityId: Int, frameOrder: Int, screenWidth: CGFloat, screenHeight: CGFloat, scene: GameScene, maxCooldown: Double) {
        self.abilityId = abilityId
        self.frameOrder = frameOrder
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self.scene = scene
        self.maxCooldown = maxCooldown
        print("created ability with id: ", abilityId, " and cooldown: ", maxCooldown)

        yStart = gridYPos + frameSize + borederSize / 2 + borederSize / 2 - 0.5
        let midY = screenHeight / 2
        gridYPos = midY - 40
        let yMove = frameSize + borederSize / 2 + borederSize / 2 - 0.5

        frame = SKShapeNode(rectOf: CGSize(width: frameSize, height: frameSize), cornerRadius: 0)
        frame.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        frame.strokeColor = UIColor.red
        frame.lineWidth = borederSize
        frame.position = CGPoint(x: screenWidth - frameSize / 2 - borederSize / 2, y: yStart - yMove * CGFloat(frameOrder))
        frame.zPosition = 5

        img = SKSpriteNode()
        img.name = textureNames[abilityId]
        img.texture = SKTexture(imageNamed: textureNames[abilityId])
        img.size = CGSize(width: buttonSize, height: buttonSize)
        img.zPosition = 6
        frame.addChild(img)

        fill = SKSpriteNode()
        fill.name = textureNames[abilityId]
        fill.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        fill.size = CGSize(width: buttonSize, height: 0)
        fill.anchorPoint = CGPoint(x: 0.5, y: 1)
        fill.position.y = buttonSize / 2
        fill.zPosition = 7
        frame.addChild(fill)
    }
    
    /// Add button to scene
    func addToScene() {
        scene.addChild(frame)
    }
    
    
    /// Calculate cooldown
    /// - Parameter time: time
    func tickCooldowns(time: TimeInterval) {
        let actualTime = time

        if actualTime - lastUsed > Double(maxCooldown) {
            frame.strokeColor = greenColor
            gotCooldown = true

        } else {
            frame.strokeColor = UIColor.red
            gotCooldown = false
            fill.size.height = frameSize * CGFloat(1 - (actualTime - lastUsed) / maxCooldown)
        }
    }
    
    /// Change frame color to red
    func redFrame() {
        frame.strokeColor = UIColor.red
    }
    
    /// Change frame color to blue
    func blueFrame() {
        frame.strokeColor = UIColor.blue
    }
    
    // Getters and setters
    
    func getId() -> Int {
        return abilityId
    }

    func getCooldown() -> Bool {
        return gotCooldown
    }

    func setLastUsed(time: TimeInterval) {
        lastUsed = time
    }

    func getLastUsed() -> TimeInterval {
        return lastUsed
    }
    
}
