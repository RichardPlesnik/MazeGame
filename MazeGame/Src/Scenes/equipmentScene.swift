//
//  equipmentScene.swift
//  CustomGame3
//
//  Created by Richard on 07/09/2020.
//  Copyright © 2020 R. All rights reserved.
//

import SpriteKit

class EquipmentMenu {
    // old orange UIColor(red: 1, green: 62 / 255, blue: 39 / 255, alpha: 1) // ff6e27//UIColor.black

    private var scene: MenuScene!

    var titleNode: SKLabelNode!

    var playButtonNode: SKSpriteNode!
    var playButtonLabel: SKLabelNode!

    var backButton: SKSpriteNode!
    var backButtonLabel: SKLabelNode!

    var leftArrow: SKSpriteNode!
    var leftArrowLabel: SKLabelNode!
    var rightArrow: SKSpriteNode!
    var rightArrowLabel: SKLabelNode!

    var statusLabel1: SKLabelNode!
    var statusLabel2: SKLabelNode!
    var sizeLabel: SKLabelNode!
    var coinsLabel: SKLabelNode!
    var actualTime1: SKLabelNode!
    var bestTime: SKLabelNode!

    private var canStart = true
    // var bestTimeLabel: SKLabelNode! // pokud ne played -> "No time"
    // var actualTimeLabel: SKLabelNode!

    var mapFrame: SKShapeNode!

    private var buttonColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27
    private var unactiveButtonColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 0.5) // UIColor(red: 215 / 255, green: 70 / 255, blue: 0 / 255, alpha: 1) // ff6e27
    private var unactiveBlack = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.5)

    private var size: CGSize!

    private var mapFileLoader: MapFileLoader!

    private var mapData: [MapData]
    private var mapIndex = 0

    init(scene: MenuScene) {
        self.scene = scene
        size = scene.size

        mapFileLoader = MapFileLoader()
        mapData = []
        mapData = mapFileLoader.getMaps()

        titleNode = SKLabelNode(fontNamed: "Arial")
        titleNode.text = mapData[mapIndex].name
        titleNode.fontColor = buttonColor
        titleNode.fontSize = 45
        titleNode.position = CGPoint(x: size.width / 2, y: size.height - titleNode.fontSize - 20)
        titleNode.zPosition = 3

        playButtonNode = SKSpriteNode()
        playButtonNode = SKSpriteNode()
        playButtonNode.name = "playButton"
        playButtonNode.color = buttonColor
        playButtonNode.size = CGSize(width: 250, height: 55)
        playButtonNode.position = CGPoint(x: size.width / 2, y: 40 + 2)
        playButtonNode.zPosition = 2
        playButtonLabel = SKLabelNode()
        playButtonLabel = SKLabelNode(fontNamed: "Arial")
        playButtonLabel.name = "playButtonLabel"
        playButtonLabel.text = "Start level"
        playButtonLabel.fontColor = UIColor.black
        playButtonLabel.verticalAlignmentMode = .center
        playButtonLabel.horizontalAlignmentMode = .center
        playButtonLabel.zPosition = 3
        playButtonNode.addChild(playButtonLabel)

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

        mapFrame = SKShapeNode(rectOf: CGSize(width: 350, height: 200))
        mapFrame.lineWidth = 3
        mapFrame.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        mapFrame.strokeColor = buttonColor

        mapFrame.position = CGPoint(x: size.width / 2, y: size.height / 2)

        leftArrow = SKSpriteNode()
        leftArrow = SKSpriteNode()
        leftArrow.name = "leftArrow"
        leftArrow.color = buttonColor
        leftArrow.size = CGSize(width: 50, height: 50)
        leftArrow.position = CGPoint(x: mapFrame.position.x - mapFrame.frame.width / 2 - 15 - 20, y: size.height / 2)
        leftArrow.zPosition = 2
        leftArrowLabel = SKLabelNode(fontNamed: "Arial")
        leftArrowLabel.name = "leftArrowLabel"
        leftArrowLabel.text = "<"
        leftArrowLabel.fontColor = UIColor.black
        leftArrowLabel.verticalAlignmentMode = .center
        leftArrowLabel.horizontalAlignmentMode = .center
        leftArrowLabel.zPosition = 3
        leftArrow.addChild(leftArrowLabel)

        rightArrow = SKSpriteNode()
        rightArrow = SKSpriteNode()
        rightArrow.name = "rightArrow"
        rightArrow.color = buttonColor
        rightArrow.size = CGSize(width: 50, height: 50)
        rightArrow.position = CGPoint(x: mapFrame.position.x + mapFrame.frame.width / 2 + 15 + 20, y: size.height / 2)
        rightArrow.zPosition = 2
        rightArrowLabel = SKLabelNode(fontNamed: "Arial")
        rightArrowLabel.name = "rightArrowLabel"
        rightArrowLabel.text = ">"
        rightArrowLabel.fontColor = UIColor.black
        rightArrowLabel.verticalAlignmentMode = .center
        rightArrowLabel.horizontalAlignmentMode = .center
        rightArrowLabel.zPosition = 3
        rightArrow.addChild(rightArrowLabel)

        statusLabel1 = SKLabelNode(fontNamed: "Arial")
        statusLabel1.text = "Status: "
        statusLabel1.fontColor = buttonColor
        statusLabel1.zPosition = 3

        statusLabel2 = SKLabelNode(fontNamed: "Arial")
        statusLabel2.fontColor = buttonColor
        statusLabel2.zPosition = 3

        sizeLabel = SKLabelNode(fontNamed: "Arial")
        sizeLabel.fontColor = buttonColor
        sizeLabel.zPosition = 3

        coinsLabel = SKLabelNode(fontNamed: "Arial")
        coinsLabel.fontColor = buttonColor
        coinsLabel.zPosition = 3

        actualTime1 = SKLabelNode(fontNamed: "Arial")
        actualTime1.fontColor = buttonColor
        actualTime1.zPosition = 3

        bestTime = SKLabelNode(fontNamed: "Arial")
        bestTime.fontColor = buttonColor
        bestTime.zPosition = 3

        mapFrame.addChild(statusLabel1)
        mapFrame.addChild(sizeLabel)
        mapFrame.addChild(coinsLabel)
        statusLabel1.addChild(statusLabel2)
        mapFrame.addChild(actualTime1)
        mapFrame.addChild(bestTime)


    }

    func addChildrens() {
        scene.removeAllChildren()
        scene.addChild(titleNode)
        scene.addChild(playButtonNode)
        scene.addChild(backButton)
        scene.addChild(mapFrame)
        scene.addChild(leftArrow)
        scene.addChild(rightArrow)
    }

    func tick(touch: CGPoint) {
        let nodesArray = scene.nodes(at: touch)

        let buttonName = nodesArray.first?.name

        if buttonName == "playButton" || buttonName == "playButtonLabel" {
        } else if buttonName == "backButton" || buttonName == "backButtonLabel" {
            scene.changeState(state: 0)
        } else if buttonName == "leftArrow" || buttonName == "leftArrowLabel" {
        } else if buttonName == "rightArrow" || buttonName == "rightArrowLabel" {
        }
    }
}
