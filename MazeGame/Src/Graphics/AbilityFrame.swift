//
//  AbilityFrame.swift
//  MazeGame
//
//  Created by Richard Plesnik on 07/09/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit

/// Class for ability frame in menu
class AbilityFrame {
    private var scene: MenuScene!
    private var size: CGSize!
    private var order: CGFloat!

    private var abilityIndex: Int!

    private var status = 0

    private var topFrame: SKShapeNode!
    private var mainFrame: SKShapeNode!

    private var abilityIcon: SKSpriteNode!
    private var abilityName: SKLabelNode!
    private var arrowText: SKLabelNode!
    private var descriptionText: SKLabelNode!

    private var optionFrames: [SKShapeNode]
    private var optionIcons: [SKSpriteNode]
    private var optionNames: [SKLabelNode]

    private var orangeColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1)

    private var textureNames = ["coinAbility-64", "magnetAbility-64", "teleportAbility-64", "backAbility-64"]
    private var abilityNames = ["Path Finder", "Magnet", "Teleport", "Mid Travel"]
    
    
    /// Class constructor
    /// - Parameters:
    ///   - scene: scene to render
    ///   - size: size of frame
    ///   - order: order of frame in manu
    ///   - abilityIndex: index of current ability
    init(scene: MenuScene, size: CGSize, order: CGFloat, abilityIndex: Int) {
        self.scene = scene
        self.abilityIndex = abilityIndex
        self.size = size
        self.order = order

        let frameOffset = CGFloat(50)
        let frameWidth = (size.width - frameOffset) / 3
        let frameHeight = CGFloat(192 + 16)
        let yOffset = CGFloat(30)
        mainFrame = SKShapeNode(rectOf: CGSize(width: frameWidth, height: frameHeight))
        mainFrame.lineWidth = 3
        mainFrame.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        mainFrame.strokeColor = orangeColor
        mainFrame.position = CGPoint(x: frameOffset / 2 + frameWidth / 2 + order * frameWidth, y: frameHeight / 2 + yOffset)

        let frameHeight2 = CGFloat(46 + 2)
        topFrame = SKShapeNode(rectOf: CGSize(width: frameWidth, height: frameHeight2))
        topFrame.lineWidth = 3
        topFrame.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        topFrame.strokeColor = orangeColor
        topFrame.position = CGPoint(x: frameOffset / 2 + frameWidth / 2 + order * frameWidth, y: mainFrame.position.y + frameHeight / 2 + frameHeight2 / 2)
        let iconSize = CGFloat(46) // 46
        abilityIcon = SKSpriteNode()
        abilityIcon.texture = SKTexture(imageNamed: textureNames[abilityIndex])
        abilityIcon.size = CGSize(width: iconSize, height: iconSize)
        abilityIcon.position = CGPoint(x: frameOffset / 2 + iconSize / 2 + CGFloat(order) * frameWidth + 1, y: frameHeight + yOffset + iconSize / 2 + 1)
        abilityIcon.zPosition = 4

        abilityName = SKLabelNode(fontNamed: "Arial") // Courier Oblique 68   w.0
        abilityName.text = abilityNames[abilityIndex]
        abilityName.fontColor = orangeColor
        abilityName.fontSize = 24
        abilityName.position = CGPoint(x: frameOffset / 2 + CGFloat(order) * frameWidth + abilityName.frame.width / 2 + iconSize + 3, y: abilityIcon.position.y - iconSize / 2 + abilityName.fontSize / 2)
        abilityName.zPosition = 5

        arrowText = SKLabelNode(fontNamed: "Arial") // Courier Oblique 68   w.0
        arrowText.text = "▼" // ▼ ▽ ▾ ▿ ⇩ ↓ ⤵︎ ↴
        arrowText.fontColor = orangeColor
        arrowText.fontSize = 22
        arrowText.position = CGPoint(x: mainFrame.position.x + frameWidth / 2 - 14, y: abilityIcon.position.y - iconSize / 2 + abilityName.fontSize / 2)
        arrowText.zPosition = 5

        let descriptionOffset = CGFloat(4)
        descriptionText = SKLabelNode(fontNamed: "Arial")
        descriptionText.text = ABILITY_DESCRIPTIONS[abilityIndex]
        descriptionText.fontColor = orangeColor
        descriptionText.fontSize = 20
        descriptionText.zPosition = 5
        descriptionText.lineBreakMode = NSLineBreakMode.byWordWrapping
        descriptionText.numberOfLines = 8
        descriptionText.preferredMaxLayoutWidth = frameWidth - 2 * descriptionOffset
        descriptionText.position = CGPoint(x: mainFrame.position.x - frameWidth / 2 + descriptionText.frame.size.width / 2 + descriptionOffset, y: mainFrame.position.y + frameHeight / 2 - descriptionText.frame.size.height - 5)

        optionFrames = []
        optionIcons = []
        optionNames = []
        let borderSize = CGFloat(2)
        for i in 0 ... 3 {
            let newFrame = SKShapeNode(rectOf: CGSize(width: frameWidth, height: frameHeight2))
            newFrame.lineWidth = 3
            newFrame.fillColor = UIColor(red: 56 / 255, green: 62 / 255, blue: 101 / 255, alpha: 0.3)
            // newFrame.fillColor = UIColor(red: 0, green: 0, blue: 0.5, alpha: 1)
            newFrame.strokeColor = orangeColor
            newFrame.position = CGPoint(x: topFrame.position.x, y: topFrame.position.y + CGFloat(i + 1) * -frameHeight2)
            optionFrames.append(newFrame)

            let newIcon = SKSpriteNode()
            newIcon.texture = SKTexture(imageNamed: textureNames[i])
            newIcon.size = CGSize(width: iconSize, height: iconSize)
            newIcon.position = CGPoint(x: frameOffset / 2 + iconSize / 2 + CGFloat(order) * frameWidth + 1, y: abilityIcon.position.y + CGFloat(i + 1) * -(iconSize + borderSize))
            newIcon.zPosition = 4
            optionIcons.append(newIcon)

            let newName = SKLabelNode(fontNamed: "Arial")
            newName.text = abilityNames[i]
            newName.fontColor = orangeColor
            newName.fontSize = 24
            newName.position = CGPoint(x: frameOffset / 2 + CGFloat(order) * frameWidth + newName.frame.width / 2 + iconSize + 3, y: abilityName.position.y + CGFloat(i + 1) * -(iconSize + borderSize))
            newName.zPosition = 5
            optionNames.append(newName)
        }
    }
    
    /// Add ability frame to scene
    func addToScene() {
        if status == 0 {
            scene.addChild(topFrame)
            scene.addChild(mainFrame)
            scene.addChild(abilityIcon)
            scene.addChild(abilityName)
            scene.addChild(arrowText)
            scene.addChild(descriptionText)
        }
        if status == 1 { // vyber
            scene.addChild(topFrame)
            scene.addChild(mainFrame)
            scene.addChild(abilityIcon)
            scene.addChild(abilityName)
            scene.addChild(arrowText)
            for optionFrame in optionFrames {
                scene.addChild(optionFrame)
            }
            for optionIcon in optionIcons {
                scene.addChild(optionIcon)
            }
            for optionName in optionNames {
                scene.addChild(optionName)
            }
        }
    }
    
    /// Remove ability frame to scene
    func removeFromScene() {
        if status == 0 {
            topFrame.removeFromParent()
            mainFrame.removeFromParent()
            abilityIcon.removeFromParent()
            abilityName.removeFromParent()
            arrowText.removeFromParent()
            descriptionText.removeFromParent()
        }
        if status == 1 {
            topFrame.removeFromParent()
            mainFrame.removeFromParent()
            abilityIcon.removeFromParent()
            abilityName.removeFromParent()
            arrowText.removeFromParent()
            for optionFrame in optionFrames {
                optionFrame.removeFromParent()
            }
            for optionIcon in optionIcons {
                optionIcon.removeFromParent()
            }
            for optionName in optionNames {
                optionName.removeFromParent()
            }
        }
    }
    
    /// React on click on ability frame adn calculate change.
    /// - Parameter touch: point of click/touch
    /// - Returns: return 0, 1 or (2, index before, index after) on change
    func tick(touch: CGPoint) -> Int {
        let nodesArray = scene.nodes(at: touch)

        let node = nodesArray.first

        if node == abilityName || node == abilityIcon || node == arrowText || node == topFrame {
            abilityClicked()
            return 1 // hide others
        }
        if status == 1 {
            var clickedAbility = -1
            for i in 0 ... (optionFrames.count - 1) {
                if optionFrames[i] == node || optionIcons[i] == node || optionNames[i] == node {
                    clickedAbility = i
                    break
                }
            }
            if clickedAbility != -1 {
                print("Clicked ability with index: ", clickedAbility)
                if clickedAbility == abilityIndex {
                    abilityClicked()
                    return 0
                } else {
                    var output = 200
                    output += 10 * abilityIndex
                    abilityChanged(newIndex: clickedAbility)
                    abilityClicked()
                    output += abilityIndex
                    return output // 2, index before, index after
                }
            }
        }

        return 0
    }
    
    /// Called when ability is clicked
    func abilityClicked() {
        removeFromScene()
        changeAbility()
        addToScene()
    }
    
    /// Reset ability menu
    func resetMenu() {
        removeFromScene()
        if status == 1 {
            arrowText.text = "▼"
            arrowText.fontColor = orangeColor
            abilityName.fontColor = orangeColor
            status = 0
        }
        addToScene()
    }
    
    /// Change frame appereance based on its state
    func changeAbility() {
        if status == 0 {
            arrowText.text = "▲"
            arrowText.fontColor = UIColor.gray
            abilityName.fontColor = UIColor.gray
            status = 1
        } else {
            arrowText.text = "▼"
            arrowText.fontColor = orangeColor
            abilityName.fontColor = orangeColor
            status = 0
        }
    }
    
    /// Called after abiilty was changed
    /// - Parameter newIndex: new ability index
    func abilityChanged(newIndex: Int) {
        abilityIndex = newIndex

        let frameOffset = CGFloat(50)
        let descriptionOffset = CGFloat(4)
        let iconSize = CGFloat(46) // 46
        let frameWidth = (size.width - frameOffset) / 3
        let frameHeight = CGFloat(192 + 16)
        abilityIcon.texture = SKTexture(imageNamed: textureNames[abilityIndex])

        abilityName.text = abilityNames[abilityIndex]
        abilityName.position = CGPoint(x: frameOffset / 2 + CGFloat(order) * frameWidth + abilityName.frame.width / 2 + iconSize + 3, y: abilityIcon.position.y - iconSize / 2 + abilityName.fontSize / 2)

        arrowText.text = "▼" // ▼ ▽ ▾ ▿ ⇩ ↓ ⤵︎ ↴
        arrowText.position = CGPoint(x: mainFrame.position.x + frameWidth / 2 - 14, y: abilityIcon.position.y - iconSize / 2 + abilityName.fontSize / 2)

        descriptionText.text = ABILITY_DESCRIPTIONS[abilityIndex]
        descriptionText.position = CGPoint(x: mainFrame.position.x - frameWidth / 2 + descriptionText.frame.size.width / 2 + descriptionOffset, y: mainFrame.position.y + frameHeight / 2 - descriptionText.frame.size.height - 5)
    }
}
