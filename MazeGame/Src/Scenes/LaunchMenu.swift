//
//  LaunchMenu.swift
//  MazeGame
//
//  Created by Richard Plesnik on 12/08/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit

/// Cass representing game launch menu
class LaunchMenu {
    // old orange UIColor(red: 1, green: 62 / 255, blue: 39 / 255, alpha: 1) // ff6e27//UIColor.black

    private var scene: MenuScene!
    var titleNode: SKLabelNode!
    var startButtonNode: SKSpriteNode!
    var startButtonLabel: SKLabelNode!
    var endButtonNode: SKSpriteNode!
    var endButtonLabel: SKLabelNode!

    // Sude buttons
    var dailyRewardButton: SKSpriteNode!
    var shopButton: SKSpriteNode!
    var achivementsButton: SKSpriteNode!
    var equipmentButton: SKSpriteNode!
    var dailyRewardLabel: SKLabelNode!
    var shopLabel: SKLabelNode!
    var achivementsLabel: SKLabelNode!
    var equipmentLabel: SKLabelNode!

    private var buttonColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27

    private var size: CGSize!
    
    /// Class construtor
    /// - Parameter scene: manu scene
    init(scene: MenuScene) {
        self.scene = scene
        size = scene.size

        titleNode = SKLabelNode()
        startButtonNode = SKSpriteNode()
        startButtonLabel = SKLabelNode()
        endButtonNode = SKSpriteNode()
        endButtonLabel = SKLabelNode()

        titleNode = SKLabelNode(fontNamed: "Arial")
        titleNode.text = "Maze"
        titleNode.fontColor = buttonColor
        titleNode.fontSize = 45
        titleNode.position = CGPoint(x: size.width / 2, y: size.height - titleNode.fontSize - 4)
        titleNode.zPosition = 3

        startButtonNode = SKSpriteNode()
        startButtonNode.name = "StartButton"
        startButtonNode.color = buttonColor
        startButtonNode.size = CGSize(width: 250, height: 55)
        startButtonNode.position = CGPoint(x: size.width / 2, y: size.height / 2 + 40)
        startButtonNode.zPosition = 2

        startButtonLabel = SKLabelNode(fontNamed: "Arial")
        startButtonLabel.name = "startButtonLabel"
        startButtonLabel.text = "Play"
        startButtonLabel.fontColor = UIColor.black
        startButtonLabel.verticalAlignmentMode = .center
        startButtonLabel.horizontalAlignmentMode = .center
        startButtonLabel.zPosition = 3

        endButtonNode = SKSpriteNode()
        endButtonNode.name = "EndButton"
        endButtonNode.color = buttonColor
        endButtonNode.size = CGSize(width: 250, height: 55)
        endButtonNode.position = CGPoint(x: size.width / 2, y: size.height / 2 - 40)
        endButtonNode.zPosition = 2

        endButtonLabel = SKLabelNode(fontNamed: "Arial")
        endButtonLabel.name = "endButtonLabel"
        endButtonLabel.text = "Quit"
        endButtonLabel.fontColor = UIColor.black
        endButtonLabel.verticalAlignmentMode = .center
        endButtonLabel.horizontalAlignmentMode = .center
        endButtonLabel.zPosition = 3

        startButtonNode.addChild(startButtonLabel)
        endButtonNode.addChild(endButtonLabel)

        // Side buttons
        let buttonSize = 50
        let buttonOffset = CGFloat(80)
        let textSize = CGFloat(20)
        let textOffset = CGFloat(28) + textSize
        //let textColor = buttonColor

        dailyRewardButton = SKSpriteNode()
        dailyRewardButton.name = "dailyRewardButton"
        dailyRewardButton.texture = SKTexture(imageNamed: "dailyRewardButton")
        dailyRewardButton.size = CGSize(width: buttonSize, height: buttonSize)
        dailyRewardButton.position = CGPoint(x: buttonOffset, y: size.height / 2 + buttonOffset)
        dailyRewardButton.zPosition = 2
        dailyRewardLabel = SKLabelNode(fontNamed: "Arial")
        dailyRewardLabel.name = "dailyRewardLabel"
        dailyRewardLabel.text = "Daily Reward"
        dailyRewardLabel.fontSize = textSize
        dailyRewardLabel.fontColor = buttonColor
        dailyRewardLabel.position = CGPoint(x: dailyRewardButton.position.x, y: dailyRewardButton.position.y - textOffset)
        dailyRewardLabel.zPosition = 3

        shopButton = SKSpriteNode()
        shopButton.name = "shopButton"
        shopButton.texture = SKTexture(imageNamed: "shopButton")
        shopButton.size = CGSize(width: buttonSize, height: buttonSize)
        shopButton.position = CGPoint(x: size.width - buttonOffset, y: size.height / 2 + buttonOffset)
        shopButton.zPosition = 2
        shopLabel = SKLabelNode(fontNamed: "Arial")
        shopLabel.name = "shopLabel"
        shopLabel.text = "Shop"
        shopLabel.fontSize = textSize
        shopLabel.fontColor = buttonColor
        shopLabel.position = CGPoint(x: shopButton.position.x, y: shopButton.position.y - textOffset)
        shopLabel.zPosition = 3

        achivementsButton = SKSpriteNode()
        achivementsButton.name = "achivementsButton"
        achivementsButton.texture = SKTexture(imageNamed: "achivementsButton")
        achivementsButton.size = CGSize(width: buttonSize, height: buttonSize)
        achivementsButton.position = CGPoint(x: buttonOffset, y: size.height / 2 - buttonOffset)
        achivementsButton.zPosition = 2
        achivementsLabel = SKLabelNode(fontNamed: "Arial")
        achivementsLabel.name = "achivementsLabel"
        achivementsLabel.text = "Achivements"
        achivementsLabel.fontSize = textSize
        achivementsLabel.fontColor = buttonColor
        achivementsLabel.position = CGPoint(x: achivementsButton.position.x, y: achivementsButton.position.y - textOffset)
        achivementsLabel.zPosition = 3

        equipmentButton = SKSpriteNode()
        equipmentButton.name = "equipmentButton"
        equipmentButton.texture = SKTexture(imageNamed: "equipmentButton")
        equipmentButton.size = CGSize(width: buttonSize, height: buttonSize)
        equipmentButton.position = CGPoint(x: size.width - buttonOffset, y: size.height / 2 - buttonOffset)
        equipmentButton.zPosition = 2
        equipmentLabel = SKLabelNode(fontNamed: "Arial")
        equipmentLabel.name = "equipmentLabel"
        equipmentLabel.text = "Equipment"
        equipmentLabel.fontSize = textSize
        equipmentLabel.fontColor = buttonColor
        equipmentLabel.position = CGPoint(x: equipmentButton.position.x, y: equipmentButton.position.y - textOffset)
        equipmentLabel.zPosition = 3
    }
    
