//
//  UpgradeFrame.swift
//  MazeGame
//
//  Created by Richard Plesnik on 29/09/2020.
//  Copyright © 2020  Richard Plesnik. All rights reserved.
//

import SpriteKit

/// Class representing upgrade frame
class UpgradeFrame {
    private var frame: SKShapeNode!
    private var icon: SKSpriteNode!
    private var abilityName: SKLabelNode!

    private var scene: MenuScene!

    private var position: CGPoint!

    private var size: CGSize!

    private var orangeColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27
    private var grayColor = UIColor(red: 33 / 255, green: 33 / 255, blue: 33 / 255, alpha: 1)
    private var coverColor = UIColor(red: 33 / 255, green: 33 / 255, blue: 33 / 255, alpha: 0.5)

    private var abilityId: Int!

    private var abilityLevels: [Int]

    let frameWidth = CGFloat(150)
    let iconSize = CGFloat(54)
    let frameHeight = CGFloat(56)
    var fontSize = CGFloat(28)
    
    /// Class constructor
    /// - Parameters:
    ///   - scene: manu scen
    ///   - size: frame size
    ///   - position: frame position
    ///   - abilityId: frame ability id
    ///   - abilityLevels: ability levels
    init(scene: MenuScene, size: CGSize!, position: CGPoint, abilityId: Int, abilityLevels: [Int]) {
        self.scene = scene
        self.position = position
        self.size = size
        self.abilityId = abilityId
        self.abilityLevels = abilityLevels

        let frameWidth = CGFloat(150)
        let iconSize = CGFloat(54)
        let frameHeight = CGFloat(iconSize + 2)
        frame = SKShapeNode(rectOf: CGSize(width: frameWidth, height: frameHeight))
        frame.lineWidth = 3
        frame.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        frame.strokeColor = orangeColor
        frame.position = CGPoint(x: position.x, y: position.y)
        icon = SKSpriteNode()
        if abilityId == -1 {
            icon.texture = SKTexture(imageNamed: "emptyAbility-64")
        } else {
            icon.texture = SKTexture(imageNamed: ABILITY_TEXTURES_NAMES[abilityId])
        }

        icon.size = CGSize(width: iconSize, height: iconSize)
        icon.position = CGPoint(x: -frameWidth / 2 + iconSize / 2, y: 0)
        icon.zPosition = 4

        abilityName = SKLabelNode(fontNamed: "Arial")

        abilityName.fontColor = orangeColor
        abilityName.fontSize = fontSize
        updateText()
        abilityName.zPosition = 5
        frame.addChild(icon)
        frame.addChild(abilityName)

        if abilityId == -1 {
            let grayFrame = SKShapeNode(rectOf: CGSize(width: frameWidth, height: frameHeight))
            grayFrame.lineWidth = 3
            grayFrame.fillColor = coverColor
            grayFrame.strokeColor = coverColor
            grayFrame.position = CGPoint(x: 0, y: 0)
            grayFrame.zPosition = 6
            frame.addChild(grayFrame)
        }
    }

    /// Add menu childrens to scene
    func addChildrens() {
        scene.addChild(frame)
    }

    /// Calculate menu clicks
    /// - Parameter touch: touch position
    func tick(touch: CGPoint) -> Int {
        let nodesArray = scene.nodes(at: touch)

        let button = nodesArray.first

        if button == frame || button == icon || button == abilityName {
            return abilityId
        } else {
            return -1
        }
    }

    
    /// Update ability levels text
    /// - Parameter abilityLevels: ability levels
    func updateLevels(abilityLevels: [Int]) {
        self.abilityLevels = abilityLevels
        updateText()
    }

    /// Update upgrade window text
    func updateText() {
        abilityName.fontSize = fontSize
        if abilityId == -1 {
            abilityName.text = "Empty"
        } else if abilityLevels[abilityId] == 0 {
            abilityName.fontSize = 25
            abilityName.text = "Locked"
        } else {
            abilityName.text = "Lvl. \(abilityLevels[abilityId])"
        }
        abilityName.position = CGPoint(x: iconSize + abilityName.frame.width / 2 - frameWidth / 2 + 6, y: -fontSize / 2)
    }
}
