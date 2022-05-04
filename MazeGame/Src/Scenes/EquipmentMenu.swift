//
//  equipmentScene.swift
//  MazeGame
//
//  Created by Richard Plesnik on 07/09/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit

/// Class representing qeuipment menu
class EquipmentMenu {
    // old orange UIColor(red: 1, green: 62 / 255, blue: 39 / 255, alpha: 1) // ff6e27//UIColor.black

    private var scene: MenuScene!

    private var titleNode: SKLabelNode!
    private var backButton: SKSpriteNode!
    private var backButtonLabel: SKLabelNode!

    private var size: CGSize!

    private var buttonColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27
    private var unactiveButtonColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 0.5)
    private var unactiveBlack = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.5)

    private var abilityIndexes = [0, 1, 2] // indexy aktualne vybranych abilit
    private var profileLoader: ProfileLoader!

    private var textureNames = ["coinAbility-64", "magnetAbility-64", "teleportAbility-64"]
    private var abilityNames = ["Path Finder", "Magnet", "Teleport"]

    private var abililtyFrames: [AbilityFrame]

    
    /// Class constructor
    /// - Parameters:
    ///   - scene: menu scene
    ///   - profileLoader: progile loader pointer
    init(scene: MenuScene, profileLoader: ProfileLoader) {
        self.scene = scene
        size = scene.size

        titleNode = SKLabelNode(fontNamed: "Arial")
        titleNode.text = "Equipment"
        titleNode.fontColor = buttonColor
        titleNode.fontSize = 45
        titleNode.position = CGPoint(x: size.width / 2, y: size.height - titleNode.fontSize - 4)
        titleNode.zPosition = 3

        backButton = SKSpriteNode()
        backButton = SKSpriteNode()
        backButton.name = "backButton"
        backButton.color = buttonColor
        backButton.size = CGSize(width: 130, height: 46)
        backButton.position = CGPoint(x: 65, y: size.height - 23)
        backButton.zPosition = 2
        backButtonLabel = SKLabelNode(fontNamed: "Arial")
        backButtonLabel.name = "backButtonLabel"
        backButtonLabel.text = "< Back"
        backButtonLabel.fontColor = UIColor.black
        backButtonLabel.verticalAlignmentMode = .center
        backButtonLabel.horizontalAlignmentMode = .center
        backButtonLabel.zPosition = 3
        backButton.addChild(backButtonLabel)

        self.profileLoader = profileLoader

        // profileLoader = ProfileLoader()
        abilityIndexes = []
        for index in profileLoader.getIndexes() {
            abilityIndexes.append(index)
        }

        abililtyFrames = []
        for i in 0 ... 2 {
            let newFrame = AbilityFrame(scene: scene, size: size, order: CGFloat(i), abilityIndex: abilityIndexes[i])
            abililtyFrames.append(newFrame)
        }
    }
    
    /// Add menu childrens to scene
    func addChildrens() {
        scene.removeAllChildren()
        scene.addChild(titleNode)
        scene.addChild(backButton)
        for abililtyFrame in abililtyFrames {
            abililtyFrame.addToScene()
        }
    }

    /// Calculate menu clicks
    /// - Parameter touch: touch position
    func tick(touch: CGPoint) {
        let nodesArray = scene.nodes(at: touch)

        let buttonName = nodesArray.first?.name

        if buttonName == "backButton" || buttonName == "backButtonLabel" {
            scene.changeState(state: 0)
        }
        var changeIndex = -1
        var abilityOutput = -1
        for (i, abilityFrame) in abililtyFrames.enumerated() {
            abilityOutput = abilityFrame.tick(touch: touch)
            if abilityOutput == 1 {
                changeIndex = i
            }
            if abilityOutput >= 200 {
                changeIndex = i
                break
            }
        }
        if abilityOutput >= 200 {
            let newIndex = abilityOutput % 10
            let oldIndex = abilityOutput % 100 / 10
            for (i, num) in abilityIndexes.enumerated() {
                if num == newIndex { // zmena v pripade kolize
                    abililtyFrames[i].abilityChanged(newIndex: oldIndex)
                    abilityIndexes[i] = oldIndex
                    break
                }
            }
            abilityIndexes[changeIndex] = newIndex
            profileLoader.changeIndexes(indexes: abilityIndexes)
            profileLoader.saveData()
        }
        if changeIndex != -1 {
            for (i, abilityFrame) in abililtyFrames.enumerated() {
                if i != changeIndex {
                    abilityFrame.resetMenu()
                }
            }
        }
    }
}