    /// Add launch menu childrens to scene
    func addChildrens() {
        scene.removeAllChildren()
        scene.addChild(titleNode)
        scene.addChild(startButtonNode)
        scene.addChild(endButtonNode)

        scene.addChild(dailyRewardButton)
        scene.addChild(dailyRewardLabel)
        scene.addChild(shopButton)
        scene.addChild(shopLabel)
        scene.addChild(achivementsButton)
        scene.addChild(achivementsLabel)
        scene.addChild(equipmentButton)
        scene.addChild(equipmentLabel)
    }
    
    /// Calculate menu clicks
    /// - Parameter touch: click locaiton
    func tick(touch: CGPoint) {
        let nodesArray = scene.nodes(at: touch)

        let buttonName = nodesArray.first?.name

        if buttonName == "StartButton" || buttonName == "startButtonLabel" {
            scene.changeState(state: 1)
        } else if buttonName == "EndButton" || buttonName == "endButtonLabel" {
            exit(0)
        } else if buttonName == "dailyRewardButton" || buttonName == "dailyRewardLabel" {
            print("Daily reward clicked")
        } else if buttonName == "shopButton" || buttonName == "shopLabel" {
            print("Shop clicked")
            scene.changeState(state: 3)
        } else if buttonName == "achivementsButton" || buttonName == "achivementsLabel" {
            print("Achivements clicked")
        } else if buttonName == "equipmentButton" || buttonName == "equipmentLabel" {
            print("Equipment clicked")
            scene.changeState(state: 2)
        }
    }
}
